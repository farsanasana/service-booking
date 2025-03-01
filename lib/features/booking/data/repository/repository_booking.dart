import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondproject/features/booking/data/model/booking_model.dart';


class BookingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  BookingRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<String> createBooking(Booking booking) async {
    try {
      final docRef = await _firestore.collection('bookings').add(booking.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }
  Future<void> updateBookingPayment(
    String bookingId,
    String transactionId,
    String status,
    String paymentMethod,
  ) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'paymentDetails': {
          'transactionId': transactionId,
          'status': status,
          'method': paymentMethod,
          'timestamp': FieldValue.serverTimestamp(),
        }
      });
    } catch (e) {
      throw Exception("Failed to update booking payment: $e");
    }
  }

  Future<List<Booking>> getUserBookings() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('bookingDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Booking.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }
    Future<void> confirmBookingLocation(String bookingId) async {
    try {
      // Example: If using Firestore
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'locationConfirmed': true});
    } catch (e) {
      throw Exception("Failed to confirm booking location: $e");
    }
  }
  Future<void> updateBookingLocation(String bookingId, double latitude, double longitude) async {
    try {
      // Example: If using Firestore
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
            'latitude': latitude,
            'longitude': longitude,
          });
    } catch (e) {
      throw Exception("Failed to update booking location: $e");
    }
  }
  Future<void> updateBookingDateTime(String bookingId, DateTime dateTime) async {
    try {
      // Example: If using Firestore
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
            'dateTime': dateTime.toIso8601String(),
          });
    } catch (e) {
      throw Exception("Failed to update booking date/time: $e");
    }
  }
}
