import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:secondproject/features/booking/data/model/booking_model.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';

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
      final docRef = await _firestore.collection('bookingsTemp').add(booking.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }
    Future<String> createBookingsss(Booking booking) async {
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
    String paymentStatus,
    String paymentMethod,
  ) async {
    try {
      await _firestore.collection('bookingsTemp').doc(bookingId).update({
        'paymentDetails': {
          'transactionId': transactionId,
          'paymentStatus': paymentStatus,
          'method': paymentMethod,
          'timestamp': FieldValue.serverTimestamp(),
        }
      });
    } catch (e) {
      throw Exception("Failed to update booking payment: $e");
    }
  }

  // Fixed: Removed unused bookingId parameter and clarified method purpose
Future<List<Booking>> getUserBookings() async {
  try {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final querySnapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('bookingDate', descending: true)
        .get();

    List<Booking> bookings = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final serviceProviderId = data['serviceProviderId'];

      // Fetch service provider name from Firestore
      String serviceProviderName = "Unknown Provider";
      if (serviceProviderId != null) {
        final serviceProviderDoc = await _firestore
            .collection('serviceProviders')
            .doc(serviceProviderId)
            .get();
        if (serviceProviderDoc.exists) {
          serviceProviderName = serviceProviderDoc.data()?['name'] ?? "Unknown Provider";
        }
      }

      // Add the fetched serviceProviderName to the booking data
      bookings.add(Booking.fromMap({
        ...data,
        'id': doc.id,
        'serviceProviderName': serviceProviderName,
      }));
    }

    return bookings;
  } catch (e) {
    throw Exception('Failed to fetch bookings: $e');
  }
}

  
  Future<Booking?> getBookingById(String bookingId) async {
    try {
      final docSnapshot = await _firestore
          .collection('bookings')
          .doc(bookingId)
          .get();
          
      if (!docSnapshot.exists) return null;
      
      return Booking.fromMap({...docSnapshot.data()!, 'id': bookingId});
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  Future<void> confirmBookingLocation(String bookingId) async {
    try {
      if (bookingId.isEmpty) {
        throw Exception('Booking ID cannot be empty');
      }
      
      await _firestore
          .collection('bookingsTemp')
          .doc(bookingId)
          .update({'locationConfirmed': true});
    } catch (e) {
      throw Exception("Failed to confirm booking location: $e");
    }
  }
  
  Future<void> updateBookingLocation(
    String bookingId, 
    double latitude, 
    double longitude
  ) async {
    try {
      if (bookingId.isEmpty) {
        throw Exception('Booking ID cannot be empty');
      }
      
      await _firestore
          .collection('bookingsTemp')
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
    if (bookingId.isEmpty) {
      throw Exception('Booking ID cannot be empty');
    }
    
    try {
      await _firestore
          .collection('bookingsTemp')
          .doc(bookingId)
          .update({
            'scheduledDateTime': dateTime.toIso8601String(),
          });
    } catch (e) {
      throw Exception('Failed to update booking date/time: $e');
    }
  }
Future<void> _onUpdateBookingStatus(UpdateBookingStatus event, Emitter<BookingState> emit) async {
  try {
    emit(BookingLoading());

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(event.bookingId)
        .update({'bookingStatus': event.bookingStatus}); // Update only bookingStatus

    emit(BookingStatusUpdated(event.bookingStatus));
  } catch (e) {
    emit(BookingError("Failed to update booking status: ${e.toString()}"));
  }
}


}