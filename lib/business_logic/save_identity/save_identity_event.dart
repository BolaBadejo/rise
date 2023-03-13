part of 'save_identity_bloc.dart';

abstract class SaveIdentityEvent extends Equatable {
  const SaveIdentityEvent();
}

class LoadSaveIdentityEvent extends SaveIdentityEvent {
  final requestBody;

  const LoadSaveIdentityEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}