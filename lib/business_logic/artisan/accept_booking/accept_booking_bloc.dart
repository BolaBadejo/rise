import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data_artisan/repositories/accept_booking_repo.dart';

import '../../../data_artisan/model/accept_booking/accept_booking_response_model.dart';

part 'accept_booking_event.dart';
part 'accept_booking_state.dart';

class AcceptBookingBloc extends Bloc<AcceptBookingEvent, AcceptBookingState> {
  final AcceptBookingRepository acceptBookingRepository;

  AcceptBookingBloc(this.acceptBookingRepository)
      : super(AcceptBookingInitialState()) {
    on<AcceptBookingEvent>((event, emit) async {
      if (event is LoadAcceptBookingEvent) {
        emit(AcceptBookingLoadingState());
        try {
          final acceptBookingResponse = await acceptBookingRepository
              .fetchAcceptBookingData(event.requestBody);
          emit(AcceptBookingLoadedState(
              acceptBookingResponse: acceptBookingResponse));
        } catch (e) {
          emit(AcceptBookingErrorState(error: e.toString()));
        }
      }
    });
  }
}
