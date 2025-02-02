import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/home_logout/presentation/pages/mainHoome.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_event.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_state.dart';
import 'package:secondproject/features/login/presentation/pages/login_form.dart';
import 'package:secondproject/features/home_logout/presentation/pages/home-page.dart';
import 'package:secondproject/shared/reusable.dart';


class LoginPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Login Successful! Welcome ${state.user.email}")),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return CircularProgressIndicator();
            }
    
            return LoginForm();
          },
        ),
      ),
    );
  }
}
