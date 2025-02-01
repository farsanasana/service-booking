import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_bloc.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_event.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_state.dart';
import 'package:secondproject/features/signup/presentation/bloc/profileic/bloc/profile_pic_bloc.dart';
import 'package:secondproject/features/signup/presentation/bloc/profileic/bloc/profile_pic_event.dart';
import 'package:secondproject/features/signup/presentation/bloc/profileic/bloc/profile_pic_state.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_bloc.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_event.dart';
import 'package:secondproject/shared/reusable.dart';

class SignupForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    String? uploadedImageUrl;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ImageBloc, ImageState>(
                builder: (context, state) {
                  Widget profileImage;
                  if (state is ImageUploadingState) {
                    profileImage = const CircularProgressIndicator();
                  } else if (state is ImageUploadedState) {
                    uploadedImageUrl=state.imageUrl;
                    profileImage = Image.network(
                      state.imageUrl,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    );
                  } else if (state is ImageErrorState) {
                    profileImage = Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (state is ImagePickedState) {
                    context.read<ImageBloc>().add(UploadImageEvent(state.image));
                    profileImage = Image.file(
                      (state.image), // Use the correct property name
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    );
                  } else {
                    profileImage = Image.asset(
                      'assets/images/user.png',
                      height: 150,
                      width: 150,
                    );
                  }

                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      profileImage,
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            final bloc=
                            context.read<ImageBloc>();
                            bloc.add(PickImageEvent());
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              reusableTextField(
                "Enter Name",
                Icons.person,
                false,
                usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              reusableTextField(
                "Enter Email ID",
                Icons.email,
                false,
                emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              reusableTextField(
                "Phone Number",
                Icons.call,
                false,
                numberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your number';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              reusableTextField(
                "Enter Password",
                Icons.lock_outline,
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
              
              const SizedBox(height: 20),
              CustomButton(context, "Sign Up", () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<SignupBloc>(context).add(
                    SignupRequested(
                      emailController.text,
                      passwordController.text,
                      usernameController.text,
                      numberController.text,
                      imageUrl: uploadedImageUrl,
                    ),
                  );
                }
              }),
              const SizedBox(height: 10),
              const Text('Or'),
              const SizedBox(height: 20),
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
              const SizedBox(height: 25.0),
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
        const Text(
          "Already have an account?",
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text(
            " Sign In",
            style: TextStyle(
              color: ColorSys.secoundry,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }
}
