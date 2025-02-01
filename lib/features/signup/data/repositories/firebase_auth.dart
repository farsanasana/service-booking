import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserProfileRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseUserProfileRepository(this._firebaseAuth, this._firestore);

  Future<Map<String, String>> getUserProfile() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      // Get user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
 final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      // Return email and username
      return {
        'email': user.email!,
        'username': userDoc['username'] ?? 'No Username Set',
        'number':userDoc['number']??'no number set',
        'imageUrl': userData['imageUrl'] ?? 'assets/images/user.png',
      };
    }

    throw Exception('No user signed in');
  }
}
