import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/booking/data/model/booking_model.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';
import 'package:intl/intl.dart';
import 'package:secondproject/features/booking/presentation/page/bookingss/booking_section.dart';

class BookingDetailedScreen extends StatelessWidget {
  final String userId;

  const BookingDetailedScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<BookingBloc>()..add(FetchBookingDetails(userId: userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Bookings"),
          backgroundColor: Colors.blue,
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingsLoaded) {
              return _buildBookingsList(context, state.bookings);
            } else if (state is BookingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BookingBloc>().add(FetchBookingDetails(userId: userId));
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No bookings available",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, List<Map<String, dynamic>> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No bookings found",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        
        // Format the date if available
        String formattedDate = "Date not available";
        if (booking['bookingDate'] != null) {
          try {
            if (booking['bookingDate'] is Timestamp) {
              final timestamp = booking['bookingDate'] as Timestamp;
              formattedDate = DateFormat('MMM d, yyyy - h:mm a').format(timestamp.toDate());
            } else if (booking['bookingDate'] is String) {
              final dateTime = DateTime.parse(booking['bookingDate'] as String);
              formattedDate = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
            }
          } catch (e) {
            formattedDate = "Invalid date format";
          }
        }

        // Get payment status
        String bookingStatus = booking['bookingStatus'] ?? 'Pending';
        Color statusColor = _getStatusColor(bookingStatus);

        return GestureDetector(
            onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedPage(booking: booking),
      ),
    );
  },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          booking['serviceName'] ?? "Unknown Service",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showStatusUpdateDialog(context, booking),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _formatStatus(bookingStatus),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.calendar_today, formattedDate),
                  
                    _buildInfoRow(
            Icons.people,
          booking['serviceProviderName'] ?? "Service Provider Not Available",),
          
                  
                  _buildInfoRow(
                    Icons.access_time,
                    "${booking['hours'] ?? 1} Hour${booking['hours'] != 1 ? 's' : ''}",
                  ),
                  _buildInfoRow(
                    Icons.location_on,
                    booking['address'] ?? "Address not available",
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "AED ${(booking['totalAmount'] ?? 0.0).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (booking['instructions'] != null && booking['instructions'] != '')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Instructions:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking['instructions'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'pending':
      case 'pending_cash':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
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
  
  
  void _showStatusUpdateDialog(BuildContext context, Map<String, dynamic> booking) {
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


}