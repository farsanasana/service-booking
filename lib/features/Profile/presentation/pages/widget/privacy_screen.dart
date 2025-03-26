// import 'package:flutter/material.dart';

// class PrivacyPolicyScreen extends StatelessWidget {
//   const PrivacyPolicyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Privacy Policy'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 'Privacy Policy',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'This privacy policy describes how we collect, use, and protect your personal information when you use our home service booking app.',
//               ),
//               SizedBox(height: 10),
//               Text(
//                 '1. Information We Collect',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'We collect personal details such as name, phone number, and email address when you register an account.',
//               ),
//               SizedBox(height: 10),
//               Text(
//                 '2. How We Use Your Information',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'Your information is used to facilitate booking services, provide customer support, and enhance user experience.',
//               ),
//               SizedBox(height: 10),
//               Text(
//                 '3. Data Protection',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'We implement security measures to protect your data from unauthorized access.',
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'For more details, contact support.',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  PrivacyPolicyState createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    
    // Ensure WebView is initialized
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://www.freeprivacypolicy.com/live/6b70a069-a53f-43b4-86a6-9b744ff81dd7'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
