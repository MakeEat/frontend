import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? get currentUser => _auth.currentUser;

  Future<(bool, String)> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Validate email format
      if (!email.contains('@') || !email.contains('.')) {
        return (false, 'Invalid email format');
      }
      
      // Validate password length
      if (password.length < 6) {
        return (false, 'Password must be at least 6 characters');
      }

      debugPrint('Starting authentication for: $email');
      
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      final User? user = result.user;
      if (user != null) {
        debugPrint('Successfully logged in user: ${user.email}');
        notifyListeners();
        return (true, 'Success');
      }
      return (false, 'Unknown error occurred');
      
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email address format.';
          break;
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        default:
          message = 'An error occurred: ${e.code}';
      }
      debugPrint('Firebase Auth Error: $message');
      return (false, message);
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return (false, 'An unexpected error occurred');
    }
  }

  Future<(bool, String)> signUpWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('\n=== SIGNUP PROCESS STARTED ===');
      debugPrint('Attempting signup for: $email');
      debugPrint('Password length: ${password.length}');

      debugPrint('Firebase Auth instance exists');
      debugPrint('Creating user account...');

      // Create user
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      debugPrint('Received response from Firebase');
      final User? user = userCredential.user;
      
      if (user != null) {
        debugPrint('SUCCESS: User created');
        debugPrint('User ID: ${user.uid}');
        debugPrint('Email: ${user.email}');
        notifyListeners();
        return (true, 'Account created successfully');
      } else {
        debugPrint('ERROR: User is null after creation');
        return (false, 'Failed to create user account');
      }

    } on FirebaseAuthException catch (e) {
      debugPrint('\n=== FIREBASE AUTH ERROR ===');
      debugPrint('Error Code: ${e.code}');
      debugPrint('Error Message: ${e.message}');
      debugPrint('Full Error: $e');
      
      switch (e.code) {
        case 'email-already-in-use':
          return (false, 'This email is already registered');
        case 'invalid-email':
          return (false, 'Invalid email format');
        case 'operation-not-allowed':
          return (false, 'Email/password signup is not enabled in Firebase Console');
        case 'weak-password':
          return (false, 'Password should be at least 6 characters');
        default:
          return (false, 'Error: ${e.message}');
      }
    } catch (e) {
      debugPrint('\n=== UNEXPECTED ERROR ===');
      debugPrint('Error Type: ${e.runtimeType}');
      debugPrint('Error Details: $e');
      return (false, 'An unexpected error occurred');
    }
  }

  Future<(bool, String)> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      
      googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
      googleProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');

      try {
        final UserCredential userCredential = 
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
        if (userCredential.user != null) {
          notifyListeners();
          return (true, 'Successfully signed in with Google');
        }
        return (false, 'Failed to sign in with Google');
      } catch (e) {
        print('Error during web Google sign in: $e');
        return (false, 'Error signing in with Google: ${e.toString()}');
      }
    } else {
      // Existing mobile implementation
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        
        if (googleUser == null) {
          return (false, 'Google Sign In was cancelled');
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        
        if (userCredential.user != null) {
          notifyListeners();
          return (true, 'Successfully signed in with Google');
        }
        return (false, 'Failed to sign in with Google');
      } catch (e) {
        return (false, 'Error signing in with Google: ${e.toString()}');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
} 