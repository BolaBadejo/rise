import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/find_listing/find_listing_model.dart';

class FindListingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<FindListingResponse> fetchFindListingData(String id) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.getListing("/listing/find/$id", getToken);
    final responseBody = json.decode(response);
    final findListingData = FindListingResponse.fromJson(responseBody);
    return findListingData;
  }
}
