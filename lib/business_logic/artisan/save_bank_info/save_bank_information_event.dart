part of 'save_bank_information_bloc.dart';

abstract class SaveBankInformationEvent extends Equatable {
  const SaveBankInformationEvent();
}

class LoadSaveBankInformationEvent extends SaveBankInformationEvent {
  final requestBody;

  const LoadSaveBankInformationEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}
