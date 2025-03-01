import 'package:secondproject/features/booking/data/model/booking_model.dart';

abstract class BookingState {}



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

class PaymentProcessing extends BookingState {}

class PaymentSuccess extends BookingState {
  final String transactionId;
  PaymentSuccess(this.transactionId);
}
class BookingInitial extends BookingState {
  final int selectedHours;
  final int selectedProfessionals;
  final bool needMaterials;
  final String instructions;
  final double totalAmount;
    final String serviceId;
  final String serviceName;

  BookingInitial({
    this.selectedHours = 2,
    this.selectedProfessionals = 1,
    this.needMaterials = false,
    this.instructions = '',
    this.totalAmount = 78.0,
    required this.serviceId,
    required this.serviceName,
  });

  BookingInitial copyWith({
    int? selectedHours,
    int? selectedProfessionals,
    bool? needMaterials,
    String? instructions,
    double? totalAmount,
      String? serviceId,
    String? serviceName,
  }) {
    return BookingInitial(
      selectedHours: selectedHours ?? this.selectedHours,
      selectedProfessionals: selectedProfessionals ?? this.selectedProfessionals,
      needMaterials: needMaterials ?? this.needMaterials,
      instructions: instructions ?? this.instructions,
      totalAmount: totalAmount ?? this.totalAmount,
           serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
    );
  }
}