part of 'update_listing_bloc.dart';

abstract class UpdateListingState extends Equatable {
  const UpdateListingState();
}

class UpdateListingInitialState extends UpdateListingState {
  @override
  List<Object> get props => [];
}

class UpdateListingLoadingState extends UpdateListingState {
  @override
  List<Object> get props => [];
}

class UpdateListingLoadedState extends UpdateListingState {
  final UpdateListingResponse updateListingResponse;

  const UpdateListingLoadedState({required this.updateListingResponse});

  @override
  List<Object> get props => [updateListingResponse];
}

class UpdateListingErrorState extends UpdateListingState {
  final String error;

  const UpdateListingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
