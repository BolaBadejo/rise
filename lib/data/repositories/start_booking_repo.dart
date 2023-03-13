import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/start_booking/start_booking_request_model.dart';
import '../model/start_booking/start_booking_response_model.dart';

class StartBookingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<StartBookingResponse> fetchStartBookingData(StartBookingRequest createBookingRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.createStartBookingRequest("/booking/start-booking",createBookingRequest,getToken);
    final responseBody = json.decode(response);
    final startBookingData = StartBookingResponse.fromJson(responseBody);
    return startBookingData;
  }
}