import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/get_auth_user/get_auth_user_response_model.dart';
import '../../../data_artisan/repositories/get_auth_user_repo.dart';

part 'get_auth_user_event.dart';
part 'get_auth_user_state.dart';

class GetAuthUserBloc extends Bloc<GetAuthUserEvent, GetAuthUserState> {
  final GetAuthUserRepository getAuthUserRepository;
  GetAuthUserBloc(this.getAuthUserRepository)
      : super(GetAuthUserInitialState()) {
    on<GetAuthUserEvent>((event, emit) async {
      if (event is LoadGetAuthUserEvent) {
        emit(GetAuthUserLoadingState());
        try {
          final getAuthUserResponse =
              await getAuthUserRepository.fetchGetAuthUserData();
          emit(
              GetAuthUserLoadedState(getAuthUserResponse: getAuthUserResponse));
        } catch (e) {
          emit(GetAuthUserErrorState(error: e.toString()));
        }
      }
    });
  }
}
