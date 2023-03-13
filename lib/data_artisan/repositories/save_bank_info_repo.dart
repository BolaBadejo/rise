import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/save_bank_info/save_bank_information_request_model.dart';
import '../model/save_bank_info/save_bank_information_response_model.dart';

class SaveBankInformationRepository {
  final ApiProvider _provider = ApiProvider();

  Future<SaveBankInformationResponse> fetchSaveBankInformationData(
      SaveBankInformationRequest saveBankInformationRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.saveBankInformation(
        "/kyc/save-bank-info", getToken, saveBankInformationRequest);
    final responseBody = json.decode(response);
    final saveBankInformationData =
        SaveBankInformationResponse.fromJson(responseBody);
    return saveBankInformationData;
  }
}
