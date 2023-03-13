part of 'update_fcm_token_bloc.dart';

abstract class UpdateFcmTokenEvent extends Equatable {
  const UpdateFcmTokenEvent();
}

class LoadUpdateFcmTokenEvent extends UpdateFcmTokenEvent {
  @override
  List<Object> get props => [];
}
