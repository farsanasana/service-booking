import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/booking/data/model/booking_model.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';
import 'package:intl/intl.dart';
import 'package:secondproject/features/booking/presentation/page/booking_details_page/widget/build_booking_list.dart';
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
              return buildBookingsList(context, state.bookings, userId);
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

  
  

}