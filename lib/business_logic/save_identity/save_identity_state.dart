part of 'save_identity_bloc.dart';

abstract class SaveIdentityState extends Equatable {
  const SaveIdentityState();
}

class SaveIdentityInitialState extends SaveIdentityState {
  @override
  List<Object> get props => [];
}

class SaveIdentityLoadingState extends SaveIdentityState {
  @override
  List<Object> get props => [];
}

class SaveIdentityLoadedState extends SaveIdentityState {
  final SaveIdentityInformationResponse saveIdentityInformationResponse;

  const SaveIdentityLoadedState({required this.saveIdentityInformationResponse});

  @override
  List<Object> get props => [saveIdentityInformationResponse];
}

class SaveIdentityErrorState extends SaveIdentityState {
  final String error;

  const SaveIdentityErrorState({required this.error});

  @override
  List<Object?> get props => [];
}