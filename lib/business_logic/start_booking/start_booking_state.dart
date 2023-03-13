part of 'start_booking_bloc.dart';

abstract class StartBookingState extends Equatable {
  const StartBookingState();
}

class StartBookingInitialState extends StartBookingState {
  @override
  List<Object> get props => [];
}

class StartBookingLoadingState extends StartBookingState {
  @override
  List<Object> get props => [];
}

class StartBookingLoadedState extends StartBookingState {
  final StartBookingResponse startBookingResponse;

  const StartBookingLoadedState({required this.startBookingResponse});

  @override
  List<Object> get props => [startBookingResponse];
}

class StartBookingErrorState extends StartBookingState {
  final String error;

  const StartBookingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}