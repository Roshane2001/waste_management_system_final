//imported packages
import 'package:firebase_auth/firebase_auth.dart';

/// AuthService class for handling authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs up a new user with giving details
  /// Returns a success message or error message
  Future<String?> signUpUser({
    required String name,
    required String email,
    required String farmName,
    required String location,
    required String password,
  }) async {
    try {
      // Validate inputs before attempting signup
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return "Please fill in all required fields";
      }

      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Check if user is created successfully
      User? user = userCredential.user;

      if (user != null) {
        // Update user profile with display name
        await user.updateDisplayName(name.trim());
        
        // Optionally reload user to ensure profile updates are applied
        await user.reload();
        
        return "Sign Up Successful";
      }
      
      return "Sign Up Failed: User creation unsuccessful";
    } on FirebaseAuthException catch (e) {
      // Showing firebase authentication errors
      switch (e.code) {
        case 'weak-password':
          return "The password provided is too weak";
        case 'email-already-in-use':
          return "An account already exists with this email";
        case 'invalid-email':
          return "The email address is not valid";
        case 'operation-not-allowed':
          return "Email/password accounts are not enabled";
        default:
          return e.message ?? "An authentication error occurred";
      }
    } catch (e) {
      // Handle any other unexpected errors
      return "An unexpected error occurred: ${e.toString()}";
    }
  }

  /// Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Check if a user is signed in
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }
}