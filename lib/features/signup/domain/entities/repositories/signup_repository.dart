import 'package:firebase_storage/firebase_storage.dart';
import 'package:secondproject/features/signup/domain/entities/user_entity.dart';

abstract class SignupRepository {
  SignupRepository(FirebaseStorage instance);

  Future<void> signupUser(UserEntity user);
}
