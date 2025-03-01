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
class ProcessPayment extends BookingEvent {
  final String bookingId;
  final String paymentMethod;
  final double amount;

  ProcessPayment({
    required this.bookingId,
    required this.paymentMethod,
    required this.amount,
  });
}
class UpdateBookingSelection extends BookingEvent {
  final int? selectedHours;
  final int? selectedProfessionals;
  final bool? needMaterials;
  final String? instructions;

  UpdateBookingSelection({
    this.selectedHours,
    this.selectedProfessionals,
    this.needMaterials,
    this.instructions,
  });
}


