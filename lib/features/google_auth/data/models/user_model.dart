import 'package:firebase_auth/firebase_auth.dart';
import 'package:week_28/features/google_auth/domain/models/user_entity.dart';

extension UserModel on User {
  UserEntity toEntity() {
    return UserEntity(uid: uid, email: email, name: displayName);
  }
}
