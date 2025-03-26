import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/booking/data/model/payment_model.dart';

class Booking {

  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final double totalAmount;
  final String bookingStatus;
  final int hours;
  final int professionals;
  final bool needMaterials;
  final String instructions;
  final DateTime bookingDate;
  final double? latitude;
  final double? longitude;
  final bool locationConfirmed;
  final DateTime? scheduledDateTime;
  final PaymentDetails? paymentDetails;
  final String paymentStatus;
  String? serviceProviderId;
  String? serviceProviderName;

  Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.totalAmount,
    required this.hours,
    required this.professionals,
    required this.needMaterials,
    required this.instructions,
    required this.bookingDate,
    required this.paymentStatus,
    this.latitude,
    this.longitude,
    this.locationConfirmed = false,
    this.scheduledDateTime,
    this.paymentDetails,
    this.serviceProviderId, 
    this.serviceProviderName,
    required this.bookingStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'totalAmount': totalAmount,
      'hours': hours,
      'professionals': professionals,
      'needMaterials': needMaterials,
      'instructions': instructions,
      'bookingDate': Timestamp.now(),
      'latitude': latitude,
      'longitude': longitude,
      'locationConfirmed': locationConfirmed,
      'scheduledDateTime': scheduledDateTime != null 
          ? Timestamp.fromDate(scheduledDateTime!): null,
      'paymentDetails': paymentDetails?.toMap(),
      'paymentStatus': paymentStatus,
      'serviceProviderId': serviceProviderId,
      'serviceProviderName': serviceProviderName,
      'bookingStatus':bookingStatus,
    };
  }

 factory Booking.fromMap(Map<String, dynamic> map) {
  // Helper function for safely converting Timestamp/String to DateTime
  DateTime? parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value == null) {
      return null;
    }
    // Default fallback
    return DateTime.now();
  }

  return Booking(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    serviceId: map['serviceId'] ?? '',
    serviceName: map['serviceName'] ?? '',
    totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
    hours: map['hours']?.toInt() ?? 0,
    professionals: map['professionals']?.toInt() ?? 0,
    needMaterials: map['needMaterials'] ?? false,
    instructions: map['instructions'] ?? '',
    bookingDate: map['bookingDate'] != null 
        ? parseDateTime(map['bookingDate']) ?? DateTime.now()
        : DateTime.now(),
    latitude: map['latitude']?.toDouble(),
    longitude: map['longitude']?.toDouble(),
    locationConfirmed: map['locationConfirmed'] ?? false,
    scheduledDateTime: map['scheduledDateTime'] != null 
        ? parseDateTime(map['scheduledDateTime'])
        : null,
    paymentDetails: map['paymentDetails'] != null
        ? PaymentDetails.fromMap(map['paymentDetails'])
        : null,
    paymentStatus: map['paymentStatus'] ?? '',
    serviceProviderId: map['serviceProviderId'],
    serviceProviderName: map['serviceProviderName'],
    bookingStatus:map['bookingStatus'],
    
  );
}
  Booking copyWith({
    String? id,
    String? userId,
    String? serviceId,
    String? serviceName,
    double? totalAmount,
    int? hours,
    int? professionals,
    bool? needMaterials,
    String? instructions,
    DateTime? bookingDate,
    double? latitude,
    double? longitude,
    bool? locationConfirmed,
    DateTime? scheduledDateTime,
    PaymentDetails? paymentDetails,
    String? paymentStatus,
    String? serviceProviderId,
    String? serviceProviderName,
    String?bookingStatus,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      totalAmount: totalAmount ?? this.totalAmount,
      hours: hours ?? this.hours,
      professionals: professionals ?? this.professionals,
      needMaterials: needMaterials ?? this.needMaterials,
      instructions: instructions ?? this.instructions,
      bookingDate: bookingDate ?? this.bookingDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      serviceProviderName: serviceProviderName ?? this.serviceProviderName,
      locationConfirmed: locationConfirmed ?? this.locationConfirmed,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      bookingStatus:bookingStatus??this.bookingStatus,
    );
  }
}