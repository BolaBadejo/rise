part of 'update_booking_status_bloc.dart';

abstract class UpdateBookingStatusEvent extends Equatable {
  const UpdateBookingStatusEvent();
}
class LoadUpdateBookingStatusEvent extends UpdateBookingStatusEvent {
  final requestBody;

  const LoadUpdateBookingStatusEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}