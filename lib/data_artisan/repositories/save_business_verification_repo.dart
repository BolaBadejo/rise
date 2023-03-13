import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/save_business_verification/save_business_verification_reponse_model.dart';

class SaveBusinessVerificationRepository {
  final ApiProvider _provider = ApiProvider();

  Future<SaveBusinessVerificationResponse> fetchSaveBusinessVerificationData(
      String filePath,
      String isBusinessRegistered,
      String belongToUnion,
      String hasPhysicalStore,
      String businessAddress) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.saveBusinessVerification(
        "/kyc/save-business-verification",
        filePath,
        getToken,
        isBusinessRegistered,
        belongToUnion,
        hasPhysicalStore,
        businessAddress);
    final responseBody = json.decode(response.toString());
    final saveBusinessVerificationData =
        SaveBusinessVerificationResponse.fromJson(responseBody);
    return saveBusinessVerificationData;
  }
}
