import 'dart:convert';

import 'package:rise/data/model/generate_otp/generate_otp_request_model.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/generate_otp/generate_otp_response_model.dart';

class GenerateOtpRepository {
  final ApiProvider _provider = ApiProvider();

  Future<GenerateOtpResponse> fetchGeneratedOtpData(GenerateOtpRequest generateOtpRequest) async {
    final response = await _provider.postLoginRequest("/auth/generate-otp", generateOtpRequest);
    final responseBody = json.decode(response);
    final generatedOtpData = GenerateOtpResponse.fromJson(responseBody);
    return generatedOtpData;
  }
}