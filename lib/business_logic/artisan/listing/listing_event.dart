part of 'listing_bloc.dart';

abstract class ListingEvent extends Equatable {
  const ListingEvent();
}

class LoadListingEvent extends ListingEvent {
  @override
  List<Object> get props => [];
}
