import 'dart:convert';
import 'package:rise/data/dataproviders/api/api_provider.dart';
import 'package:rise/data/model/login/login_request_model.dart';
import 'package:rise/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login/login_response_model.dart';

class LoginRepository {
  final ApiProvider _provider = ApiProvider();

  Future<LoginResponse> fetchLoginData(LoginRequest loginRequest) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response =
        await _provider.postLoginRequest("/auth/login", loginRequest);
    final responseBody = json.decode(response);
    final loginData = LoginResponse.fromJson(responseBody);
    sharedPreferences.setString('access_token', loginData.data!.accessToken!);
    sharedPreferences.setString('expires_in', loginData.data!.expiresIn!);
    await Preferences.saveUserData(loginData.data!.user!);
    // print("testing if this shit works ${loginData.data!.user!.email}");
    return loginData;
  }
}
