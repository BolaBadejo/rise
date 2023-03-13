import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/register_new_user/register_new_user_response_model.dart';
import '../../../data_artisan/repositories/register_new_user_repo.dart';

part 'register_new_user_event.dart';

part 'register_new_user_state.dart';

class RegisterNewUserBloc
    extends Bloc<RegisterNewUserEvent, RegisterNewUserState> {
  final RegisterNewUserRepository registerNewUserRepository;

  RegisterNewUserBloc(this.registerNewUserRepository)
      : super(RegisterNewUserInitialState()) {
    on<RegisterNewUserEvent>((event, emit) async {
      if (event is LoadRegisterNewUserEvent) {
        emit(RegisterNewUserLoadingState());
        try {
          final registerNewUserResponse = await registerNewUserRepository
              .fetchRegisterNewUseData(event.requestBody);
          emit(RegisterNewUserLoadedState(
              registerNewUserResponse: registerNewUserResponse));
        } catch (e) {
          emit(RegisterNewUserErrorState(error: e.toString()));
        }
      }
    });
  }
}
