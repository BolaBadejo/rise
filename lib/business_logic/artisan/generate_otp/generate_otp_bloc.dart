import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/generate_otp/generate_otp_response_model.dart';
import '../../../data_artisan/repositories/generate_otp_repo.dart';

part 'generate_otp_event.dart';

part 'generate_otp_state.dart';

class GenerateOtpBloc extends Bloc<GenerateOtpEvent, GenerateOtpState> {
  final GenerateOtpRepository generateOtpRepository;

  GenerateOtpBloc(this.generateOtpRepository)
      : super(GenerateOtpInitialState()) {
    on<GenerateOtpEvent>((event, emit) async {
      if (event is LoadGenerateOtpEvent) {
        emit(GenerateOtpLoadingState());
        try {
          final generateOtpResponse = await generateOtpRepository
              .fetchGeneratedOtpData(event.requestBody);
          emit(
              GenerateOtpLoadedState(generateOtpResponse: generateOtpResponse));
        } catch (e) {
          emit(GenerateOtpErrorState(error: e.toString()));
        }
      }
    });
  }
}
