import 'package:secondproject/features/booking/data/model/booking_model.dart';

abstract class BookingEvent {}

class CreateBooking extends BookingEvent {
  final Booking booking;
  CreateBooking(this.booking);
}

class LoadUserBookings extends BookingEvent {}
class UpdateBookingLocation extends BookingEvent {
  final double latitude;
  final double longitude;

  UpdateBookingLocation({required this.latitude, required this.longitude});
}

class ConfirmBookingLocation extends BookingEvent {}
class UpdateBookingDateTime extends BookingEvent {
  final String bookingId;
  final DateTime dateTime;

  UpdateBookingDateTime({
    required this.bookingId,
    required this.dateTime,
  });
}