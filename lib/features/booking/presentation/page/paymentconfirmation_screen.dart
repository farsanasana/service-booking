
import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final double totalAmount;
  final String serviceName;

  const BookingConfirmationScreen({
    Key? key,
    required this.bookingId,
    required this.totalAmount,
    required this.serviceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button from going to time selection screen
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Confirmation'),
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Image
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 120,
              ),
              const SizedBox(height: 32),
              
              // Title Text
              Text(
                'Booking Confirmed!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Service Name
              Text(
                'Service: $serviceName',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Booking Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetailRow('Booking ID', bookingId),
                      const SizedBox(height: 8),
                      _buildDetailRow('Total Amount', 'AED ${totalAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Payment Status', 'Paid'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Back to Home Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build detail rows in the card
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}