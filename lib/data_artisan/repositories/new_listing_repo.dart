import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/new_listing/new_listing_response_model.dart';

class NewListingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<NewListingResponse> fetchNewListingData(
      List<XFile>? imageFileList,
      String category,
      String serviceOffering,
      String serviceTitle,
      String serviceDescription,
      String amount,
      List serviceTags) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.newListing(
        "/listing/new",
        getToken,
        imageFileList,
        category,
        serviceOffering,
        serviceTitle,
        serviceDescription,
        amount,
        serviceTags);
    final responseBody = json.decode(response);
    final newListingData = NewListingResponse.fromJson(responseBody);
    return newListingData;
  }
}
