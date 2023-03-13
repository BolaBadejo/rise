import 'dart:convert';

import '../dataproviders/api/api_provider.dart';
import '../model/register_new_user/register_new_user_request_model.dart';
import '../model/register_new_user/register_new_user_response_model.dart';

class RegisterNewUserRepository {
  final ApiProvider _provider = ApiProvider();

  Future<RegisterNewUserResponse> fetchRegisterNewUseData(RegisterNewUserRequest registerNewUserRequest) async {
    final response = await _provider.postLoginRequest("/auth/register", registerNewUserRequest);
    final responseBody = json.decode(response);
    final registerNewUserData = RegisterNewUserResponse.fromJson(responseBody);
    return registerNewUserData;
  }
}