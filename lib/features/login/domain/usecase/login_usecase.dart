import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondproject/features/login/domain/repositories/user_respository.dart';

class LoginUseCase {
  final LogRepository repository;

  LoginUseCase(this.repository);

  Future<User?> execute(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    return repository.loginWithEmailAndPassword(email, password);
  }
}

class ResetPasswordUseCase {
  final LogRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> execute(String email) {
    return repository.sendPasswordResetLink(email);
  }
}

class GoogleSignInUseCase {
  final LogRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<User?> execute() {
    return repository.signInWithGoogle();
  }
}
