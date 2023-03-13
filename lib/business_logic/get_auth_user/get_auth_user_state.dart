part of 'get_auth_user_bloc.dart';

abstract class GetAuthUserState extends Equatable {
  const GetAuthUserState();
}

class GetAuthUserInitialState extends GetAuthUserState {
  @override
  List<Object> get props => [];
}

class GetAuthUserLoadingState extends GetAuthUserState {
  @override
  List<Object> get props => [];
}

class GetAuthUserRefreshState extends GetAuthUserState {
  @override
  List<Object> get props => [];
}

class GetAuthUserLoadedState extends GetAuthUserState {
  final GetAuthUserResponse getAuthUserResponse;

  const GetAuthUserLoadedState({required this.getAuthUserResponse});

  @override
  List<Object> get props => [getAuthUserResponse];
}

class GetAuthUserErrorState extends GetAuthUserState {
  final String error;

  const GetAuthUserErrorState({required this.error});

  @override
  List<Object?> get props => [];
}
