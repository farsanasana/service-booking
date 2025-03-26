import 'package:flutter/material.dart';
import 'package:secondproject/shared/reusable.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  const PasswordTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reusableTextField(
      "Enter Password",
      Icons.lock_outline,
      true,
      controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
