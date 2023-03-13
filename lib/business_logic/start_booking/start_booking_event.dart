part of 'start_booking_bloc.dart';

abstract class StartBookingEvent extends Equatable {
  const StartBookingEvent();
}

class LoadStartBookingEvent extends StartBookingEvent {
  final requestBody;

  const LoadStartBookingEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}