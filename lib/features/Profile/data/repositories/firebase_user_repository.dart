import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/Profile/data/repositories/user_repository.dart';
import 'package:secondproject/features/Profile/domain/entites/user_entity.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore firestore;

  FirebaseUserRepository(this.firestore);

  @override
  Future<UserEntity> getUserProfile(String userId) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      
      final data = userDoc.data()!;
      print('🔍 Fetched User Data: $data');

      return UserEntity(
        username: data['username'] ?? 'Not Available',
        email: data['email'] ?? 'Not Available', 
        phoneNumber: data['phoneNumber'] ?? 'Not Available',
        imageUrl: data['imageUrl'] ?? 'assets/images/user.png'
      );
    } catch (e) {
      print('❌ Error fetching profile: $e');
      throw Exception("Error fetching profile: $e");
    }
  }
  
}