import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/update_booking_status/update_booking_status_response_model.dart';
import '../../data/repositories/update_booking_status_repo.dart';

part 'update_booking_status_event.dart';
part 'update_booking_status_state.dart';

class UpdateBookingStatusBloc extends Bloc<UpdateBookingStatusEvent, UpdateBookingStatusState> {
  final UpdateBookingStatusRepository updateBookingStatusRepository;

  UpdateBookingStatusBloc(this.updateBookingStatusRepository) : super(UpdateBookingStatusInitialState()) {
    on<UpdateBookingStatusEvent>((event, emit) async {
      if (event is LoadUpdateBookingStatusEvent) {
        emit(UpdateBookingStatusLoadingState());
        try {
          final updateBookingStatusResponse =
          await updateBookingStatusRepository.fetchUpdateBookingStatusData(event.requestBody);
          emit(UpdateBookingStatusLoadedState(updateBookingStatusResponse: updateBookingStatusResponse));
        } catch (e) {
          emit(UpdateBookingStatusErrorState(error: e.toString()));
        }
      }
    });
  }
}
