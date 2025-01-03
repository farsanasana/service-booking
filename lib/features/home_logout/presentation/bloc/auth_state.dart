
import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutFailure extends LogoutState {
  final String message;

  LogoutFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
