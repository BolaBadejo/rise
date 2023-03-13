import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data/model/category/category_reposne_model.dart';

import '../../data/repositories/category_repo.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc(this.categoryRepository) : super(CategoryInitialState()) {
    on<CategoryEvent>((event, emit) async {
      if (event is LoadCategoryEvent) {
        emit(CategoryLoadingState());
        try {
          final categoryResponse = await categoryRepository.fetchCategoryData();
          emit(CategoryLoadedState(categoryResponse: categoryResponse));
        } catch (e) {
          emit(CategoryErrorState(error: e.toString()));
        }
      }
    });
  }
}
