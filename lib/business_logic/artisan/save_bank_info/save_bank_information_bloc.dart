import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/save_bank_info/save_bank_information_response_model.dart';
import '../../../data_artisan/repositories/save_bank_info_repo.dart';

part 'save_bank_information_event.dart';
part 'save_bank_information_state.dart';

class SaveBankInformationBloc
    extends Bloc<SaveBankInformationEvent, SaveBankInformationState> {
  final SaveBankInformationRepository saveBankInformationRepository;

  SaveBankInformationBloc(this.saveBankInformationRepository)
      : super(SaveBankInformationInitialState()) {
    on<SaveBankInformationEvent>((event, emit) async {
      if (event is LoadSaveBankInformationEvent) {
        emit(SaveBusinessVerificationLoadingState());
        try {
          final saveBankInformationResponse =
              await saveBankInformationRepository
                  .fetchSaveBankInformationData(event.requestBody);
          emit(SaveBankInformationLoadedState(
              saveBankInformationResponse: saveBankInformationResponse));
        } catch (e) {
          emit(SaveBankInformationErrorState(error: e.toString()));
        }
      }
    });
  }
}
