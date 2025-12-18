import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<UserEntity?> signInWithGoogle() async {
    try {
      final user = await googleSignIn.signIn();

      if (user == null) return null;

      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Create/Update user document in 'users' collection
        await firestore
            .collection(AppConstants.usersCollection)
            .doc(firebaseUser.uid)
            .set({
              'uid': firebaseUser.uid,
              'email': firebaseUser.email,
              'displayName': firebaseUser.displayName,
              'photoUrl': firebaseUser.photoURL,
              'lastSignIn': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        return firebaseUser.toEntity();
      }
      return null;
    } catch (e) {
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
    return auth.currentUser?.toEntity();
  }
}
