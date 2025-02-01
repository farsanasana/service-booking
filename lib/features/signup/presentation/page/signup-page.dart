import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondproject/features/signup/data/repositories/firebase_signup_repository.dart';
import 'package:secondproject/features/signup/data/repositories/image_repository.dart';
import 'package:secondproject/features/signup/domain/entities/repositories/signup_repository.dart';
import 'package:secondproject/features/signup/domain/usecases/signup_user.dart';
import 'package:secondproject/features/signup/domain/usecases/upload_image_use_case.dart';
import 'package:secondproject/features/signup/presentation/bloc/profileic/bloc/profile_pic_bloc.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_bloc.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_event.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_state.dart';
import 'package:secondproject/features/signup/presentation/page/signupform.dart';
import 'package:secondproject/shared/reusable.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
 

  @override
  Widget build(BuildContext context) {
  final signupRepository = FirebaseSignupRepository(FirebaseAuth.instance,FirebaseFirestore.instance,);
    final signupUser = SignupUser(signupRepository);
    return MultiBlocProvider(
        providers: [
            BlocProvider(
          create: (context) => SignupBloc(signupUser),
    
        ),
            BlocProvider(
                create: (context) => ImageBloc(),
            ),
        ],
            
            child: Scaffold(
                    
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
                           return SignupForm();
                      },
                     
              
                    ),
                  ),
          
    );
  }
}


