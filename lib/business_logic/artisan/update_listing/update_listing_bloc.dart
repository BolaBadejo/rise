import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data_artisan/model/update_listing/update_listing_response_model.dart';
import '../../../data_artisan/repositories/update_listing_repo.dart';

part 'update_listing_event.dart';

part 'update_listing_state.dart';

class UpdateListingBloc extends Bloc<UpdateListingEvent, UpdateListingState> {
  final UpdateListingRepository updateListingRepository;

  UpdateListingBloc(this.updateListingRepository)
      : super(UpdateListingInitialState()) {
    on<UpdateListingEvent>((event, emit) async {
      if (event is LoadUpdateListingEvent) {
        emit(UpdateListingLoadingState());
        try {
          final updateListingResponse =
              await updateListingRepository.fetchUpdateListingData(
                  event.imageFile,
                  event.category,
                  event.serviceOffering,
                  event.serviceTitle,
                  event.serviceDescription,
                  event.amount,
                  event.serviceTags,
                  event.id);
          emit(UpdateListingLoadedState(
              updateListingResponse: updateListingResponse));
        } catch (e) {
          emit(UpdateListingErrorState(error: e.toString()));
        }
      }
    });
  }
}
