part of 'verify_insure_account_bloc.dart';

abstract class VerifyInsureAccountEvent extends Equatable {
  const VerifyInsureAccountEvent();
}

class LoadVerifyInsureAccountEvent extends VerifyInsureAccountEvent {
  final requestBody;

  const LoadVerifyInsureAccountEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}
