part of 'create_booking_bloc.dart';

abstract class CreateBookingState extends Equatable {
  const CreateBookingState();
}

class CreateBookingInitialState extends CreateBookingState {
  @override
  List<Object> get props => [];
}

class CreateBookingLoadingState extends CreateBookingState {
  @override
  List<Object> get props => [];
}

class CreateBookingLoadedState extends CreateBookingState {
  final CreateBookingResponse createBookingResponse;

  const CreateBookingLoadedState({required this.createBookingResponse});

  @override
  List<Object> get props => [createBookingResponse];
}

class CreateBookingErrorState extends CreateBookingState {
  final String error;

  const CreateBookingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
