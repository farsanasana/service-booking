import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:secondproject/features/signup/domain/entities/repositories/signup_repository.dart';
import 'package:secondproject/features/signup/domain/entities/user_entity.dart';

class FirebaseSignupRepository implements SignupRepository {
  final FirebaseAuth _firebaseAuth;
final FirebaseFirestore   _firestore;
 
  FirebaseSignupRepository(this._firebaseAuth,this._firestore,);
  
  @override
  Future<void> signupUser(UserEntity user) async{
    UserCredential userCredential=await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: user.password);
  
  
  await _firestore.collection('users').doc(userCredential.user!.uid).set({'email':user.email,'username':user.username,'phone':user.number,'imageUrl':user.imageUrl??'assets/images/user.png'});
  }


  
}
