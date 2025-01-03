import 'package:secondproject/features/signup/domain/entities/user_entity.dart';

abstract class SignupRepository {
  Future<void> signupUser(UserEntity user);
}
