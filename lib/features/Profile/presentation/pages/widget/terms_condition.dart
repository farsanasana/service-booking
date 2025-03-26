import 'package:flutter/material.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: ColorSys.secoundry, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. By using this app, you agree to follow our policies and guidelines.\n\n'
                '2. Services provided are subject to availability and may change at any time.\n\n'
                '3. Payments are non-refundable except under special circumstances.\n\n'
                '4. We reserve the right to modify or terminate the service at any time.\n\n'
                '5. User data is protected under our Privacy Policy.\n\n'
                '6. Misuse of the platform may lead to account suspension or legal action.\n\n'
                'For more details, please contact our support team.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Accept & Continue',style: TextStyle(color: ColorSys.primary),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
