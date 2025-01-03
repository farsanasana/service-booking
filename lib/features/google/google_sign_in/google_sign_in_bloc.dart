
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_event.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_state.dart';
import 'package:secondproject/features/google/repositories_google_services.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final GoogleSignInService  _googleSignInService;

  GoogleSignInBloc(this._googleSignInService) : super(GoogleSignInInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(GoogleSignInLoading());
      try {
        final user = await _googleSignInService.signInWithGoogle();
        if (user != null) {
          emit(GoogleSignInSuccess(user));
        } else {
          emit(GoogleSignInFailure('Google Sign-In Aborted'));
        }
      } catch (e) {
        emit(GoogleSignInFailure(e.toString()));
      }
    });

    on<GoogleSignOutRequested>((event, emit) async {
      await _googleSignInService.signOut();
      emit(GoogleSignInInitial());
    });
  }
}
