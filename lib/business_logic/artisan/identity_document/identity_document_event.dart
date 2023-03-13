part of 'identity_document_bloc.dart';

abstract class IdentityDocumentEvent extends Equatable {
  const IdentityDocumentEvent();
}

class LoadIdentityDocumentEvent extends IdentityDocumentEvent {
  final String filePath;

  const LoadIdentityDocumentEvent({required this.filePath});

  @override
  List<Object> get props => [];
}
