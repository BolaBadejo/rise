import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data/repositories/login_repo.dart';

import '../../data/model/login/login_response_model.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc(this.loginRepository) : super(LoginInitialState()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoadLoginEvent) {
        emit(LoginLoadingState());
        try {
           final loginResponse =
              await loginRepository.fetchLoginData(event.requestBody);
          emit(LoginLoadedState(loginResponse: loginResponse));
        } catch (e) {
          emit(LoginErrorState(error: e.toString()));
        }
      }
    });
  }
}
