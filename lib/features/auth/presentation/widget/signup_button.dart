import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_state.dart';

class SignupButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final String? imageUrl;

  const SignupButton({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.phoneController,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading
                ? null // Disable button when loading
                : () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        SignupRequested(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          username: usernameController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          imageUrl: imageUrl,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator
                : const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
