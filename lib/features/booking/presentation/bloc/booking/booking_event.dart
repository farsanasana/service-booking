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
class ProcessPayment extends BookingEvent {
  final String bookingId;
  final String paymentMethod;
  final double totalAmount;

  ProcessPayment({
    required this.bookingId,
    required this.paymentMethod,
    required this.totalAmount,
  });
}
class StoreBookingData extends BookingEvent {
  final Map<String, dynamic> bookingData;
  final String tempBookingId;
  
  StoreBookingData(this.bookingData, this.tempBookingId);
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

class CreateBookingAfterPayment extends BookingEvent {
  final String tempBookingId;
  final DateTime dateTime;
  
  CreateBookingAfterPayment({
    required this.tempBookingId,
    required this.dateTime,
  });
}
class FetchBookingDetails extends BookingEvent {
  final String userId;
  
  FetchBookingDetails({required this.userId});
}
class UpdateBookingStatus extends BookingEvent {
  final String bookingId;
  final String bookingStatus; // pending, completed, cancelled
  UpdateBookingStatus(this.bookingId, this.bookingStatus, );
}

class UpdatePaymentStatus extends BookingEvent {
  final String bookingId;
  final String status; // unpaid, paid, failed
  UpdatePaymentStatus(this.bookingId, this.status);
}
