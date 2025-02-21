import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/booking/data/repository/repository_booking.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking_event.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;

  BookingBloc(this._repository) : super(BookingInitial()) {
    on<CreateBooking>(_onCreateBooking);
    on<LoadUserBookings>(_onLoadUserBookings);
    on<UpdateBookingLocation>(_onUpdateBookingLocation);
    on<ConfirmBookingLocation>(_onConfirmBookingLocation);
    on<UpdateBookingDateTime>(_onUpdateBookingDateTime);
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookingId = await _repository.createBooking(event.booking);
      if (bookingId != null && bookingId.isNotEmpty) {
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
      await _repository.updateBookingLocation(
        event.bookingId,
        event.latitude,
        event.longitude,
      );
      emit(LocationUpdateSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onConfirmBookingLocation(
    ConfirmBookingLocation event,
    Emitter<BookingState> emit,
  ) async {
    try {
      await _repository.confirmBookingLocation(event.bookingId);
      emit(LocationUpdateSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
