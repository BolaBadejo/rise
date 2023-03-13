import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/identity_document/identity_document_response_model.dart';
import '../../data/repositories/identity_document_repo.dart';

part 'identity_document_event.dart';

part 'identity_document_state.dart';

class IdentityDocumentBloc
    extends Bloc<IdentityDocumentEvent, IdentityDocumentState> {
  final IdentityDocumentRepository identityDocumentRepository;

  IdentityDocumentBloc(this.identityDocumentRepository)
      : super(IdentityDocumentInitialState()) {
    on<IdentityDocumentEvent>((event, emit) async {
      if (event is LoadIdentityDocumentEvent) {
        emit(IdentityDocumentLoadingState());
        try {
          final identityDocumentResponse = await identityDocumentRepository
              .fetchIdentityDocumentData(event.filePath);
          emit(IdentityDocumentLoadedState(
              identityDocumentResponse: identityDocumentResponse));
        } catch (e) {
          emit(IdentityDocumentErrorState(error: e.toString()));
        }
      }
    });
  }
}
