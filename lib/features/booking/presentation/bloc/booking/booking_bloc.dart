import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:secondproject/features/booking/data/repository/repository_booking.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;
  double? _lastLatitude;
  double? _lastLongitude;
  String? _currentBookingId;

  BookingBloc(this._repository) : super(BookingInitial(serviceId: '',serviceName: '')) {
    on<CreateBooking>(_onCreateBooking);
    on<LoadUserBookings>(_onLoadUserBookings);
    on<UpdateBookingLocation>(_onUpdateBookingLocation);
    on<ConfirmBookingLocation>(_onConfirmBookingLocation);
    on<UpdateBookingDateTime>(_onUpdateBookingDateTime);
    on<ProcessPayment>(_onProcessPayment);
    on<UpdateBookingSelection>(_onUpdateBookingSelection);
  }

  // 🟢 Update Selection (Hours, Professionals, Materials, Instructions)
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

  // 🟢 Process Payment (Stripe / Cash)
  Future<void> _onProcessPayment(
      ProcessPayment event, Emitter<BookingState> emit) async {
    emit(PaymentProcessing());

    try {
      if (event.paymentMethod == 'credit_card') {
        final paymentIntentResult = await _createPaymentIntent(event);

        if (paymentIntentResult != null) {
          await _repository.updateBookingPayment(
            event.bookingId,
            paymentIntentResult['id'],
            'pending',
            event.paymentMethod,
          );
          emit(PaymentSuccess(paymentIntentResult['id']));
        } else {
          emit(BookingError('Failed to process payment'));
        }
      } else if (event.paymentMethod == 'cash') {
        await _repository.updateBookingPayment(
          event.bookingId,
          'cash_${DateTime.now().millisecondsSinceEpoch}',
          'pending_cash',
          'cash',
        );
        emit(PaymentSuccess('cash_payment'));
      }
    } catch (e) {
      emit(BookingError('Payment failed: ${e.toString()}'));
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(
      ProcessPayment event) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-backend-url.com/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': (event.amount * 100).toInt(),
          'currency': 'aed',
          'payment_method_types': ['card'],
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  // 🟢 Create Booking
  Future<void> _onCreateBooking(
      CreateBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookingId = await _repository.createBooking(event.booking);
      if (bookingId.isNotEmpty) {
        _currentBookingId = bookingId;
        emit(BookingSuccess(bookingId));
      } else {
        emit(BookingError("Failed to create booking"));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  // 🟢 Load User Bookings
  Future<void> _onLoadUserBookings(
      LoadUserBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await _repository.getUserBookings();
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  // 🟢 Update Booking Date/Time
  Future<void> _onUpdateBookingDateTime(
      UpdateBookingDateTime event, Emitter<BookingState> emit) async {
    try {
      await _repository.updateBookingDateTime(event.bookingId, event.dateTime);
      emit(TimeSelectionSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  // 🟢 Update Booking Location
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

  // 🟢 Confirm Booking Location
  Future<void> _onConfirmBookingLocation(
      ConfirmBookingLocation event, Emitter<BookingState> emit) async {
    try {
      if (_currentBookingId != null &&
          _lastLatitude != null &&
          _lastLongitude != null) {
        await _repository.confirmBookingLocation(_currentBookingId!);
        emit(LocationUpdateSuccess());
      } else {
        emit(BookingError("Missing booking details or location data"));
      }
    } catch (e) {
      emit(BookingError("Failed to confirm location: ${e.toString()}"));
    }
  }
}
