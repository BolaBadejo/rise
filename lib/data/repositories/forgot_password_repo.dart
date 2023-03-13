import 'dart:convert';

import '../dataproviders/api/api_provider.dart';
import '../model/forgot_password/forgot_password_request_model.dart';
import '../model/forgot_password/forgot_password_response_model.dart';

class ForgotPasswordRepository {
  final ApiProvider _provider = ApiProvider();

  Future<ForgotPasswordResponse> fetchForgotPasswordData(ForgotPasswordRequest loginRequest) async {
    final response = await _provider.postLoginRequest("/auth/forgot-password", loginRequest);
    final responseBody = json.decode(response);
    final forgotPasswordData = ForgotPasswordResponse.fromJson(responseBody);
    return forgotPasswordData;
  }
}