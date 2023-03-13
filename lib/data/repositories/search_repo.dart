
import 'dart:convert';

import 'package:rise/data/model/search/search_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';

class SearchRepository {
  final ApiProvider _provider = ApiProvider();

  Future<SearchResponse> fetchSearchData(String searchValue, String city, String state) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.search("/search?category=$searchValue&city=$city&state=$state&limit=5",getToken);
    final responseBody = json.decode(response);
    final searchData = SearchResponse.fromJson(responseBody);
    return searchData;
  }
}