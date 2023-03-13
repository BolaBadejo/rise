part of 'passport_photograph_bloc.dart';

abstract class PassportPhotographEvent extends Equatable {
  const PassportPhotographEvent();
}

class LoadPassportPhotographEvent extends PassportPhotographEvent {
  final String filePath;

  const LoadPassportPhotographEvent({required this.filePath});

  @override
  List<Object> get props => [];
}
