import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_bloc.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_event.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_state.dart';
import 'package:secondproject/shared/reusable.dart';

class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoogleSignInBloc, GoogleSignInState>(
      listener: (context, state) {
        if (state is GoogleSignInFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
        if (state is GoogleSignInSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        if (state is GoogleSignInLoading) {
          return const CircularProgressIndicator();
        }
        return CustomGoogleButton(
          context,
          " Sign in with Google",
          () => context.read<GoogleSignInBloc>().add(GoogleSignInRequested()),
        );
      },
    );
  }
}
