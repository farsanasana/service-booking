import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

Future<void> _launchEmail(BuildContext context) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'support@homeservice.com',
    queryParameters: {
      'subject': 'Support Request',
      'body': 'Hello, I need help with...',
    },
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri, mode: LaunchMode.externalApplication); // Change mode here
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⚠️ No Email App Found!')),
    );
  }
}



  Future<void> _launchPhoneCall(BuildContext context) async {
    final Uri callUri = Uri.parse('tel:+971123456789');
    
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ No Phone App Found!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
        backgroundColor: ColorSys.secoundry, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you are facing any issues, feel free to contact our support team.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Email Support
            ListTile(
              leading: Icon(Icons.email, color: ColorSys.primary),
              title: const Text('Email Support'),
              subtitle: const Text('support@homeservice.com'),
              onTap: () => _launchEmail(context),
            ),

            // Call Support
            ListTile(
              leading: Icon(Icons.phone, color: ColorSys.primary),
              title: const Text('Call Support'),
              subtitle: const Text('+971 123 456 789'),
              onTap: () => _launchPhoneCall(context),
            ),
          ],
        ),
      ),
    );
  }
}
