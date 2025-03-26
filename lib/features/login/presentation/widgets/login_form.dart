import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/auth/presentation/widget/text_form_field.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_bloc.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_event.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_state.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_event.dart';
import 'package:secondproject/features/login/presentation/widgets/email_text_filed.dart';
import 'package:secondproject/features/login/presentation/widgets/forget_password.dart';
import 'package:secondproject/features/login/presentation/widgets/password_text_field.dart';
import 'package:secondproject/features/login/presentation/widgets/login_button.dart.dart';
import 'package:secondproject/features/login/presentation/widgets/google_sign_in_button.dart';
import 'package:secondproject/features/login/presentation/widgets/sign_up_option.dart';

class LoginForm extends StatelessWidget {
 final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign In", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Your trusted home service partner is just a login away.', style: TextStyle(fontSize: 18)),
                    TextSpan(text: 'Welcome back!', style: TextStyle(fontSize: 20, color: ColorSys.secoundry, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomTextFormField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress, validator: _validateEmail),         
              const SizedBox(height: 20),
              CustomTextFormField(controller: _passwordController, label: 'Password', obscureText: true, validator: _validatePassword),
              const SizedBox(height: 20),
              ForgotPasswordLink(),
              const SizedBox(height: 20),
              LoginButton(formKey: _formKey, emailController: _emailController, passwordController: _passwordController),

              const SizedBox(height: 10),
              Text('Or', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              GoogleSignInButton(),
              const SizedBox(height: 25.0),
              SignUpOption(),
            ],
          ),
        ),
      ),
    );
  }
   String? _validateEmail(String? value) => value == null || value.isEmpty ? 'Please enter your email' : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) ? 'Please enter a valid email' : null;
  String? _validatePassword(String? value) => value == null || value.isEmpty ? 'Please enter your password' : value.length < 6 ? 'Password must be at least 6 characters' : null;
}
