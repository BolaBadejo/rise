part of 'accept_booking_bloc.dart';

abstract class AcceptBookingEvent extends Equatable {
  const AcceptBookingEvent();
}
class LoadAcceptBookingEvent extends AcceptBookingEvent {
  final requestBody;

  const LoadAcceptBookingEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}
