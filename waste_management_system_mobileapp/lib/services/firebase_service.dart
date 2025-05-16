import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firestore_service.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Starting login process...');
      print('Email: $email');

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Login successful for user: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during login: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        default:
          message = 'Authentication failed: ${e.message}';
      }
      throw message;
    } catch (e) {
      print('Unexpected error during login: $e');
      print('Error type: ${e.runtimeType}');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, Map<String, dynamic> userData) async {
    try {
      print('Starting registration process...');
      print('Email: $email');

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User created successfully with UID: ${userCredential.user?.uid}');

      // Create user document in Firestore
      await _firestoreService.createUserDocument(
        userCredential.user!.uid,
        userData,
      );

      print('User data added to Firestore successfully');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(
          'FirebaseAuthException during registration: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        default:
          message = 'An error occurred during registration: ${e.message}';
      }
      throw message;
    } catch (e) {
      print('Unexpected error during registration: $e');
      throw 'An unexpected error occurred during registration. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error signing out. Please try again.';
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      return await _firestoreService.getUserData(currentUser!.uid);
    } catch (e) {
      throw 'Error fetching user data. Please try again.';
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      await _firestoreService.updateUserData(currentUser!.uid, userData);
    } catch (e) {
      throw 'Error updating profile. Please try again.';
    }
  }

  // Show error dialog
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
