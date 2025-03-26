// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:secondproject/features/login/presentation/bloc/forget_bloc/forget_password_event.dart';
// import 'package:secondproject/features/login/presentation/bloc/forget_bloc/forget_password_state.dart';


// class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
//   final FirebaseAuth firebaseAuth;

//   ForgotPasswordBloc(this.firebaseAuth) : super(ForgotPasswordInitial()) {
//     on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
//   }

//   Future<void> _onSendPasswordResetEmail(
//       SendPasswordResetEmail event, Emitter<ForgotPasswordState> emit) async {
//     emit(ForgotPasswordLoading());
//     try {
//       await firebaseAuth.sendPasswordResetEmail(email: event.email);
//       emit(ForgotPasswordSuccess());
//     } on FirebaseAuthException catch (e) {
//       String errorMessage;
//       if (e.code == 'user-not-found') {
//         errorMessage = 'No user found with this email address.';
//       } else if (e.code == 'invalid-email') {
//         errorMessage = 'The email address is invalid.';
//       } else {
//         errorMessage = 'Something went wrong. Please try again.';
//       }
//       emit(ForgotPasswordFailure(errorMessage));
//     } catch (e) {
//       emit(ForgotPasswordFailure('An unexpected error occurred.'));
//     }
//   }
// }
