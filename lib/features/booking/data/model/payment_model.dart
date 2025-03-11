
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentDetails {
  final String transactionId;
  final String status; // pending, success, failed
  final String method; // credit_card, cash
  final DateTime timestamp;

  PaymentDetails({
    required this.transactionId,
    required this.status,
    required this.method,
    required this.timest
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'status': status,
      'method': method,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory PaymentDetails.fromMap(Map<String, dynamic> map) {
    return PaymentDetails(
      transactionId: map['transactionId'] ?? '',
      status: map['status'] ?? '',
      method: map['method'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}