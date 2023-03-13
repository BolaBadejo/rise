import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/booking/booking_reponse_model.dart';

class BookingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<BookingResponse> fetchBookingData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.getBooking(
        "/booking/vendor/current?count=true", getToken);
    final responseBody = json.decode(response);
    final bookingData = BookingResponse.fromJson(responseBody);
    return bookingData;
  }
}
