part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

class LoadForgotPasswordEvent extends ForgotPasswordEvent {
  final requestBody;

  const LoadForgotPasswordEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}