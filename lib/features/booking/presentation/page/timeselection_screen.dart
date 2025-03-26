
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';
import 'package:secondproject/features/booking/presentation/page/paymentconfirmation_screen.dart';
import 'package:secondproject/features/booking/presentation/page/stripe_services.dart';

class TimeSelectionScreen extends StatefulWidget {
  final String tempBookingId; // Changed from bookingId to tempBookingId
  final String totalAmount;
  final String serviceName; // Added missing field

  const TimeSelectionScreen({
    super.key,
    required this.tempBookingId, // Changed from bookingId to tempBookingId
    required this.totalAmount,
    required this.serviceName, // Added missing field
  });

  @override
  State<TimeSelectionScreen> createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';

 

  void _handleTimeSelection(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  void _handleDateSelection(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

void _onNextPressed() {
    print('tempBookingId: ${widget.tempBookingId}');
  print('tempBookingId type: ${widget.tempBookingId.runtimeType}');
  if (widget.tempBookingId.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error: Booking ID cannot be empty'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (selectedTime.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a time'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    // Parse time and create datetime
    List<String> timeParts = selectedTime.split('-');
    String startTime = timeParts[0].trim();

    List<String> hourMinute = startTime.split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    // Update booking time in Bloc
    context.read<BookingBloc>().add(UpdateBookingDateTime(
      bookingId: widget.tempBookingId,
      dateTime: dateTime,
    ));

    // Call payment service
    StripeServices.instance.makepayment(
      widget.totalAmount,
 onSuccess: () {
  context.read<BookingBloc>().add(CreateBookingAfterPayment(
    tempBookingId: widget.tempBookingId,
    dateTime: dateTime,
  ));

  // Wait for the booking to be created, then navigate
  context.read<BookingBloc>().stream.listen((state) {
    if (state is BookingSuccess) {
      Navigator.of(context).pushNamed(
        '/booking/confirmation',
        arguments: {
          'bookingId': widget.tempBookingId,
          'totalAmount': double.parse(widget.totalAmount),
          'serviceName': widget.serviceName,
        },
      );
    } else if (state is BookingError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed: ${state.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  });
},

      onFailure: (error) {
        // Show error message if payment fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error processing time: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Step 3 of 4'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              'When would you like your service?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7, // Next 7 days
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = DateUtils.isSameDay(date, selectedDate);

                  return GestureDetector(
                    onTap: () => _handleDateSelection(date),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? ColorSys.secoundry: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black),
                          ),
                          Text(
                            DateFormat('d').format(date),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'What time would you like us to start?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '13:30-14:00', '14:00-14:30', '14:30-15:00'
              ].map((time) {
                final isSelected = selectedTime == time;
                return GestureDetector(
                  onTap: () => _handleTimeSelection(time),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ?ColorSys.secoundry: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enjoy free cancellation up to 6 hours before your booking start time.',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              'AED ${widget.totalAmount}', // Added currency symbol
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _onNextPressed,
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('PAY Now'),
            ),
          ],
        ),
      ),
    );
  }
}