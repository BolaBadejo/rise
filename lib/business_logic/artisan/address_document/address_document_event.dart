part of 'address_document_bloc.dart';

abstract class AddressDocumentEvent extends Equatable {
  const AddressDocumentEvent();
}

class LoadAddressDocumentEvent extends AddressDocumentEvent {
  final String filePath;

  const LoadAddressDocumentEvent({required this.filePath});

  @override
  List<Object> get props => [];
}
