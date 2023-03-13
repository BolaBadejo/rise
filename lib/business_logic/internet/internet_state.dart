part of 'internet_bloc.dart';

abstract class InternetState extends Equatable {
  const InternetState();
}

class InternetInitial extends InternetState {
  @override
  List<Object> get props => [];
}

class ConnectedState extends InternetState {
  final String message;

  const ConnectedState({required this.message});

  @override
  List<Object> get props => [];
}

class NotConnectedState extends InternetState {
  final String message;

  const NotConnectedState({required this.message});

  @override
  List<Object> get props => [];
}
