import 'package:week_28/features/google_auth/domain/models/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Stream<UserEntity?> get userChanges;
  Future<UserEntity?> getCurrentUser();
}
