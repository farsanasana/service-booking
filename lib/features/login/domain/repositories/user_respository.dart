import 'package:firebase_auth/firebase_auth.dart';

abstract class LogRepository {
  Future<User?> loginWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetLink(String email);
  Future<User?> signInWithGoogle();
}
