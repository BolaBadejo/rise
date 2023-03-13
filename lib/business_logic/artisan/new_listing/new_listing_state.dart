part of 'new_listing_bloc.dart';

abstract class NewListingState extends Equatable {
  const NewListingState();
}

class NewListingInitialState extends NewListingState {
  @override
  List<Object> get props => [];
}

class NewListingLoadingState extends NewListingState {
  @override
  List<Object> get props => [];
}

class NewListingLoadedState extends NewListingState {
  final NewListingResponse newListingResponse;

  const NewListingLoadedState({required this.newListingResponse});

  @override
  List<Object> get props => [newListingResponse];
}

class NewListingErrorState extends NewListingState {
  final String error;

  const NewListingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
