import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';
import 'package:secondproject/features/booking/presentation/page/bookingss/bookingform.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'widgets/service_image.dart';
import 'widgets/service_info.dart';
import 'widgets/service_description.dart';
import 'widgets/price_and_booking.dart';

class ServiceDetailsPage extends StatelessWidget {
  final Service service;

  const ServiceDetailsPage({Key? key, required this.service}) : super(key: key);

  void _showBookingForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BookingForm(serviceId: service.id, serviceName: service.name);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking confirmed!'), backgroundColor: Colors.green),
          );
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Service Details')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ServiceImage(imageUrl: service.imageUrl),
              ServiceInfo(service: service),
              ServiceDescription(description: service.description),
              PriceAndBooking(service: service, onBookNow: () => _showBookingForm(context)),
            ],
          ),
        ),
      ),
    );
  }
}
