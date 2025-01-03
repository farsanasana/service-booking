import 'package:secondproject/features/Profile/data/repositories/user_repository.dart';
import 'package:secondproject/features/Profile/domain/entites/user_entity.dart';



class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  Future<UserEntity> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}
