import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/save_personal_information/save_personal_information_request_model.dart';
import '../model/save_personal_information/save_personal_information_response_model.dart';

class SavePersonalInformationRepository {
  final ApiProvider _provider = ApiProvider();

  Future<SavePersonalInformationResponse> fetchSavePersonalInformationData(
      SavePersonalInformationRequest savePersonalInformationRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.postSavePersonalInformationRequest(
        "/kyc/save-personal-info", savePersonalInformationRequest, getToken);
    final responseBody = json.decode(response);
    final savePersonalInformationData =
        SavePersonalInformationResponse.fromJson(responseBody);
    return savePersonalInformationData;
  }
}
