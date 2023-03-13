import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/booking/booking_reponse_model.dart';
import '../../../data_artisan/repositories/booking_repo.dart';

part 'booking_event.dart';

part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitialState()) {
    on<BookingEvent>((event, emit) async {
      if (event is LoadBookingEvent) {
        emit(BookingLoadingState());
        try {
          final bookingResponse = await bookingRepository.fetchBookingData();
          emit(BookingLoadedState(bookingResponse: bookingResponse));
        } catch (e) {
          emit(BookingErrorState(error: e.toString()));
        }
      }
    });
  }
}
