
import 'package:secondproject/features/home_logout/domain/repositories/auth_repository.dart';


class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() async {
    await repository.logout();
  }
}