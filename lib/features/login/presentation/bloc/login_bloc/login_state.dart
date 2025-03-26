


// import 'package:firebase_auth/firebase_auth.dart';

// abstract class LoginState {}

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginSuccess extends LoginState {
//   final User user;

//   LoginSuccess(this.user);
// }

// class LoginFailure extends LoginState {
//   final String error;

//   LoginFailure(this.error);
// }
import 'package:firebase_auth/firebase_auth.dart';

abstract class LogState {}

class LogInitial extends LogState {}

class LogLoading extends LogState {}

class LogSuccess extends LogState {
  final User user;
  LogSuccess(this.user);
}

class LogFailure extends LogState {
  final String error;
 LogFailure(this.error);
}

class PasswordResetEmailSent extends LogState {}