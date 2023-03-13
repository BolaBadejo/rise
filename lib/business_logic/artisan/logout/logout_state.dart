part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();
}

class LogoutInitialState extends LogoutState {
  @override
  List<Object> get props => [];
}

class LogoutLoadingState extends LogoutState {
  @override
  List<Object> get props => [];
}

class LogoutLoadedState extends LogoutState {
  final LogOutResponse logOutResponse;

  const LogoutLoadedState({required this.logOutResponse});

  @override
  List<Object> get props => [logOutResponse];
}

class LogoutErrorState extends LogoutState {
  final String error;

  const LogoutErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
