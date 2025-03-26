// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:secondproject/features/login/domain/usecase/login_usecase.dart';
// import 'login_event.dart';
// import 'login_state.dart';

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final LoginUseCase loginUseCase;

//   LoginBloc(this.loginUseCase) : super(LoginInitial()) {
//     on<LoginRequested>((event, emit) async {
//       emit(LoginLoading()); // Emit loading state before processing login

//       try {
//         final user = await loginUseCase.execute(event.email, event.password);

//         // Emit success state with user data if login succeeds
//         emit(LoginSuccess(user!));
//       } catch (e) {
//         // Emit failure state with error message if login fails
//         emit(LoginFailure(e.toString()));
//       }
//     });
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/login/domain/usecase/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LogEvent, LogState> {
  final LoginUseCase loginUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  LoginBloc({
    required this.loginUseCase,
    required this.resetPasswordUseCase,
    required this.googleSignInUseCase,
  }) : super(LogInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
   // on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      final user = await loginUseCase.execute(event.email, event.password);
      if (user != null) {
        emit(LogSuccess(user));
      } else {
        emit(LogFailure('Login failed. User is null.'));
      }
    } catch (e) {
      emit(LogFailure(e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(ResetPasswordRequested event, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      await resetPasswordUseCase.execute(event.email);
      emit(PasswordResetEmailSent());
    } catch (e) {
      emit(LogFailure(e.toString()));
    }
  }

  // Future<void> _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<LogState> emit) async {
  //   emit(LogLoading());
  //   try {
  //     final user = await googleSignInUseCase.execute();
  //     if (user != null) {
  //       emit(LogSuccess(user));
  //     } else {
  //       emit(LogFailure('Google sign-in failed or was cancelled.'));
  //     }
  //   } catch (e) {
  //     emit(LogFailure(e.toString()));
  //   }
  // }
}
