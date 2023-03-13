import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/create_booking/create_booking_response_model.dart';
import '../../data/repositories/create_booking_repo.dart';

part 'create_booking_event.dart';
part 'create_booking_state.dart';

class CreateBookingBloc extends Bloc<CreateBookingEvent, CreateBookingState> {
  final CreateBookingRepository createBookingRepository;

  CreateBookingBloc(this.createBookingRepository) : super(CreateBookingInitialState()) {
    on<CreateBookingEvent>((event, emit) async {
      if (event is LoadCreateBookingEvent) {
        emit(CreateBookingLoadingState());
        try {
          final createBookingResponse =
              await createBookingRepository.fetchCreateBookingData(event.requestBody);
          emit(CreateBookingLoadedState(createBookingResponse: createBookingResponse));
        } catch (e) {
          emit(CreateBookingErrorState(error: e.toString()));
        }
      }
    });
  }
}
