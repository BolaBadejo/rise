part of 'update_fcm_token_bloc.dart';

abstract class UpdateFcmTokenState extends Equatable {
  const UpdateFcmTokenState();
}

class UpdateFcmTokenInitialState extends UpdateFcmTokenState {
  @override
  List<Object> get props => [];
}

class UpdateFcmTokenLoadingState extends UpdateFcmTokenState {
  @override
  List<Object> get props => [];
}

class UpdateFcmTokenLoadedState extends UpdateFcmTokenState {
  @override
  List<Object> get props => [];
}

class UpdateFcmTokenErrorState extends UpdateFcmTokenState {
  final String error;

  const UpdateFcmTokenErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
