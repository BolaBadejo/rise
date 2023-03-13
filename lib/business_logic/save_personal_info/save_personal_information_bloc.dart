import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data/model/save_personal_information/save_personal_information_response_model.dart';

import '../../data/repositories/save_personal_information_repo.dart';

part 'save_personal_information_event.dart';
part 'save_personal_information_state.dart';

class SavePersonalInformationBloc extends Bloc<SavePersonalInformationEvent, SavePersonalInformationState> {
  final SavePersonalInformationRepository savePersonalInformationRepository;
  SavePersonalInformationBloc(this.savePersonalInformationRepository) : super(SavePersonalInformationInitialState()) {
    on<SavePersonalInformationEvent>((event, emit) async{
      if (event is LoadSavePersonalInformationEvent) {
        emit(SavePersonalInformationLoadingState());
        try {
          final savePersonalInformationResponse =
          await savePersonalInformationRepository.fetchSavePersonalInformationData(event.requestBody);
          emit(SavePersonalInformationLoadedState(savePersonalInformationResponse: savePersonalInformationResponse));
        } catch (e) {
          emit(SavePersonalInformationErrorState(error: e.toString()));
        }
      }
    });
  }
}
