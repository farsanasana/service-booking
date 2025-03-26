import 'package:flutter/material.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';

class ForgotPasswordLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/forget_pass'),
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: ColorSys.secoundry, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
