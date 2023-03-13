part of 'save_business_verification_bloc.dart';

abstract class SaveBusinessVerificationState extends Equatable {
  const SaveBusinessVerificationState();
}

class SaveBusinessVerificationInitialState
    extends SaveBusinessVerificationState {
  @override
  List<Object> get props => [];
}

class SaveBusinessVerificationLoadingState
    extends SaveBusinessVerificationState {
  @override
  List<Object> get props => [];
}

class SaveBusinessVerificationLoadedState
    extends SaveBusinessVerificationState {
  final SaveBusinessVerificationResponse saveBusinessVerificationResponse;

  const SaveBusinessVerificationLoadedState(
      {required this.saveBusinessVerificationResponse});

  @override
  List<Object> get props => [saveBusinessVerificationResponse];
}

class SaveBusinessVerificationErrorState extends SaveBusinessVerificationState {
  final String error;

  const SaveBusinessVerificationErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
