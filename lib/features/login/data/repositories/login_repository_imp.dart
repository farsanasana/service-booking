import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondproject/features/login/data/datasources/log_remote_data_source.dart';
import 'package:secondproject/features/login/domain/repositories/user_respository.dart';

class LoginRepositoryImp implements LogRepository {
  final LogRemoteDataSource remoteDataSource;

  LoginRepositoryImp(this.remoteDataSource);

  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) {
    return remoteDataSource.loginWithEmailAndPassword(email, password);
  }

  @override
  Future<void> sendPasswordResetLink(String email) {
    return remoteDataSource.sendPasswordResetLink(email);
  }

  @override
  Future<User?> signInWithGoogle() {
    return remoteDataSource.signInWithGoogle();
  }
}
