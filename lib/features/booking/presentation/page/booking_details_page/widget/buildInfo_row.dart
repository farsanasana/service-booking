import 'package:flutter/material.dart';

Widget buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  String formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending_cash':
        return 'Pending Payment';
      default:
        // Capitalize first letter
        return status.isNotEmpty 
            ? status[0].toUpperCase() + status.substring(1) 
            : 'Unknown';
    }
  }
  