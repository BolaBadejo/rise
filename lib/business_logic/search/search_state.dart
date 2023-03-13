part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitialState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadedState extends SearchState {
  final SearchResponse searchResponse;

  const SearchLoadedState({required this.searchResponse});

  @override
  List<Object> get props => [searchResponse];
}

class SearchErrorState extends SearchState {
  final String error;

  const SearchErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
