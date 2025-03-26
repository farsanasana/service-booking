import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondproject/core/network/network_info.dart';
import 'package:secondproject/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:secondproject/features/auth/data/model/user_model.dart';
import 'package:secondproject/features/auth/domain/entities/user_entity.dart';
import 'package:secondproject/features/auth/domain/repositories/signup_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.firebaseAuth,
  });

  @override
  Future<void> signupUser(UserEntity user, String password) async {
    final userModel = UserModel.fromEntity(user, password: password);
    await remoteDataSource.signupUser(userModel);
  }

  @override
  Future<void> loginUser(String email, String password) async {
    await remoteDataSource.loginWithEmailAndPassword(email, password);
  }

  @override
  Future<void> logoutUser() async {
    await remoteDataSource.logoutUser();
  }
}