import 'package:week_28/features/google_auth/domain/models/user_entity.dart';
import 'package:week_28/features/google_auth/domain/repositories/google_auth_repo.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}
