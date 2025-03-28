

abstract class AuthEvent {}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phoneNumber;
  final String? imageUrl;
    final DateTime ?createdAt; final String ?id;

  SignupRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
    this.imageUrl,
     this.createdAt, 
       this.id,
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

