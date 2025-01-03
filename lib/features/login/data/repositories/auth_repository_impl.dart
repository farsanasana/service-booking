import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {
  final FirebaseAuth firebaseAuth;
final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthenticationRepository(this.firebaseAuth);

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }


Future<void> updateUserName(String name) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await user.updateDisplayName(name);
    await user.reload(); // Reload the user to reflect changes
  }
}


    Future<void> sendPasswordResetLink(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to send password reset link: ${e.toString()}");
    }
  }
 Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
       //   await _auth.signInWithCredential(credential);
await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Google Sign-In Failed: ${e.toString()}');
    }
  }

}
 


