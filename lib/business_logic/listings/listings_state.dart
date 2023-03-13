part of 'listings_bloc.dart';

abstract class ListingsState extends Equatable {
  const ListingsState();

  @override
  List<Object> get props => [];
}

class ListingsInitial extends ListingsState {
  @override
  List<Object> get props => [];
}

class ListingsLoading extends ListingsState {
  @override
  List<Object> get props => [];
}

class ListingsLoaded extends ListingsState {
  final ListingsModel listingsModel;

  const ListingsLoaded(this.listingsModel);

  @override
  List<Object> get props => [listingsModel];
}

class ListingsError extends ListingsState {
  final String? message;

  ListingsError(this.message);
}
