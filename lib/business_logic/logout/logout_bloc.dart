import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rise/data/model/logout/logout_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/log_out_repo.dart';

part 'logout_event.dart';

part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogOutRepository logoutRepository;

  LogoutBloc(this.logoutRepository) : super(LogoutInitialState()) {
    on<LogoutEvent>((event, emit) async {
      if (event is LoadLogoutEvent) {
        emit(LogoutLoadingState());
        try {
          final logOutResponse = await logoutRepository.fetchLogOutData();
          SharedPreferences sharedPreference = await SharedPreferences.getInstance();
          sharedPreference.clear();
          emit(LogoutLoadedState(logOutResponse: logOutResponse));
        } catch (e) {
          emit(LogoutErrorState(error: e.toString()));
        }
      }
    });
  }
}
