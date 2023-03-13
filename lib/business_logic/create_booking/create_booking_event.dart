part of 'create_booking_bloc.dart';

abstract class CreateBookingEvent extends Equatable {
  const CreateBookingEvent();
}
class LoadCreateBookingEvent extends CreateBookingEvent {
  final requestBody;

  const LoadCreateBookingEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}
