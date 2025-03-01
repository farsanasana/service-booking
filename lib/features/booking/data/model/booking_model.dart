import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/booking/data/model/payment_model.dart';

class Booking {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final double totalAmount;
  final int hours;
  final int professionals;
  final bool needMaterials;
  final String instructions;
  final DateTime bookingDate;
  final double? latitude;
  final double? longitude;
  final String? address;
  final bool locationConfirmed;
  final DateTime? scheduledDateTime;
 final PaymentDetails? paymentDetails;

  Booking( {this.paymentDetails,
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
    this.latitude,
    this.longitude,
    this.address,
    this.locationConfirmed = false,
    this.scheduledDateTime,
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
      'bookingDate': Timestamp.fromDate(bookingDate),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'locationConfirmed': locationConfirmed,
      'scheduledDateTime': scheduledDateTime != null 
          ? Timestamp.fromDate(scheduledDateTime!) 
          : null,
             'paymentDetails': paymentDetails?.toMap(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
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
      bookingDate: (map['bookingDate'] as Timestamp).toDate(),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      address: map['address'],
      locationConfirmed: map['locationConfirmed'] ?? false,
      scheduledDateTime: map['scheduledDateTime'] != null 
          ? (map['scheduledDateTime'] as Timestamp).toDate() 
          : null,
              paymentDetails: map['paymentDetails'] != null
          ? PaymentDetails.fromMap(map['paymentDetails'])
          : null,
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
    String? address,
    bool? locationConfirmed,
    DateTime? scheduledDateTime, PaymentDetails? paymentDetails,
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
      address: address ?? this.address,
      locationConfirmed: locationConfirmed ?? this.locationConfirmed,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
    paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }
}