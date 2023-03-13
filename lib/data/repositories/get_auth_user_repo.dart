
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/get_auth_user/get_auth_user_response_model.dart';

class GetAuthUserRepository {
  final ApiProvider _provider = ApiProvider();

  Future<GetAuthUserResponse> fetchGetAuthUserData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.getAuthUser("/user", getToken);
    final responseBody = json.decode(response);
    final getAuthUserData = GetAuthUserResponse.fromJson(responseBody);
    return getAuthUserData;
  }
}