import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:secondproject/features/auth/presentation/widget/login_link.dartlogin_link.dart';
import 'package:secondproject/features/auth/presentation/widget/profile_image_section.dart';
import 'package:secondproject/features/auth/presentation/widget/signup_button.dart';
import 'package:secondproject/features/auth/presentation/widget/text_form_field.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController=TextEditingController();
  String? _imageUrl;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
  ProfileImageSection(onImageSelected: (imageUrl) {
                setState(() {
                  _imageUrl = imageUrl;
                });
              }),
              const SizedBox(height: 20),

              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sign up ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    TextSpan(
                      text: 'Now For Easy Access To Trusted Home Services, Right At Your Fingertips.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            
              CustomTextFormField(controller: _usernameController, label: 'Full Name', icon: Icons.person, validator: _validateUsername),
              const SizedBox(height: 15),
              CustomTextFormField(controller: _emailController, label: 'Email', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
              const SizedBox(height: 15),
              CustomTextFormField(controller: _phoneNumberController, label: 'Phone Number', icon: Icons.phone, keyboardType: TextInputType.phone, validator: _validatePhoneNumber),
              const SizedBox(height: 15),
              
              CustomTextFormField(controller: _passwordController, label: 'Password', icon: Icons.lock, obscureText: true, validator: _validatePassword),
              const SizedBox(height: 15),
              CustomTextFormField(controller: _rePasswordController, label: 'Re-Enter Password', icon: Icons.lock, obscureText: true, validator: _validateRePassword),
              const SizedBox(height: 30),
              SignupButton(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                usernameController: _usernameController,
                imageUrl: _imageUrl,
                 phoneController: _phoneNumberController,
              ),
              const SizedBox(height: 20),
              LoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateUsername(String? value) => value == null || value.isEmpty ? 'Please enter your full name' : null;
  String? _validateEmail(String? value) => value == null || value.isEmpty ? 'Please enter your email' : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value) ? 'Please enter a valid email' : null;
  String? _validatePassword(String? value) => value == null || value.isEmpty ? 'Please enter your password' : value.length < 6 ? 'Password must be at least 6 characters' : null;
  String? _validateRePassword(String? value) => value != _passwordController.text ? 'Passwords do not match' : null;
String? _validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }
  if (value.length < 6) {
    return 'Please enter a valid phone number';
  }
  return null;
}

}
