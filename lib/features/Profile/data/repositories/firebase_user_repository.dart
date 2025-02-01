import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/Profile/domain/entites/user_entity.dart';
import '../repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore firestore;

  FirebaseUserRepository(this.firestore);

  @override
  Future<UserEntity> getUserProfile(String userId) async {
    try {
       final userDoc  = await firestore.collection('users').doc(userId).get();
    if (!userDoc .exists) {
      throw Exception('User not found');
    }
    final data = userDoc .data()!;
    return UserEntity(
      username: data['username'] ?? 'Not Available',
      email: data['email'] ?? 'Not Available', phone:data['phone']?? 'Not Available',
    );
      
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
   
  }
}
