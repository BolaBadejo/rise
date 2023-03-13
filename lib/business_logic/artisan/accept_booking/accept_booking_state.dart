part of 'accept_booking_bloc.dart';

abstract class AcceptBookingState extends Equatable {
  const AcceptBookingState();
}

class AcceptBookingInitialState extends AcceptBookingState {
  @override
  List<Object> get props => [];
}

class AcceptBookingLoadingState extends AcceptBookingState {
  @override
  List<Object> get props => [];
}

class AcceptBookingLoadedState extends AcceptBookingState {
  final AcceptBookingResponse acceptBookingResponse;

  const AcceptBookingLoadedState({required this.acceptBookingResponse});

  @override
  List<Object> get props => [acceptBookingResponse];
}

class AcceptBookingErrorState extends AcceptBookingState {
  final String error;

  const AcceptBookingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
