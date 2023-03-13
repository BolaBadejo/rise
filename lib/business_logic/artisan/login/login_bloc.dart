import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/login/login_response_model.dart';
import '../../../data_artisan/repositories/login_repo.dart';

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
