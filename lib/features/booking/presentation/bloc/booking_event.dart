import 'package:secondproject/features/booking/data/model/booking_model.dart';

abstract class BookingEvent {}

class CreateBooking extends BookingEvent {
  final Booking booking;
  CreateBooking(this.booking);
}

class LoadUserBookings extends BookingEvent {}
class UpdateBookingLocation extends BookingEvent {
  final String bookingId;
  final double latitude;
  final double longitude;

  UpdateBookingLocation({
    required this.bookingId,
    required this.latitude,
    required this.longitude,
  });
}

class ConfirmBookingLocation extends BookingEvent {
  final String bookingId;
  
  ConfirmBookingLocation({required this.bookingId});
}
class UpdateBookingDateTime extends BookingEvent {
  final String bookingId;
  final DateTime dateTime;

  UpdateBookingDateTime({
    required this.bookingId,
    required this.dateTime,
  });
}