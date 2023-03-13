import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data_artisan/model/address_document/address_document_response_model.dart';
import '../../../data_artisan/repositories/address_document_Repo.dart';

part 'address_document_event.dart';
part 'address_document_state.dart';

class AddressDocumentBloc
    extends Bloc<AddressDocumentEvent, AddressDocumentState> {
  final AddressDocumentRepository addressDocumentRepository;
  AddressDocumentBloc(this.addressDocumentRepository)
      : super(AddressDocumentInitialState()) {
    on<AddressDocumentEvent>((event, emit) async {
      if (event is LoadAddressDocumentEvent) {
        emit(AddressDocumentLoadingState());
        try {
          final addressDocumentResponse = await addressDocumentRepository
              .fetchAddressDocumentData(event.filePath);
          emit(AddressDocumentLoadedState(
              addressDocumentResponse: addressDocumentResponse));
        } catch (e) {
          emit(AddressDocumentErrorState(error: e.toString()));
        }
      }
    });
  }
}
