part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
}

class LoadBookingEvent extends BookingEvent {
  @override
  List<Object> get props => [];
}

class RefreshBookingEvent extends BookingEvent {
  @override
  List<Object> get props => [];
}
