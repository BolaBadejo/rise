import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/logout/logout_response_model.dart';

class LogOutRepository {
  final ApiProvider _provider = ApiProvider();

  Future<LogOutResponse> fetchLogOutData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.logOut("/logout", getToken);
    final responseBody = json.decode(response);
    final logOutData = LogOutResponse.fromJson(responseBody);
    return logOutData;
  }

}