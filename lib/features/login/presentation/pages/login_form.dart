
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_bloc.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_event.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_state.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_event.dart';
import 'package:secondproject/shared/reusable.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginForm({super.key});


 
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign In", style: TextStyle(fontSize: 28,fontWeight: FontWeight.w900),),
              SizedBox(height: 20,),
               Text.rich(
                  TextSpan(
                    children: [
                    
                      TextSpan(
                        text:
                            'Your trusted home service partner in just a login away.',
                        style: TextStyle(fontSize: 18),
                      ),
                        TextSpan(
                        text: 'Welcome back! ',
                        style: TextStyle(
                          fontSize: 20,
                          color: ColorSys.secoundry,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 20,),
              reusableTextField("Enter UserName", Icons.person, false, emailController,validator: (value){if (value==null||value.isEmpty) {
                return 'Please Enter Your Email Or UserName';
              }else if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){return 'Please Enter a valid Input';}
       
              }),
              SizedBox(height: 20),
              reusableTextField("Enter Password", Icons.lock_outline, true, passwordController,validator: (value){if (value==null||value.isEmpty) {return 'please enter your password';
                
              }else if(value.length<6){return 'Password must be at least 6 characters'; }
              return null;}),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell
                (
                  onTap: () => Navigator.pushNamed(context, '/forget_pass'),
                  child: Text('Forget Password?',style: TextStyle(color: ColorSys.secoundry,fontSize: 16,fontWeight: FontWeight.w600),))), SizedBox(height: 20),
          
              CustomButton(context, "Sign In", () {
      if (_formKey.currentState!.validate()) {
        BlocProvider.of<LoginBloc>(context).add(
                  LoginRequested(
                    emailController.text,
                    passwordController.text,
                  ),
                );
      }
                
              }), SizedBox(height: 10,),
                  Text('Or'),
                  SizedBox(height: 20,),
                  BlocConsumer<GoogleSignInBloc, GoogleSignInState>(
                    listener: (context, state) {
                      if (state is GoogleSignInFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)),);
                      }
                      if (state is GoogleSignInSuccess) {
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    builder: (context, state) {
                      if (state is GoogleSignInLoading) {
                        return const CircularProgressIndicator();
                      }
                      return CustomGoogleButton(context, " Sign in with Google", (){
                        context.read<GoogleSignInBloc>().add(GoogleSignInRequested());
                      });
                    },
                  ),
              
              SizedBox(height: 25.0),
              signUpOption(context),
            ],
          ),
        ),
      ),
    );
  }

  Row signUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: Colors.black,fontSize: 20.0)),
        GestureDetector(
          onTap: () {
           Navigator.pushNamed(context, '/signup');
          },
          
          child: Text(
            " Sign Up",
            style: TextStyle(color: ColorSys.secoundry, fontWeight: FontWeight.bold,fontSize: 22),
          ),
        ),
      ],
    );
  }
}