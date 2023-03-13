part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitialState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoadedState extends LoginState {
  final LoginResponse loginResponse;

  const LoginLoadedState({required this.loginResponse});

  @override
  List<Object> get props => [loginResponse];
}

class LoginErrorState extends LoginState {
  final String error;

  const LoginErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
