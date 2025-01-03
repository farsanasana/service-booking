import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendPasswordResetEmail extends ForgotPasswordEvent {
  final String email;

  SendPasswordResetEmail(this.email);

  @override
  List<Object?> get props => [email];
}
