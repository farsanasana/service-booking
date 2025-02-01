import 'dart:io';

abstract class SignupEvent {}

class SignupRequested extends SignupEvent {
  final String email;
  final String password;
  final String username;
  final String number;
  final String? imageUrl;

  SignupRequested(this.email, this.password,this.username,this.number,{this.imageUrl});
}

