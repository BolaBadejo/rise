part of 'get_auth_user_bloc.dart';

abstract class GetAuthUserEvent extends Equatable {
  const GetAuthUserEvent();
}

class LoadGetAuthUserEvent extends GetAuthUserEvent {
  @override
  List<Object> get props => [];
}

class RefreshGetAuthUserEvent extends GetAuthUserEvent {
  @override
  List<Object> get props => [];
}
