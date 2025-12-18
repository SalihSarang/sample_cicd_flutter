import 'package:week_28/features/google_auth/domain/repositories/google_auth_repo.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
