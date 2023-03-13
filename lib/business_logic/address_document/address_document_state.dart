part of 'address_document_bloc.dart';

abstract class AddressDocumentState extends Equatable {
  const AddressDocumentState();
}

class AddressDocumentInitialState extends AddressDocumentState {
  @override
  List<Object> get props => [];
}

class AddressDocumentLoadingState extends AddressDocumentState {
  @override
  List<Object> get props => [];
}

class AddressDocumentLoadedState extends AddressDocumentState {
  final AddressDocumentResponse addressDocumentResponse;

  const AddressDocumentLoadedState({required this.addressDocumentResponse});

  @override
  List<Object> get props => [addressDocumentResponse];
}

class AddressDocumentErrorState extends AddressDocumentState {
  final String error;

  const AddressDocumentErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
