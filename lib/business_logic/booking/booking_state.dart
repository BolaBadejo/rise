part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();
}

class BookingInitialState extends BookingState {
  @override
  List<Object> get props => [];
}

class BookingLoadingState extends BookingState {
  @override
  List<Object> get props => [];
}

class BookingLoadedState extends BookingState {
  final BookingResponse bookingResponse;

  const BookingLoadedState({required this.bookingResponse});

  @override
  List<Object> get props => [bookingResponse];
}

class BookingErrorState extends BookingState {
  final String error;

  const BookingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
