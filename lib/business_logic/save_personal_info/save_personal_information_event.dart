part of 'save_personal_information_bloc.dart';

abstract class SavePersonalInformationEvent extends Equatable {
  const SavePersonalInformationEvent();
}

class LoadSavePersonalInformationEvent extends SavePersonalInformationEvent {
  final requestBody;

  const LoadSavePersonalInformationEvent({required this.requestBody});

  @override
  List<Object> get props => [];
}

