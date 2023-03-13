import 'dart:convert';

import 'package:rise/data_artisan/model/accept_booking/accept_booking_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/accept_booking/accept_booking_response_model.dart';

class AcceptBookingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<AcceptBookingResponse> fetchAcceptBookingData(
      AcceptBookingRequest acceptBookingRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.acceptBookingRequest(
        "/booking/accept-booking", acceptBookingRequest, getToken);
    final responseBody = json.decode(response);
    final acceptBookingData = AcceptBookingResponse.fromJson(responseBody);
    return acceptBookingData;
  }
}
