import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/update_booking_status/update_booking_status_request_model.dart';
import '../model/update_booking_status/update_booking_status_response_model.dart';

class UpdateBookingStatusRepository {
  final ApiProvider _provider = ApiProvider();

  Future<UpdateBookingStatusResponse> fetchUpdateBookingStatusData(UpdateBookingStatusRequest createBookingRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.createUpdateBookingStatusRequest("/booking/update-status",createBookingRequest,getToken);
    final responseBody = json.decode(response);
    final updateBookingStatusData = UpdateBookingStatusResponse.fromJson(responseBody);
    return updateBookingStatusData;
  }
}