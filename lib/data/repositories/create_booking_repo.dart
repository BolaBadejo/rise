import 'dart:convert';

import 'package:rise/data/model/create_booking/create_booking_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/create_booking/create_booking_response_model.dart';

class CreateBookingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<CreateBookingResponse> fetchCreateBookingData(CreateBookingRequest createBookingRequest) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.createBookingRequest("/booking/new",createBookingRequest,getToken);
    final responseBody = json.decode(response);
    final createBookingData = CreateBookingResponse.fromJson(responseBody);
    return createBookingData;
  }
}