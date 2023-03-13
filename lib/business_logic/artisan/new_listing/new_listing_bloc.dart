import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data_artisan/model/new_listing/new_listing_response_model.dart';
import '../../../data_artisan/repositories/new_listing_repo.dart';

part 'new_listing_event.dart';

part 'new_listing_state.dart';

class NewListingBloc extends Bloc<NewListingEvent, NewListingState> {
  final NewListingRepository newListingRepository;

  NewListingBloc(this.newListingRepository) : super(NewListingInitialState()) {
    on<NewListingEvent>((event, emit) async {
      if (event is LoadNewListingEvent) {
        emit(NewListingLoadingState());
        try {
          final newListingResponse =
              await newListingRepository.fetchNewListingData(
            event.imageFileList,
            event.category,
            event.serviceOffering,
            event.serviceTitle,
            event.serviceDescription,
            event.amount,
            event.serviceTags,
          );
          emit(NewListingLoadedState(newListingResponse: newListingResponse));
        } catch (e) {
          emit(NewListingErrorState(error: e.toString()));
        }
      }
    });
  }
}
