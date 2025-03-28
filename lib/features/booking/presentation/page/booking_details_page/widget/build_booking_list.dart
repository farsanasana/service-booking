
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secondproject/features/booking/presentation/page/booking_details_page/widget/buildInfo_row.dart';
import 'package:secondproject/features/booking/presentation/page/booking_details_page/widget/get_status_color.dart';
import 'package:secondproject/features/booking/presentation/page/booking_details_page/widget/show_status_update_dialog.dart';
import 'package:secondproject/features/booking/presentation/page/bookingss/booking_section.dart';

Widget buildBookingsList(BuildContext context, List<Map<String, dynamic>> bookings, String userId) {
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
        Color statusColor = getStatusColor(bookingStatus);

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
                        onTap: () => showStatusUpdateDialog(context, booking, userId),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            formatStatus(bookingStatus),
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
                  buildInfoRow(Icons.calendar_today, formattedDate),
                  
                    buildInfoRow(
            Icons.people,
          booking['serviceProviderName'] ?? "Service Provider Not Available",),
          
                  
                  buildInfoRow(
                    Icons.access_time,
                    "${booking['hours'] ?? 1} Hour${booking['hours'] != 1 ? 's' : ''}",
                  ),
                  buildInfoRow(
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
