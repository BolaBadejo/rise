part of 'find_listing_bloc.dart';

abstract class FindListingState extends Equatable {
  const FindListingState();
}

class FindListingInitialState extends FindListingState {
  @override
  List<Object> get props => [];
}

class FindListingLoadingState extends FindListingState {
  @override
  List<Object> get props => [];
}

class FindListingLoadedState extends FindListingState {
  final FindListingResponse findListingResponse;

  const FindListingLoadedState({required this.findListingResponse});

  @override
  List<Object> get props => [findListingResponse];
}

class FindListingErrorState extends FindListingState {
  final String error;

  const FindListingErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
