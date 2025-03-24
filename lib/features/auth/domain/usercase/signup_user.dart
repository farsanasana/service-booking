// lib/features/auth/domain/usercase/signup_user.dart
import 'package:secondproject/features/auth/domain/entities/user_entity.dart';
import 'package:secondproject/features/auth/domain/repositories/signup_repository.dart';

class SignupUser {
  final AuthRepository repository;

  SignupUser(this.repository);

  Future<void> call(UserEntity user, String password) async {
    return await repository.signupUser(user, password);
  }
}