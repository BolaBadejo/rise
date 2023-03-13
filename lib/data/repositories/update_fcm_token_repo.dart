import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';

class UpdateFcmTokenRepository {
  final ApiProvider _provider = ApiProvider();

  Future fetchUpdateFcmTokenData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.updateFCMToken("/update-fcm-token", getToken);
    final responseBody = json.decode(response);
    return responseBody;
  }
}
