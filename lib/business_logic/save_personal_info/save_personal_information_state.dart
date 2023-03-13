part of 'save_personal_information_bloc.dart';

abstract class SavePersonalInformationState extends Equatable {
  const SavePersonalInformationState();
}

class SavePersonalInformationInitialState extends SavePersonalInformationState {
  @override
  List<Object> get props => [];
}

class SavePersonalInformationLoadingState extends SavePersonalInformationState {
  @override
  List<Object> get props => [];
}

class SavePersonalInformationLoadedState extends SavePersonalInformationState {
  final SavePersonalInformationResponse savePersonalInformationResponse;

  const SavePersonalInformationLoadedState(
      {required this.savePersonalInformationResponse});

  @override
  List<Object> get props => [savePersonalInformationResponse];
}

class SavePersonalInformationErrorState extends SavePersonalInformationState {
  final String error;

  const SavePersonalInformationErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
