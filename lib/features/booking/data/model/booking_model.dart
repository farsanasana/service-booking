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
  final String status;

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
    this.status = 'pending',
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
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      userId: map['userId'],
      serviceId: map['serviceId'],
      serviceName: map['serviceName'],
      totalAmount: map['totalAmount'],
      hours: map['hours'],
      professionals: map['professionals'],
      needMaterials: map['needMaterials'],
      instructions: map['instructions'],
      bookingDate: DateTime.parse(map['bookingDate']),
      status: map['status'],
    );
  }
}