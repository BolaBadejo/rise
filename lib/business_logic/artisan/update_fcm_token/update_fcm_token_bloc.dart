import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/repositories/update_fcm_token_repo.dart';

part 'update_fcm_token_event.dart';
part 'update_fcm_token_state.dart';

class UpdateFcmTokenBloc
    extends Bloc<UpdateFcmTokenEvent, UpdateFcmTokenState> {
  final UpdateFcmTokenRepository updateFcmTokenRepository;
  UpdateFcmTokenBloc(this.updateFcmTokenRepository)
      : super(UpdateFcmTokenInitialState()) {
    on<UpdateFcmTokenEvent>((event, emit) async {
      if (event is LoadUpdateFcmTokenEvent) {
        emit(UpdateFcmTokenLoadingState());
        try {
          final updateFcmTokenResponse =
              await updateFcmTokenRepository.fetchUpdateFcmTokenData();
          emit(UpdateFcmTokenLoadedState());
        } catch (e) {
          emit(UpdateFcmTokenErrorState(error: e.toString()));
        }
      }
    });
  }
}
