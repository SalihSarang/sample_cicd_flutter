import 'package:week_28/features/google_auth/data/data_source/google_auth_data_source.dart';
import 'package:week_28/features/google_auth/domain/models/user_entity.dart';
import 'package:week_28/features/google_auth/domain/repositories/google_auth_repo.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<UserEntity> signInWithGoogle() async {
    final user = await dataSource.signInWithGoogle();
    if (user != null) {
      return user;
    }
    throw Exception('Google Sign-In failed or was cancelled');
  }

  @override
  Future<void> signOut() async {
    await dataSource.signOut();
  }

  @override
  Stream<UserEntity?> get userChanges => dataSource.userChanges;

  @override
  Future<UserEntity?> getCurrentUser() {
    return dataSource.getCurrentUser();
  }
}
