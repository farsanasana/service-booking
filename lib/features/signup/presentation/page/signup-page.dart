import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_bloc.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_event.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_state.dart';
import 'package:secondproject/shared/reusable.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup Successful!')),
            );
            Navigator.pushNamed(context, '/login');
          } else if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is SignupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                   reusableTextField(
                    "Enter Name",
                    Icons.person,
                    false,
                    usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Name';
                      // } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      //     .hasMatch(value)) {
                      //   return 'Please enter a valid email';
                      // }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  reusableTextField(
                    "Enter Email",
                    Icons.email,
                    false,
                    emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  reusableTextField(
                    "Enter Password",
                    Icons.lock,
                    true,
                    passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(context, "Sign Up", () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<SignupBloc>(context).add(
                        SignupRequested(
                          emailController.text,
                          passwordController.text,
                          usernameController.text,
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
