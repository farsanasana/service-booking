// lib/core/utils/reusable.dart
import 'package:flutter/material.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';

class AppUtils {
  // Show snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  // Format phone number
  static String formatPhoneNumber(String phone) {
    // Implement phone formatting logic as needed
    return phone;
  }
  
  // Check password strength
  static bool isStrongPassword(String password) {
    // Check if password has at least 8 characters, 1 uppercase, 1 lowercase, 1 digit
    return password.length >= 8 && 
           RegExp(r'[A-Z]').hasMatch(password) &&
           RegExp(r'[a-z]').hasMatch(password) &&
           RegExp(r'[0-9]').hasMatch(password);
  }
  
  // Navigation helper
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
  
  static void navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }
}