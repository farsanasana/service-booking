import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/booking/data/repository/repository_booking.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;
  double? _lastLatitude;
  double? _lastLongitude;
    String? _currentBookingId;

  BookingBloc(this._repository) : super(BookingInitial()) {
    on<CreateBooking>(_onCreateBooking);
    on<LoadUserBookings>(_onLoadUserBookings);
    on<UpdateBookingLocation>(_onUpdateBookingLocation);
    on<ConfirmBookingLocation>(_onConfirmBookingLocation);
    on<UpdateBookingDateTime>(_onUpdateBookingDateTime);
  }

  Stream<BookingState> mapEventToState(BookingEvent event) async* {
    if (event is UpdateBookingLocation) {
      yield BookingLocationUpdated(event.latitude, event.longitude);
    } else if (event is ConfirmBookingLocation) {
      yield LocationUpdateSuccess();
    }
  }
  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
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

  Future<void> _onLoadUserBookings(
    LoadUserBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookings = await _repository.getUserBookings();
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onUpdateBookingDateTime(
    UpdateBookingDateTime event,
    Emitter<BookingState> emit,
  ) async {
    try {
      await _repository.updateBookingDateTime(event.bookingId, event.dateTime);
      emit(TimeSelectionSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onUpdateBookingLocation(
    UpdateBookingLocation event,
    Emitter<BookingState> emit,
  ) async {
    try {
_lastLatitude=event.latitude;
_lastLongitude=event.longitude;
if (_currentBookingId !=null) {
   await _repository.updateBookingLocation(
        _currentBookingId!,
        event.latitude,
        event.longitude,
      );
}

      emit(BookingLocationUpdated(
    event.latitude,
       event.longitude,
      ));
    } catch (e) {
      emit(BookingError("Failed to update location: ${e.toString()}"));
    }
  }

   Future<void> _onConfirmBookingLocation(
    ConfirmBookingLocation event,
    Emitter<BookingState> emit,
  ) async {
    try {
      if (_currentBookingId != null && _lastLatitude != null && _lastLongitude != null) {
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