import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data/model/passport_photograph/passport_photograph_response_model.dart';

import '../../data/repositories/passport_photograph_repo.dart';

part 'passport_photograph_event.dart';
part 'passport_photograph_state.dart';

class PassportPhotographBloc extends Bloc<PassportPhotographEvent, PassportPhotographState> {
  final PassportPhotographRepository passportPhotographRepository;

  PassportPhotographBloc(this.passportPhotographRepository) : super(PassportPhotographInitialState()) {
    on<PassportPhotographEvent>((event, emit) async {
      if (event is LoadPassportPhotographEvent) {
        emit(PassportPhotographLoadingState());
        try {
          final passportPhotographResponse =
              await passportPhotographRepository.fetchPassportPhotographData(event.filePath);
          emit(PassportPhotographLoadedState(passportPhotographResponse: passportPhotographResponse));
        } catch (e) {
          emit(PassportPhotographErrorState(error: e.toString()));
        }
      }
    });
  }
}
