part of 'verify_otp_bloc.dart';

abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();
}

class LoadVerifyOtpEvent extends VerifyOtpEvent {
  final requestBody;

  const LoadVerifyOtpEvent({required this.requestBody});

  @override
  List<Object> get props => [];
}
