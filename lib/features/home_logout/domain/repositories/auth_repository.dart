
import 'package:firebase_auth/firebase_auth.dart';

class LogoutRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
