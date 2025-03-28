
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';

void showStatusUpdateDialog(BuildContext context, Map<String, dynamic> booking , String userId) {
  String selectedStatus = booking['bookingStatus'] ?? 'pending'; // Set default if null

  showDialog(
    context: context,
    builder: (context) {
      return BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingStatusUpdated) {
            Navigator.pop(context); // Close dialog after successful update
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Status updated to ${state.status}')),
            );
            // Fetch updated booking details after status update
            context.read<BookingBloc>().add(FetchBookingDetails(userId: userId));
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: const Text('Update Booking Status'),
            content: StatefulBuilder(
              builder: (context, setState) => DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                items: ['pending', 'completed', 'cancelled'].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedStatus = value!); // Correctly update state
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<BookingBloc>().add(
                    UpdateBookingStatus(
                      booking['id'],  // Pass the ID directly
                      selectedStatus, // Pass the status directly
                    ),
                  );
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      );
    },
  );
}
