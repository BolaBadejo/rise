import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/search/search_response_model.dart';
import '../../data/repositories/search_repo.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;
  SearchBloc(this.searchRepository) : super(SearchInitialState()) {
    on<SearchEvent>((event, emit) async {
      if (event is LoadSearchEvent) {
        emit(SearchLoadingState());
        try {
          final searchResponse = await searchRepository.fetchSearchData(event.searchValue,event.city,event.state);
          emit(SearchLoadedState(searchResponse: searchResponse));
        } catch (e) {
          emit(SearchErrorState(error: e.toString()));
        }
      }
    });
  }
}
