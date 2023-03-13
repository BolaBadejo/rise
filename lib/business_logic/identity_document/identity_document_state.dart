part of 'identity_document_bloc.dart';

abstract class IdentityDocumentState extends Equatable {
  const IdentityDocumentState();
}

class IdentityDocumentInitialState extends IdentityDocumentState {
  @override
  List<Object> get props => [];
}

class IdentityDocumentLoadingState extends IdentityDocumentState {
  @override
  List<Object> get props => [];
}

class IdentityDocumentLoadedState extends IdentityDocumentState {
  final IdentityDocumentResponse identityDocumentResponse;

  const IdentityDocumentLoadedState({required this.identityDocumentResponse});

  @override
  List<Object> get props => [identityDocumentResponse];
}

class IdentityDocumentErrorState extends IdentityDocumentState {
  final String error;

  const IdentityDocumentErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
