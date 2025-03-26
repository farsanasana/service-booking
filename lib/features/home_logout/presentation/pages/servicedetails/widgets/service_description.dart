import 'package:flutter/material.dart';

class ServiceDescription extends StatelessWidget {
  final String description;

  const ServiceDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
