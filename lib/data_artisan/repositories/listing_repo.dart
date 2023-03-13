import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/lisiting/listingResponseModel.dart';

class ListingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<ListingResponseModel> fetchListingData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response =
        await _provider.getListing("/listing/all?limit=5&page=1", getToken);
    final responseBody = json.decode(response);
    final listingData = ListingResponseModel.fromJson(responseBody);
    return listingData;
  }
}
