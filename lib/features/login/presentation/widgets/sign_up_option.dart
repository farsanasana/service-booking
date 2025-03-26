import 'package:flutter/material.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';

class SignUpOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: Colors.black, fontSize: 18.0)),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/signup'),
          child: Text(" Sign Up", style: TextStyle(color: ColorSys.secoundry, fontWeight: FontWeight.bold, fontSize: 20)),
        ),
      ],
    );
  }
}
