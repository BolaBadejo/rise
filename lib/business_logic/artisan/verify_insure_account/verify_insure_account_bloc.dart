import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/verify_insure_account/verify_insure_account_response_model.dart';
import '../../../data_artisan/repositories/verify_insure_account_repo.dart';

part 'verify_insure_account_event.dart';
part 'verify_insure_account_state.dart';

class VerifyInsureAccountBloc
    extends Bloc<VerifyInsureAccountEvent, VerifyInsureAccountState> {
  final VerifyInsureAccountRepository verifyInsureAccountRepository;

  VerifyInsureAccountBloc(this.verifyInsureAccountRepository)
      : super(VerifyInsureAccountInitialState()) {
    on<VerifyInsureAccountEvent>((event, emit) async {
      if (event is LoadVerifyInsureAccountEvent) {
        emit(VerifyInsureAccountLoadingState());
        try {
          final verifyInsureAccountResponse =
              await verifyInsureAccountRepository
                  .fetchVerifyInsureAccountData(event.requestBody);
          emit(VerifyInsureAccountLoadedState(
              verifyInsureAccountResponse: verifyInsureAccountResponse));
        } catch (e) {
          emit(VerifyInsureAccountErrorState(error: e.toString()));
        }
      }
    });
  }
}
