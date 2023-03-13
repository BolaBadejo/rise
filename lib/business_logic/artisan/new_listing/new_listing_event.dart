part of 'new_listing_bloc.dart';

abstract class NewListingEvent extends Equatable {
  const NewListingEvent();
}

class LoadNewListingEvent extends NewListingEvent {
  final List<XFile>? imageFileList;
  final String category;
  final String serviceOffering;
  final String serviceTitle;
  final String serviceDescription;
  final String amount;
  final List serviceTags;

  const LoadNewListingEvent({
    required this.imageFileList,
    required this.category,
    required this.serviceOffering,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.amount,
    required this.serviceTags,
  });

  @override
  List<Object> get props => [];
}
