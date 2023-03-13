import 'dart:convert';

import 'package:rise/data/model/verify_otp/verify_otp_request_model.dart';
import 'package:rise/data/model/verify_otp/verify_otp_response_model.dart';

import '../dataproviders/api/api_provider.dart';

class VerifyOtpRepository {
  final ApiProvider _provider = ApiProvider();

  Future<VerifyOtpResponse> fetchVerifyOtpData(VerifyOtpRequest verifyOtpRequest) async {
    final response = await _provider.postVerifyOtpRequest("/auth/verify-otp", verifyOtpRequest);
    final responseBody = json.decode(response);
    final verifyOtpData = VerifyOtpResponse.fromJson(responseBody);
    return verifyOtpData;
  }
}