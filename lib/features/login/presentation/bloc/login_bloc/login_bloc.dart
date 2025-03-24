import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/login/domain/usecase/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading()); // Emit loading state before processing login

      try {
        final user = await loginUseCase.execute(event.email, event.password);

        // Emit success state with user data if login succeeds
        emit(LoginSuccess(user!));
      } catch (e) {
        // Emit failure state with error message if login fails
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
