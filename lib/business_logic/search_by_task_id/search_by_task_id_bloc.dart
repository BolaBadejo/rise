import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/search_by_task_id/search_by_task_id_response_model.dart';
import '../../data/repositories/search_by_task_id_repo.dart';

part 'search_by_task_id_event.dart';
part 'search_by_task_id_state.dart';

class SearchByTaskIdBloc extends Bloc<SearchByTaskIdEvent, SearchByTaskIdState> {
  final SearchByTaskIdRepository searchByTaskIdRepository;

  SearchByTaskIdBloc(this.searchByTaskIdRepository) : super(SearchByTaskIdInitialState()) {
    on<SearchByTaskIdEvent>((event, emit) async {
      if (event is LoadSearchByTaskIdEvent) {
        emit(SearchByTaskIdLoadingState());
        try {
          final searchByTaskIdResponse =
              await searchByTaskIdRepository.fetchSearchByTaskIdData(event.taskId);
          emit(SearchByTaskIdLoadedState(searchByTaskIdResponse: searchByTaskIdResponse));
        } catch (e) {
          emit(SearchByTaskIdErrorState(error: e.toString()));
        }
      }
    });
  }
}
