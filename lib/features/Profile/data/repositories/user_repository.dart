import 'package:secondproject/features/Profile/domain/entites/user_entity.dart';


abstract class UserRepository {
  Future<UserEntity> getUserProfile(String uid);
}
