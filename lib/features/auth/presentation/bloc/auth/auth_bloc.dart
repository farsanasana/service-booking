// lib/features/auth/presentation/bloc/auth/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/auth/domain/repositories/signup_repository.dart';
import 'package:secondproject/features/auth/domain/usercase/signup_user.dart';
import '../../../domain/entities/user_entity.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUser signupUser;

  AuthBloc(this.signupUser, ) : super(AuthInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSignupRequested(
    SignupRequested event, 
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try {
      print("🔐 In AuthBloc, image URL: ${event.imageUrl}"); 
      final user = UserEntity(
        email: event.email,
        username: event.username,
        phoneNumber: event.phoneNumber,
        imageUrl: event.imageUrl,
        password: event.password,
      );
      await signupUser(user, event.password);
      emit(AuthSuccess());
    } catch (e) {
       print("❌ Signup error: $e");
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit
  ) async {
    // Implement login logic here
    // For now, just placeholders
    emit(AuthLoading());
    try {
      // Implement your login logic
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit
  ) async {
    // Implement logout logic here
    // For now, just placeholders
    emit(AuthLoading());
    try {
      // Implement your logout logic
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}