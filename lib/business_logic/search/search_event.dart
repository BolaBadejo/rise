part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class LoadSearchEvent extends SearchEvent {
  final String searchValue;
  final String city;
  final String state;

  const LoadSearchEvent({required this.searchValue, required this.city, required this.state});

  @override
  List<Object> get props => [];
}
