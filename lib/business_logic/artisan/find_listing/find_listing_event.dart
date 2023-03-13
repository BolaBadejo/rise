part of 'find_listing_bloc.dart';

abstract class FindListingEvent extends Equatable {
  const FindListingEvent();
}

class LoadFindListingEvent extends FindListingEvent {
  final String id;

  const LoadFindListingEvent({required this.id});

  @override
  List<Object> get props => [id];
}
