import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/start_booking/start_booking_response_model.dart';
import '../../data/repositories/start_booking_repo.dart';

part 'start_booking_event.dart';
part 'start_booking_state.dart';

class StartBookingBloc extends Bloc<StartBookingEvent, StartBookingState> {
  final StartBookingRepository startBookingRepository;

  StartBookingBloc(this.startBookingRepository) : super(StartBookingInitialState()) {
    on<StartBookingEvent>((event, emit) async {
      if (event is LoadStartBookingEvent) {
        emit(StartBookingLoadingState());
        try {
          final startBookingResponse =
          await startBookingRepository.fetchStartBookingData(event.requestBody);
          emit(StartBookingLoadedState(startBookingResponse: startBookingResponse));
        } catch (e) {
          emit(StartBookingErrorState(error: e.toString()));
        }
      }
    });
  }
}
