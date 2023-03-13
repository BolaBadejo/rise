part of 'save_bank_information_bloc.dart';

abstract class SaveBankInformationState extends Equatable {
  const SaveBankInformationState();
}

class SaveBankInformationInitialState extends SaveBankInformationState {
  @override
  List<Object> get props => [];
}

class SaveBusinessVerificationLoadingState extends SaveBankInformationState {
  @override
  List<Object> get props => [];
}

class SaveBankInformationLoadedState extends SaveBankInformationState {
  final SaveBankInformationResponse saveBankInformationResponse;

  const SaveBankInformationLoadedState(
      {required this.saveBankInformationResponse});

  @override
  List<Object> get props => [saveBankInformationResponse];
}

class SaveBankInformationErrorState extends SaveBankInformationState {
  final String error;

  const SaveBankInformationErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
