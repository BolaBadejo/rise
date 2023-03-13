import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/save_business_verification/save_business_verification_reponse_model.dart';
import '../../../data_artisan/repositories/save_business_verification_repo.dart';

part 'save_business_verification_event.dart';

part 'save_business_verification_state.dart';

class SaveBusinessVerificationBloc
    extends Bloc<SaveBusinessVerificationEvent, SaveBusinessVerificationState> {
  final SaveBusinessVerificationRepository saveBusinessVerificationRepository;

  SaveBusinessVerificationBloc(this.saveBusinessVerificationRepository)
      : super(SaveBusinessVerificationInitialState()) {
    on<SaveBusinessVerificationEvent>((event, emit) async {
      if (event is LoadSaveBusinessVerificationEvent) {
        emit(SaveBusinessVerificationLoadingState());
        try {
          final saveBusinessVerificationResponse =
              await saveBusinessVerificationRepository
                  .fetchSaveBusinessVerificationData(
                      event.filePath,
                      event.isBusinessRegistered,
                      event.belongToUnion,
                      event.hasPhysicalStore,
                      event.businessAddress);
          emit(SaveBusinessVerificationLoadedState(
              saveBusinessVerificationResponse:
                  saveBusinessVerificationResponse));
        } catch (e) {
          emit(SaveBusinessVerificationErrorState(error: e.toString()));
        }
      }
    });
  }
}
