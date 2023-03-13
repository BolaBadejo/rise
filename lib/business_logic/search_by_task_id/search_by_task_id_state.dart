part of 'search_by_task_id_bloc.dart';

abstract class SearchByTaskIdState extends Equatable {
  const SearchByTaskIdState();
}

class SearchByTaskIdInitialState extends SearchByTaskIdState {
  @override
  List<Object> get props => [];
}

class SearchByTaskIdLoadingState extends SearchByTaskIdState {
  @override
  List<Object> get props => [];
}

class SearchByTaskIdLoadedState extends SearchByTaskIdState {
  final SearchByTaskIdResponse searchByTaskIdResponse;

  const SearchByTaskIdLoadedState({required this.searchByTaskIdResponse});

  @override
  List<Object> get props => [searchByTaskIdResponse];
}

class SearchByTaskIdErrorState extends SearchByTaskIdState {
  final String error;

  const SearchByTaskIdErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
