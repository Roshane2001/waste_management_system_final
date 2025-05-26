import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:waste_management_system_mobileapp/models/complaint_model.dart';
import 'package:waste_management_system_mobileapp/models/user_model.dart';
import 'package:waste_management_system_mobileapp/services/firebase_services.dart';

/// A provider class that manages user-related state and operations
/// Handles user authentication, profile management, and user data operations
class UserProvider extends ChangeNotifier {
  /// Current logged-in user's data
  UserModel? user;

  /// List of all doctors in the system
  List<UserModel> doctors = [];

  /// User's profile image file
  File? profileImage;

  /// Temporary storage for user updates
  UserModel? updatedUser;

  /// Loading state indicator
  bool isLoading = false;

  /// Firebase Auth instance
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  /// List of user's complaints
  List<ComplaintModel>? complaints;

  /// Firebase service instance for database operations
  final FirebaseService _firebaseService = FirebaseService();

  /// Registers a new user in the system
  /// Creates authentication account and user profile in Firestore
  Future<void> registerUser(UserModel newUser, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: newUser.userEmail,
        password: password,
      );

      String userId = authResult.user!.uid;

      user = UserModel(
        userName: newUser.userName,
        userEmail: newUser.userEmail,
        userId: userId,
        userPhoneNumber: newUser.userPhoneNumber,
        registeredDateTime: DateTime.now(),
        locationCordinates: newUser.locationCordinates,
        lastUpdatedDateTime: DateTime.now(),
        userType: newUser.userType,
        address: newUser.address,
      );

      await _firebaseService.uploadDocument("Users", user!, userId);
    } catch (error) {
      print("Error registering user: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Authenticates user and loads their profile data
  /// Throws error if authentication fails
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final resultUsers = await _firebaseService.getDocumentsWithField(
        collection: "Users",
        fieldName: "userEmail",
        fieldValue: email,
      );

      user = UserModel.fromMap(resultUsers!.docs.first);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Signs out the current user and clears user data
  Future<void> logout() async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.signOut();

      user = null;
      profileImage = null;

      print("User logged out successfully");
    } catch (error) {
      print("Error logging out: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches and loads the current user's data from Firestore
  /// Throws exception if no user is logged in or data not found
  Future<void> getUserData() async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in");
      }

      final userDoc = await _firebaseService.getDocumentDetails(
        "Users",
        currentUser.uid,
      );

      if (userDoc.exists) {
        user = UserModel.fromMap(userDoc);
        print("User Data: ${user?.userName}, ${user?.userEmail}");
      } else {
        throw Exception("User profile data not found");
      }
    } catch (error) {
      print("Error fetching user data: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Updates user's profile information
  /// Updates both local state and Firestore database
  Future<void> updateUserDetails({String? username, String? email}) async {
    try {
      isLoading = true;
      notifyListeners();

      if (user == null) {
        throw Exception("No user is logged in");
      }

      Map<String, dynamic> updatedData = {};

      updatedData['userName'] = username;
      updatedData['email'] = email;

      user = UserModel(
        userId: user!.userId,
        userName: updatedData['userName'],
        userEmail: updatedData['email'],
        locationCordinates: user!.locationCordinates,
        userPhoneNumber: user!.userPhoneNumber,
        registeredDateTime: user!.registeredDateTime,
        lastUpdatedDateTime: DateTime.now(),
        userType: user!.userType,
        address: user!.address,
      );

      await _firebaseService.updateField("Users", user!, user!.userId);

      print("User details updated successfully");
    } catch (error) {
      print("Error updating user details: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Initiates password reset process for the given email
  Future<void> resetPassword(String email) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseService.resetPassword(email);
    } catch (error) {
      print("Error resetting password: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Searches for a user by their email address
  /// Returns null if user not found
  Future<DocumentSnapshot?> findUserByEmail(String email) async {
    try {
      isLoading = true;
      notifyListeners();

      final querySnapshot = await _firebaseService.getDocumentsWithField(
        collection: "Users",
        fieldName: "email",
        fieldValue: email,
      );

      return querySnapshot?.docs.first;
    } catch (error) {
      print("Error finding user: $error");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches all users with type "Doctor" from the database
  /// Updates the doctors list with the results
  Future<void> getAllDoctors() async {
    try {
      isLoading = true;
      notifyListeners();

      final querySnapshot = await _firebaseService.getDocumentsWithField(
        collection: "Users",
        fieldName: "userType",
        fieldValue: "Doctor",
      );

      if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
        doctors =
            querySnapshot.docs.map((doc) => UserModel.fromMap(doc)).toList();
        print("Doctors: ${doctors.length}");
      } else {
        print("No doctors found");
      }
    } catch (error) {
      print("Error fetching doctors: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new complaint in the system
  /// Requires a logged-in user
  Future<void> createComplaint(ComplaintModel complain) async {
    try {
      isLoading = true;
      notifyListeners();

      if (user == null) {
        throw Exception("No user is logged in");
      }

      await _firebaseService.uploadDocumentAny(
        "Complaints",
        complain.toMap(),
        complain.complaintId,
      );
    } catch (error) {
      print("Error creating complaint: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchComplaints() async {
    try {
      isLoading = true;
      notifyListeners();

      final querySnapshot = await _firebaseService.getDocuments("Complaints");

      if (querySnapshot.docs.isNotEmpty) {
        complaints =
            querySnapshot.docs
                .map((doc) => ComplaintModel.fromMap(doc))
                .toList();
        print("Complaints: ${complaints!.length}");
      } else {
        print("No complaints found");
      }
    } catch (error) {
      print("Error fetching complaints: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
