part of 'update_booking_status_bloc.dart';

abstract class UpdateBookingStatusState extends Equatable {
  const UpdateBookingStatusState();
}

class UpdateBookingStatusInitialState extends UpdateBookingStatusState {
  @override
  List<Object> get props => [];
}

class UpdateBookingStatusLoadingState extends UpdateBookingStatusState {
  @override
  List<Object> get props => [];
}

class UpdateBookingStatusLoadedState extends UpdateBookingStatusState {
  final UpdateBookingStatusResponse updateBookingStatusResponse;

  const UpdateBookingStatusLoadedState({required this.updateBookingStatusResponse});

  @override
  List<Object> get props => [updateBookingStatusResponse];
}

class UpdateBookingStatusErrorState extends UpdateBookingStatusState {
  final String error;

  const UpdateBookingStatusErrorState({required this.error});

  @override
  List<Object?> get props => [];
}