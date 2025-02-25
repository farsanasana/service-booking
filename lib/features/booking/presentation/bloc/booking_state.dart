import 'package:secondproject/features/booking/data/model/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String bookingId;
  BookingSuccess(this.bookingId);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingsLoaded extends BookingState {
  final List<Booking> bookings;
  BookingsLoaded(this.bookings);
}

class TimeSelectionSuccess extends BookingState {}
/// 📌 **New State to Hold Updated Location**
class BookingLocationUpdated extends BookingState {
  final double latitude;
  final double longitude;
  BookingLocationUpdated(this.latitude, this.longitude);
}

class LocationUpdateSuccess extends BookingState {}