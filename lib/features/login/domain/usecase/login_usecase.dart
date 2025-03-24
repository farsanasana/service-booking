import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondproject/features/login/data/datasources/log_remote_data_source.dart';
import 'package:secondproject/features/login/domain/entities/user.dart';

class LoginUseCase {
  final AuthenticationRepository authenticationRepository;

  LoginUseCase(this.authenticationRepository);

  Future<User?> execute(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }

    // Ensure this method returns a valid user object
    return await authenticationRepository.loginWithEmailAndPassword(email, password);
  }
}