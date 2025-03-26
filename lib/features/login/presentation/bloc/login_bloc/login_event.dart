
// abstract class LoginEvent {}

// class LoginRequested extends LoginEvent {
//   final String email;
//   final String password;

//   LoginRequested(this.email, this.password);
// }
abstract class LogEvent {}

class LoginRequested extends LogEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class ResetPasswordRequested extends LogEvent {
  final String email;

  ResetPasswordRequested(this.email);
}

 //class GoogleSignInRequested extends LogEvent {}