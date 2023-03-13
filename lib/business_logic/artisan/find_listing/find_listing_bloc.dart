import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/find_listing/find_listing_model.dart';
import '../../../data_artisan/repositories/find_listing_repo.dart';

part 'find_listing_event.dart';
part 'find_listing_state.dart';

class FindListingBloc extends Bloc<FindListingEvent, FindListingState> {
  final FindListingRepository findListingRepository;

  FindListingBloc(this.findListingRepository)
      : super(FindListingInitialState()) {
    on<FindListingEvent>((event, emit) async {
      if (event is LoadFindListingEvent) {
        emit(FindListingLoadingState());
        try {
          final findListingResponse =
              await findListingRepository.fetchFindListingData(event.id);
          emit(
              FindListingLoadedState(findListingResponse: findListingResponse));
        } catch (e) {
          emit(FindListingErrorState(error: e.toString()));
        }
      }
    });
  }
}
