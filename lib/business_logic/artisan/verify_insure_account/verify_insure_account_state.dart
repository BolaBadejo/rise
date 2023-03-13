part of 'verify_insure_account_bloc.dart';

abstract class VerifyInsureAccountState extends Equatable {
  const VerifyInsureAccountState();
}

class VerifyInsureAccountInitialState extends VerifyInsureAccountState {
  @override
  List<Object> get props => [];
}

class VerifyInsureAccountLoadingState extends VerifyInsureAccountState {
  @override
  List<Object> get props => [];
}

class VerifyInsureAccountLoadedState extends VerifyInsureAccountState {
  final VerifyInsureAccountResponse verifyInsureAccountResponse;

  const VerifyInsureAccountLoadedState(
      {required this.verifyInsureAccountResponse});

  @override
  List<Object> get props => [verifyInsureAccountResponse];
}

class VerifyInsureAccountErrorState extends VerifyInsureAccountState {
  final String error;

  const VerifyInsureAccountErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
