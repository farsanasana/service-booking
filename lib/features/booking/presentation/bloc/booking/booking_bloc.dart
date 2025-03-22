import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:secondproject/core/constand/api.dart';
import 'package:secondproject/features/booking/data/repository/repository_booking.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';
import 'package:secondproject/features/booking/data/model/booking_model.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;
  double? _lastLatitude;
  double? _lastLongitude;
  String? _currentBookingId;
  Map<String, dynamic> _tempBookingData = {};
  String _tempBookingId = '';
  String _fullAddress = ''; // Added missing variable

  BookingBloc(this._repository) : super(BookingInitial(serviceId: '', serviceName: '')) {
    on<CreateBooking>(_onCreateBooking);
    on<FetchBookingDetails>(_onFetchBookingDetails); 
    on<CreateBookingAfterPayment>(_onCreateBookingAfterPayment); // Fixed typo 'n<' to 'on<'
    //on<LoadUserBookings>(_onLoadUserBookings);
    on<UpdateBookingLocation>(_onUpdateBookingLocation);
    on<ConfirmBookingLocation>(_onConfirmBookingLocation);
    on<UpdateBookingDateTime>(_onUpdateBookingDateTime);
    on<ProcessPayment>(_onProcessPayment);
    on<StoreBookingData>(_onStoreBookingData);
    on<UpdateBookingSelection>(_onUpdateBookingSelection);
on<UpdateBookingStatus>(_onUpdateBookingStatus);


  }


// Inside BookingBloc class, modify the _onFetchBookingDetails method:

Future<void> _onFetchBookingDetails(FetchBookingDetails event, Emitter<BookingState> emit) async {
  emit(BookingLoading());
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: event.userId)
        .get();

    List<Map<String, dynamic>> bookings = [];
    
    // Process each booking document
    for (var doc in snapshot.docs) {
      var data = doc.data();
      data['id'] = doc.id;
      
      // Ensure address is included properly
      if (data['address'] == null || data['address'].toString().isEmpty) {
        if (data['latitude'] != null && data['longitude'] != null) {
          data['address'] = 'Location: (${data['latitude']}, ${data['longitude']})';
        } else {
          data['address'] = 'No address provided';
        }
      }
      
      // Fetch service provider name if serviceProviderId exists
      if (data['serviceProviderId'] != null) {
        try {
          final serviceProviderDoc = await FirebaseFirestore.instance
              .collection('serviceProviders')
              .doc(data['serviceProviderId'])
              .get();
              
          if (serviceProviderDoc.exists) {
            data['serviceProviderName'] = serviceProviderDoc.data()?['name'] ?? "Unknown Provider";
          } else {
            data['serviceProviderName'] = "Provider Not Found";
          }
        } catch (e) {
          print("Error fetching service provider: $e");
          data['serviceProviderName'] = "Error Loading Provider";
        }
      } else {
        data['serviceProviderName'] = "No Provider Assigned";
      }
      
      bookings.add(data);
    }

    if (bookings.isNotEmpty) {
      emit(BookingsLoaded(bookings));
    } else {
      emit(BookingError('No bookings found'));
    }
  } catch (e) {
    emit(BookingError('Failed to fetch bookings: ${e.toString()}'));
  }
}

  // Update Selection (Hours, Professionals, Materials, Instructions)
  void _onUpdateBookingSelection(
      UpdateBookingSelection event, Emitter<BookingState> emit) {
    if (state is BookingInitial) {
      final currentState = state as BookingInitial;

      emit(currentState.copyWith(
        selectedHours: event.selectedHours ?? currentState.selectedHours,
        selectedProfessionals:
            event.selectedProfessionals ?? currentState.selectedProfessionals,
        needMaterials: event.needMaterials ?? currentState.needMaterials,
        instructions: event.instructions ?? currentState.instructions,
      ));
    }
  }

  // Modify the _onProcessPayment method in your BookingBloc
Future<void> _onProcessPayment(ProcessPayment event, Emitter<BookingState> emit) async {
  emit(PaymentProcessing());
  
  try {
    if (event.paymentMethod == 'credit_card') {
      // Step 1: Create payment method with error handling
      final PaymentMethod paymentMethod;
      try {
        paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(),
          ),
        );
        print('Payment method created with ID: ${paymentMethod.id}');
      } catch (e) {
        emit(BookingError('Card validation failed: ${e.toString()}'));
        return;
      }
      
      // Step 2: Call your backend with proper error handling
      try {
        final response = await http.post(
          Uri.parse('https://your-backend.com/create-payment-intent'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'amount': (event.totalAmount * 100).toInt(),
            'currency': 'aed',
            'payment_method_id': paymentMethod.id,
          }),
        );
        
        print('Payment API response code: ${response.statusCode}');
        print('Payment API response body: ${response.body}');
        
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final paymentIntent = json.decode(response.body);
          await _repository.updateBookingPayment(
            event.bookingId,
            paymentIntent['id'],
            'completed',
            event.paymentMethod,
          );
          emit(PaymentSuccess(paymentIntent['id']));
          
          // Add this to emit BookingCompleted after payment is successful
          emit(BookingCompleted(bookingId: event.bookingId, totalAmount: event.totalAmount));
        } else {
          emit(BookingError('Server returned error: ${response.statusCode}'));
        }
      } catch (e) {
        emit(BookingError('Network error: ${e.toString()}'));
      }
    } else if (event.paymentMethod == 'cash') {
      // Cash payment logic
      await _repository.updateBookingPayment(
        event.bookingId,
        'cash_${DateTime.now().millisecondsSinceEpoch}',
        'pending_cash',
        'cash',
      );
      emit(PaymentSuccess('cash_payment'));
      
      // Add this to emit BookingCompleted after cash payment is successful
      emit(BookingCompleted(bookingId: event.bookingId, totalAmount: event.totalAmount));
    }
  } catch (e) {
    emit(BookingError('Payment failed: ${e.toString()}'));
  }
}

void _onCreateBookingAfterPayment(
  CreateBookingAfterPayment event, 
  Emitter<BookingState> emit
) async {
  emit(BookingLoading());

  try {
    // Ensure _tempBookingData is available before using it
    if (_tempBookingData.isEmpty) {
      emit(BookingError("Booking data is missing"));
      return;
    }

    // Create a Booking object from the stored data
    final booking = Booking(
      id: event.tempBookingId,
      userId: _tempBookingData['userId'] ?? '',
      serviceId: _tempBookingData['serviceId'] ?? '',
      serviceName: _tempBookingData['serviceName'] ?? '',
      totalAmount: _tempBookingData['totalAmount'] ?? 0.0,
      hours: _tempBookingData['hours'] ?? 1,
      professionals: _tempBookingData['professionals'] ?? 1,
      needMaterials: _tempBookingData['needMaterials'] ?? false,
      instructions: _tempBookingData['instructions'] ?? '',
      bookingDate: event.dateTime,
      latitude: _lastLatitude ?? 0.0,  // Default to 0.0 to avoid errors
      longitude: _lastLongitude ?? 0.0,
      paymentStatus: 'completed',
       bookingStatus: _tempBookingData['bookingStatus'],
    );

    // Call repository method to create booking in Firebase
    final String bookingId = await _repository.createBookingsss(booking);

    if (bookingId.isNotEmpty) {
      emit(BookingSuccess(bookingId: bookingId, totalAmount: booking.totalAmount));
    } else {
      emit(BookingError("Failed to create booking"));
    }
  } catch (e) {
    print("🔴 Error Creating Booking: $e");
    emit(BookingError("An error occurred: ${e.toString()}"));
  }
}


  void _onStoreBookingData(StoreBookingData event, Emitter<BookingState> emit) {
    _tempBookingData = event.bookingData;
    _tempBookingId = event.tempBookingId;
    emit(BookingDataStored(_tempBookingId));
  }

  Future<void> _onCreateBooking(CreateBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookingId = await _repository.createBooking(event.booking);
      print("🔹 Created Booking ID: $bookingId"); // Debugging
      if (bookingId.isNotEmpty) {
        _currentBookingId = bookingId;
        emit(BookingSuccess(bookingId: bookingId, totalAmount: event.booking.totalAmount)); 
      } else {
        emit(BookingError("Failed to create booking"));
      }
    } catch (e) {
      print("Error Creating Booking: $e");
      emit(BookingError(e.toString()));
    }
  }

 
  Future<void> _onUpdateBookingDateTime(
      UpdateBookingDateTime event, Emitter<BookingState> emit) async {
    try {
      await _repository.updateBookingDateTime(event.bookingId, event.dateTime);
      emit(TimeSelectionSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  // Update Booking Location
  Future<void> _onUpdateBookingLocation(
      UpdateBookingLocation event, Emitter<BookingState> emit) async {
    try {
      _lastLatitude = event.latitude;
      _lastLongitude = event.longitude;

      if (_currentBookingId != null) {
        await _repository.updateBookingLocation(
          _currentBookingId!,
          event.latitude,
          event.longitude,
        );
      }

      emit(BookingLocationUpdated(event.latitude, event.longitude));
    } catch (e) {
      emit(BookingError("Failed to update location: ${e.toString()}"));
    }
  }

  // Confirm Booking Location
  Future<void> _onConfirmBookingLocation(
      ConfirmBookingLocation event, Emitter<BookingState> emit) async {
    try {
      if (event.bookingId.isNotEmpty &&
          _lastLatitude != null &&
          _lastLongitude != null) {
        await _repository.confirmBookingLocation(event.bookingId);
        emit(LocationUpdateSuccess());
      } else {
        emit(BookingError("Missing booking details or location data"));
      }
    } catch (e) {
      emit(BookingError("Failed to confirm location: ${e.toString()}"));
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