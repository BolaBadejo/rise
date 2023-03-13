import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/login/login_request_model.dart';
import '../model/login/login_response_model.dart';

class LoginRepository {
  final ApiProvider _provider = ApiProvider();

  Future<LoginResponse> fetchLoginData(LoginRequest loginRequest) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response =
        await _provider.postLoginRequest("/auth/login", loginRequest);
    final responseBody = json.decode(response);
    final loginData = LoginResponse.fromJson(responseBody);
    sharedPreferences.setString('access_token', loginData.data.accessToken);
    sharedPreferences.setString('expires_in', loginData.data.expiresIn);
    return loginData;
  }
}
