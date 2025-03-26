import 'package:flutter/material.dart';
import 'package:secondproject/shared/reusable.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  const EmailTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reusableTextField(
      "Enter Email",
      Icons.email,
      false,
      controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}
