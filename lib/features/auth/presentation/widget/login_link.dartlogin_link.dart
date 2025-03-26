import 'package:flutter/material.dart';

class LoginLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?',style: TextStyle(fontSize: 18, color: Colors.black54),),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: const Text('Login',style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),),
        ),
      ],
    );
  }
}
