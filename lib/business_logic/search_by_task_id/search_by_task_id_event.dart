part of 'search_by_task_id_bloc.dart';

abstract class SearchByTaskIdEvent extends Equatable {
  const SearchByTaskIdEvent();
}

class LoadSearchByTaskIdEvent extends SearchByTaskIdEvent {
  final String taskId;

  const LoadSearchByTaskIdEvent({required this.taskId});

  @override
  List<Object> get props => [taskId];
}
