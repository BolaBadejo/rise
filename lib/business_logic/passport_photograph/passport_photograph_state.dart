part of 'passport_photograph_bloc.dart';

abstract class PassportPhotographState extends Equatable {
  const PassportPhotographState();
}

class PassportPhotographInitialState extends PassportPhotographState {
  @override
  List<Object> get props => [];
}

class PassportPhotographLoadingState extends PassportPhotographState {
  @override
  List<Object> get props => [];
}

class PassportPhotographLoadedState extends PassportPhotographState {
  final PassportPhotographResponse passportPhotographResponse;

  const PassportPhotographLoadedState({required this.passportPhotographResponse});

  @override
  List<Object> get props => [passportPhotographResponse];
}

class PassportPhotographErrorState extends PassportPhotographState {
  final String error;

  const PassportPhotographErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
