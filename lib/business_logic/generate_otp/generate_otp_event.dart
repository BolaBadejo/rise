part of 'generate_otp_bloc.dart';

abstract class GenerateOtpEvent extends Equatable {
  const GenerateOtpEvent();
}

class LoadGenerateOtpEvent extends GenerateOtpEvent {
  final requestBody;

  const LoadGenerateOtpEvent({required this.requestBody});

  @override
  List<Object> get props => [];
}
