import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_event.dart';
import 'package:secondproject/shared/reusable.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      context,
      "Sign In",
      () {
        if (formKey.currentState!.validate()) {
          BlocProvider.of<LoginBloc>(context).add(
            LoginRequested(emailController.text.trim(), passwordController.text.trim()),
          );
        }
      },
    );
  }
}
