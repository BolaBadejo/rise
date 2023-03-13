import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data_artisan/model/lisiting/listingResponseModel.dart';

import '../../../data_artisan/repositories/listing_repo.dart';

part 'listing_event.dart';
part 'listing_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final ListingRepository listingRepository;

  ListingBloc(this.listingRepository) : super(ListingInitialState()) {
    on<ListingEvent>((event, emit) async {
      if (event is LoadListingEvent) {
        emit(ListingLoadingState());
        try {
          final listingResponse = await listingRepository.fetchListingData();
          emit(ListingLoadedState(listingResponseModel: listingResponse));
        } catch (e) {
          emit(ListingErrorState(error: e.toString()));
        }
      }
    });
  }
}
