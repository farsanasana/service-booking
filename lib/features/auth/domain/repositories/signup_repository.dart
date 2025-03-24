// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:secondproject/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signupUser(UserEntity user, String password);
  Future<void> loginUser(String email, String password);
  Future<void> logoutUser();
}
