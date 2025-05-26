//import the packages
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:waste_management_system_truckmobileapp/models/user_model.dart';
import 'package:waste_management_system_truckmobileapp/services/firebase_services.dart';

/// UserProvider class to manage user authentication and data
class UserProvider extends ChangeNotifier {
  UserModel? user;
  
  List<UserModel> doctors = [];

  File? profileImage;
  UserModel? updatedUser;
  bool isLoading = false;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  final FirebaseService _firebaseService = FirebaseService();

  //registering new user in the system
  Future<void> registerUser(UserModel newUser, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      // Check if the email is already registered
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: newUser.userEmail,
        password: password,
      );

      String userId = authResult.user!.uid;
      // Check if the user already exists in the database
      user = UserModel(
        userName: newUser.userName,
        userEmail: newUser.userEmail,
        userId: userId,
        registeredDateTime: DateTime.now(),
        lastUpdatedDateTime: DateTime.now(),
        userType: newUser.userType,
        password: password,
        vehicleNumber: newUser.vehicleNumber,
      );

      // Upload the user data to Firestore
      await _firebaseService.uploadDocument("Drivers", user!, userId);
    } catch (error) {
      print("Error registering user: $error");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //login user in the system Authenticates a user and loads their profile data
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      //
      final resultUsers = await _firebaseService.getDocumentsWithField(
        collection: "Users",
        fieldName: "userEmail",
        fieldValue: email,
      );

      final resultDoctors = await _firebaseService.getDocumentsWithField(
        collection: "Drivers",
        fieldName: "userEmail",
        fieldValue: email,
      );

      await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Load user data from appropriate collection
      if (resultDoctors != null && resultDoctors.docs.isNotEmpty) {
        user = UserModel.fromMap(resultDoctors.docs.first);
        notifyListeners();
      } else if (resultUsers != null && resultUsers.docs.isNotEmpty) {
        user = UserModel.fromMap(resultUsers.docs.first);
        notifyListeners();
      } else {
        throw Exception("User profile data not found");
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //logout user in the system
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

  //get user data from the system(data loading the users)
  Future<void> getUserData() async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        user = null;
        return;
      }

      final userDoc = await _firebaseService.getDocumentDetails(
        "Drivers",
        currentUser.uid,
      );

      if (userDoc.exists) {
        user = UserModel.fromMap(userDoc);
        print("User Data: ${user?.userName}, ${user?.userEmail}");
      } else {
        user = null;
      }
    } catch (error) {
      print("Error fetching user data: $error");
      user = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //update use profile data
  Future<void> updateUserDetails({String? username, String? email}) async {
    try {
      isLoading = true;
      notifyListeners();

      if (user == null) {
        throw Exception("No user is logged in");
      }

      // Check if the email is already registered
      Map<String, dynamic> updatedData = {};

      updatedData['userName'] = username;
      updatedData['email'] = email;

      user = UserModel(
        userId: user!.userId,
        userName: updatedData['userName'],
        userEmail: updatedData['email'],
        registeredDateTime: user!.registeredDateTime,
        lastUpdatedDateTime: DateTime.now(),
        userType: user!.userType,
        password: user!.password,
        vehicleNumber: user!.vehicleNumber,
      );

      // Update the user data in Firestore
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

  //user profile password rest 
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

  //find user by email
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
}
