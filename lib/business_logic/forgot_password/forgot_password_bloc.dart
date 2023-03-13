import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/forgot_password/forgot_password_request_model.dart';
import '../../data/repositories/forgot_password_repo.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository forgotPasswordRepository;

  ForgotPasswordBloc(this.forgotPasswordRepository)
      : super(ForgotPasswordInitialState()) {
    on<ForgotPasswordEvent>((event, emit) async {
      if (event is LoadForgotPasswordEvent) {
        emit(ForgotPasswordLoadingState());
        try {
          final forgotPasswordResponse = await forgotPasswordRepository
              .fetchForgotPasswordData(event.requestBody);
          emit(ForgotPasswordLoadedState(
              forgotPasswordResponse: forgotPasswordResponse));
        } catch (e) {
          emit(ForgotPasswordErrorState(error: e.toString()));
        }
      }
    });
  }
}
