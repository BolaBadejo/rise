import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data/dataproviders/api/api_provider.dart';
import 'package:rise/data/model/listings/listings_model.dart';
import 'package:rise/data/repositories/listings_repo.dart';

part 'listings_event.dart';
part 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final ListingsRepo _listingsRepo = ListingsRepo();
  ListingsBloc() : super(ListingsInitial()) {
    on<ListingsEvent>((event, emit) async {
      try {
        emit(ListingsLoading());
        final listings = await _listingsRepo.fetchListingsList();
        emit(ListingsLoaded(listings));
      } catch (e) {
        emit(ListingsError(e.toString()));
      }
    });
  }
}
