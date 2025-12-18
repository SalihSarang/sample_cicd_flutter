import 'package:week_28/features/google_auth/domain/models/user_entity.dart';
import 'package:week_28/features/google_auth/domain/repositories/google_auth_repo.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<UserEntity> call() async {
    return await repository.signInWithGoogle();
  }
}
