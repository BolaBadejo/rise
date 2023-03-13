part of 'register_new_user_bloc.dart';

abstract class RegisterNewUserState extends Equatable {
  const RegisterNewUserState();
}

class RegisterNewUserInitialState extends RegisterNewUserState {
  @override
  List<Object> get props => [];
}

class RegisterNewUserLoadingState extends RegisterNewUserState {
  @override
  List<Object> get props => [];
}

class RegisterNewUserLoadedState extends RegisterNewUserState {
  final RegisterNewUserResponse registerNewUserResponse;

  const RegisterNewUserLoadedState({required this.registerNewUserResponse});

  @override
  List<Object> get props => [registerNewUserResponse];
}

class RegisterNewUserErrorState extends RegisterNewUserState {
  final String error;

  const RegisterNewUserErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
