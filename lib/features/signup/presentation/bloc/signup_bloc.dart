
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/signup/domain/entities/user_entity.dart';
import 'package:secondproject/features/signup/domain/usecases/signup_user.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_event.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUser signupUser;

  SignupBloc(this.signupUser) : super(SignupInitial()) {
    on<SignupRequested>(_onSignupRequested);
  }

  // Handle the signup event
  Future<void> _onSignupRequested(SignupRequested event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      // Call the signup use case
      await signupUser.call(UserEntity(
        email: event.email,
        password: event.password,
        username: event.username,
        number: event.number,
        imageUrl: event.imageUrl,
      ));

      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

}