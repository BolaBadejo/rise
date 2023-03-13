import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/address_document/address_document_response_model.dart';

class AddressDocumentRepository {
  final ApiProvider _provider = ApiProvider();

  Future<AddressDocumentResponse> fetchAddressDocumentData(
      String filePath) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.uploadAddressDocument(
        "/kyc/upload-address-snapshot", filePath, getToken);
    final responseBody = json.decode(response.toString());
    final addressDocumentResponseData =
        AddressDocumentResponse.fromJson(responseBody);
    return addressDocumentResponseData;
  }
}
