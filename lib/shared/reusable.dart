

import 'package:flutter/material.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';

Widget reusableTextField(
    String hint, IconData icon, bool isPassword, TextEditingController controller,{String ?Function(String?)?validator}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon,color: ColorSys.gray),hintStyle: TextStyle(color: ColorSys.gray),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    validator: validator,
  );
}

Widget CustomButton(BuildContext context, String title, Function onTap) {
  return SizedBox(
    height: 50.0,width: 250.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
      backgroundColor: ColorSys.secoundry, // Set the background color
      foregroundColor: Colors.white, // Set the text color
    ),
      onPressed: () => onTap(),
      child: Text(title,style: TextStyle(fontSize: 18,),),
      
    ),
  );
}

Widget CustomGoogleButton(BuildContext context, String title, Function onTap) {
  return SizedBox(
    height: 50.0,
    width: 250.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorSys.primary, // Set the background color
        foregroundColor: Colors.white, // Set the text color
      ),
      onPressed: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Align the content in the center
        children: [
          Image.asset('assets/images/google.jpg',
          height: 24.0,
          width: 24.0,
          ),
          const SizedBox(width: 10), // Space between the icon and text
          Text(
            title,
            style: const TextStyle(fontSize: 18), // Styling for the button text
          ),
        ],
      ),
    ),
  );
}
