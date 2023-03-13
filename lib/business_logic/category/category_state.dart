part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitialState extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoadingState extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoadedState extends CategoryState {
  final CategoryResponse categoryResponse;

  const CategoryLoadedState({required this.categoryResponse});

  @override
  List<Object> get props => [categoryResponse];
}

class CategoryErrorState extends CategoryState {
  final String error;

  const CategoryErrorState({required this.error});

  @override
  List<Object?> get props => [];
}