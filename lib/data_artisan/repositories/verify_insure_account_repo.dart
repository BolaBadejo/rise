import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/verify_insure_account/verify_insure_account_request_model.dart';
import '../model/verify_insure_account/verify_insure_account_response_model.dart';

class VerifyInsureAccountRepository {
  final ApiProvider _provider = ApiProvider();

  Future<VerifyInsureAccountResponse> fetchVerifyInsureAccountData(
      VerifyInsureAccountRequest verifyInsureAccountRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.verifyInsureAccount(
        "/user/verification", verifyInsureAccountRequest, getToken);
    final responseBody = json.decode(response);
    final verifyInsureAccountData =
        VerifyInsureAccountResponse.fromJson(responseBody);
    return verifyInsureAccountData;
  }
}
