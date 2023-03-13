import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/passport_photograph/passport_photograph_response_model.dart';

class PassportPhotographRepository {
  final ApiProvider _provider = ApiProvider();

  Future<PassportPhotographResponse> fetchPassportPhotographData(String filePath) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.uploadPassportPhotograph("/kyc/upload-photo-snapshot",filePath,getToken);
    final responseBody = json.decode(response.toString());
    final passportPhotographResponseData = PassportPhotographResponse.fromJson(responseBody);
    return passportPhotographResponseData;
  }
}