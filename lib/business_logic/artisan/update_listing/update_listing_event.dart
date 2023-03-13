part of 'update_listing_bloc.dart';

abstract class UpdateListingEvent extends Equatable {
  const UpdateListingEvent();
}

class LoadUpdateListingEvent extends UpdateListingEvent {
  final File? imageFile;
  final String category;
  final String serviceOffering;
  final String serviceTitle;
  final String serviceDescription;
  final String amount;
  final List serviceTags;
  final String id;

  const LoadUpdateListingEvent({
    required this.imageFile,
    required this.category,
    required this.serviceOffering,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.amount,
    required this.serviceTags,
    required this.id,
  });

  @override
  List<Object> get props => [];
}
