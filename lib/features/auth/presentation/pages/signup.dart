import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:secondproject/features/auth/presentation/widget/signup_form.dart';

// lib/features/auth/presentation/pages/signup_page.dart
class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup Successful!')));
Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SignupForm();
        },
      ),
    );
  }
}
