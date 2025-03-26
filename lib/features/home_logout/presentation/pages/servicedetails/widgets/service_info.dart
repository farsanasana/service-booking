import 'package:flutter/material.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';

class ServiceInfo extends StatelessWidget {
  final Service service;

  const ServiceInfo({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
