part of 'register_new_user_bloc.dart';

abstract class RegisterNewUserEvent extends Equatable {
  const RegisterNewUserEvent();
}

class LoadRegisterNewUserEvent extends RegisterNewUserEvent {
  final requestBody;

  const LoadRegisterNewUserEvent({required this.requestBody});

  @override
  List<Object> get props => [];
}
