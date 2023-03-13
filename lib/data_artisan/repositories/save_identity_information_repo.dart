import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/save_identity_information/save_idnentity_information_request_model.dart';
import '../model/save_identity_information/save_idnentity_information_response_model.dart';

class SaveIdentityInformationRepository {
  final ApiProvider _provider = ApiProvider();

  Future<SaveIdentityInformationResponse> fetchSaveIdentityInformationData(
      SaveIdentityInformationRequest saveIdentityInformationRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.postSaveIdentityInformationRequest(
        "/kyc/save-identity-info", saveIdentityInformationRequest, getToken);
    final responseBody = json.decode(response);
    final saveIdentityInformationData =
        SaveIdentityInformationResponse.fromJson(responseBody);
    return saveIdentityInformationData;
  }
}
