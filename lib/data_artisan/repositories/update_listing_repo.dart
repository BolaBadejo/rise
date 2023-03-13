import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/update_listing/update_listing_response_model.dart';

class UpdateListingRepository {
  final ApiProvider _provider = ApiProvider();

  Future<UpdateListingResponse> fetchUpdateListingData(
      File? imageFile,
      String category,
      String serviceOffering,
      String serviceTitle,
      String serviceDescription,
      String amount,
      List serviceTags,
      String id) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.updateListing(
        "/listing/update/$id",
        getToken,
        imageFile,
        category,
        serviceOffering,
        serviceTitle,
        serviceDescription,
        amount,
        serviceTags);
    final responseBody = json.decode(response);
    final updateListingData = UpdateListingResponse.fromJson(responseBody);
    return updateListingData;
  }
}
