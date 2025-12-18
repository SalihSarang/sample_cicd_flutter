import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:week_28/core/const/constants.dart';
import 'package:week_28/features/google_auth/domain/models/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week_28/features/google_auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSource({
    required this.auth,
    required this.googleSignIn,
    required this.firestore,
  });

  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) return;
    try {
      debugPrint('Saving user to Firestore: ${user.uid}');
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoUrl': user.photoURL,
            'lastSignIn': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      debugPrint('User successfully saved to Firestore');
    } catch (e) {
      debugPrint('Error saving user to Firestore: $e');
      // We don't rethrow here to allow authentication to succeed even if firestore fails
    }
  }

  Future<UserEntity?> signInWithGoogle() async {
    try {
      final user = await googleSignIn.signIn();

      if (user == null) {
        debugPrint('Google Sign-In aborted by user');
        return null;
      }

      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        _saveUserToFirestore(firebaseUser);
        return firebaseUser.toEntity();
      }
      return null;
    } catch (e) {
      debugPrint('Error in signInWithGoogle: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    try {
      await googleSignIn.disconnect();
    } catch (_) {}
    await auth.signOut();
  }

  Stream<UserEntity?> get userChanges {
    return auth.authStateChanges().map((user) => user?.toEntity());
  }

  Future<UserEntity?> getCurrentUser() async {
    final user = auth.currentUser;
    if (user != null) {
      // Ensure user is in Firestore even if they were already logged in
      await _saveUserToFirestore(user);
    }
    return user?.toEntity();
  }
}
