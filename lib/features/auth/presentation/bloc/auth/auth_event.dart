

abstract class AuthEvent {}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phoneNumber;
  final String? imageUrl;

  SignupRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
    this.imageUrl,
  });
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({
    required this.email,
    required this.password,
  });
}

class LogoutRequested extends AuthEvent {}

