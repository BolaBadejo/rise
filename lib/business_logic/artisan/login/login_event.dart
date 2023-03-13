part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoadLoginEvent extends LoginEvent {
  final requestBody;

  const LoadLoginEvent({required this.requestBody});

  @override
  List<Object> get props => [requestBody];
}
