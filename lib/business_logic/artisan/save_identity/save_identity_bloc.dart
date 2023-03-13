import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/save_identity_information/save_idnentity_information_response_model.dart';
import '../../../data_artisan/repositories/save_identity_information_repo.dart';

part 'save_identity_event.dart';

part 'save_identity_state.dart';

class SaveIdentityBloc extends Bloc<SaveIdentityEvent, SaveIdentityState> {
  final SaveIdentityInformationRepository saveIdentityInformationRepository;

  SaveIdentityBloc(this.saveIdentityInformationRepository)
      : super(SaveIdentityInitialState()) {
    on<SaveIdentityEvent>((event, emit) async {
      if (event is LoadSaveIdentityEvent) {
        emit(SaveIdentityLoadingState());
        try {
          final saveIdentityInformationResponse =
              await saveIdentityInformationRepository
                  .fetchSaveIdentityInformationData(event.requestBody);
          emit(SaveIdentityLoadedState(
              saveIdentityInformationResponse:
                  saveIdentityInformationResponse));
        } catch (e) {
          emit(SaveIdentityErrorState(error: e.toString()));
        }
      }
    });
  }
}
