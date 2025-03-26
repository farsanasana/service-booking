import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondproject/core/errors/exceptions.dart';
import 'package:secondproject/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signupUser(UserModel user);
  Future<User?> loginWithEmailAndPassword(String email, String password);
  Future<void> logoutUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({required this.firebaseAuth, required this.firestore});

  @override
  Future<void> signupUser(UserModel user) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final userData = user.toJson();
      print("🔥 Writing to Firestore: $userData");

      await firestore.collection('users').doc(userCredential.user!.uid).set(userData);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Signup failed');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw ServerException("Login failed: ${e.message}");
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Logout failed: $e');
    }
  }
}