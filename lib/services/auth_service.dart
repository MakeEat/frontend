import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<(bool, String)> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (firestoreError) {
        debugPrint('Firestore error: $firestoreError');
      }

      notifyListeners();
      return (true, 'Success');
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred during signup';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid';
      }
      return (false, message);
    } catch (e) {
      return (false, e.toString());
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
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        
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
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();  // Sign out from Google if used
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
} 