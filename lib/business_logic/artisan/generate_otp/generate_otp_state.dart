part of 'generate_otp_bloc.dart';

abstract class GenerateOtpState extends Equatable {
  const GenerateOtpState();
}

class GenerateOtpInitialState extends GenerateOtpState {
  @override
  List<Object> get props => [];
}

class GenerateOtpLoadingState extends GenerateOtpState {
  @override
  List<Object> get props => [];
}

class GenerateOtpLoadedState extends GenerateOtpState {
  final GenerateOtpResponse generateOtpResponse;

  const GenerateOtpLoadedState({required this.generateOtpResponse});

  @override
  List<Object> get props => [generateOtpResponse];
}

class GenerateOtpErrorState extends GenerateOtpState {
  final String error;

  const GenerateOtpErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
