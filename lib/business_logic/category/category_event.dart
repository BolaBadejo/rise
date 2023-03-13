part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class LoadCategoryEvent extends CategoryEvent {
  @override
  List<Object> get props => [];
}
