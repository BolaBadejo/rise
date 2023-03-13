part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
}

class ForgotPasswordInitialState extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class ForgotPasswordLoadedState extends ForgotPasswordState {
  final ForgotPasswordResponse forgotPasswordResponse;

  const ForgotPasswordLoadedState({required this.forgotPasswordResponse});

  @override
  List<Object> get props => [forgotPasswordResponse];
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String error;

  const ForgotPasswordErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
