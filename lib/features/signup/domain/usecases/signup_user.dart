import 'package:secondproject/features/signup/domain/entities/repositories/signup_repository.dart';
import 'package:secondproject/features/signup/domain/entities/user_entity.dart';

class SignupUser {
  final SignupRepository repository;

  SignupUser(this.repository);

  Future<void> call(Usermodel user) {
    return repository.signupUser(user);
  }
}
