import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data/model/verify_otp/verify_otp_response_model.dart';

import '../../data/repositories/verify_otp_repo.dart';

part 'verify_otp_event.dart';

part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpRepository verifyOtpRepository;

  VerifyOtpBloc(this.verifyOtpRepository) : super(VerifyOtpInitialState()) {
    on<VerifyOtpEvent>((event, emit) async {
      if (event is LoadVerifyOtpEvent) {
        emit(VerifyOtpLoadingState());
        try {
          final verifyOtpResponse =
              await verifyOtpRepository.fetchVerifyOtpData(event.requestBody);
          emit(VerifyOtpLoadedState(verifyOtpResponse: verifyOtpResponse));
        } catch (e) {
          emit(VerifyOtpErrorState(error: e.toString()));
        }
      }
    });
  }
}
