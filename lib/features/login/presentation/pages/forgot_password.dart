import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/login/presentation/bloc/forget_bloc/forget_password_bloc.dart';
import 'package:secondproject/features/login/presentation/bloc/forget_bloc/forget_password_event.dart';
import 'package:secondproject/features/login/presentation/bloc/forget_bloc/forget_password_state.dart';
import 'package:secondproject/shared/reusable.dart';


class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(FirebaseAuth.instance),
      child: Scaffold(
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset email sent!')),
              );
              Navigator.pop(context);
            } else if (state is ForgotPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Enter your email to receive a password reset link'),
                  const SizedBox(height: 20),
                  reusableTextField(
                    'Enter Email',
                    Icons.email_outlined,
                    false,
                    emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(context, 'Send Email', () {
                    if (emailController.text.isNotEmpty) {
                      BlocProvider.of<ForgotPasswordBloc>(context).add(
                        SendPasswordResetEmail(emailController.text.trim()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your email')),
                      );
                    }
                  }),
                  if (state is ForgotPasswordLoading)
                    const CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
