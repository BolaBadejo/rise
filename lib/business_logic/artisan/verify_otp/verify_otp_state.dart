part of 'verify_otp_bloc.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();
}

class VerifyOtpInitialState extends VerifyOtpState {
  @override
  List<Object> get props => [];
}

class VerifyOtpLoadingState extends VerifyOtpState {
  @override
  List<Object> get props => [];
}

class VerifyOtpLoadedState extends VerifyOtpState {
  final VerifyOtpResponse verifyOtpResponse;

  const VerifyOtpLoadedState({required this.verifyOtpResponse});

  @override
  List<Object> get props => [verifyOtpResponse];
}

class VerifyOtpErrorState extends VerifyOtpState {
  final String error;

  const VerifyOtpErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
