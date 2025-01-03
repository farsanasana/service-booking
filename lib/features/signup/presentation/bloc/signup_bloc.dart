import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/signup/domain/entities/user_entity.dart';
import 'package:secondproject/features/signup/domain/usecases/signup_user.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_event.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUser signupUser;

  SignupBloc(this.signupUser) : super(SignupInitial()) {
    on<SignupRequested>((event, emit) async {
      emit(SignupLoading());
      try {
        await signupUser.call(
          UserEntity(email: event.email, password: event.password,username: event.username),
        );
        emit(SignupSuccess());
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}
