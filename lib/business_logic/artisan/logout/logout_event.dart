part of 'logout_bloc.dart';

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();
}

class LoadLogoutEvent extends LogoutEvent {
  @override
  List<Object> get props => [];
}
