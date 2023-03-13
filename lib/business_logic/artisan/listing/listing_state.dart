part of 'listing_bloc.dart';

abstract class ListingState extends Equatable {
  const ListingState();
}

class ListingInitialState extends ListingState {
  @override
  List<Object> get props => [];
}

class ListingLoadingState extends ListingState {
  @override
  List<Object> get props => [];
}

class ListingLoadedState extends ListingState {
  final ListingResponseModel listingResponseModel;

  const ListingLoadedState({required this.listingResponseModel});

  @override
  List<Object> get props => [listingResponseModel];
}

class ListingErrorState extends ListingState {
  final String error;

  const ListingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
