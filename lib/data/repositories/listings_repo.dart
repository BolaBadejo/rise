import 'dart:convert';

import 'package:rise/data/model/listings/listings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/address_document/address_document_response_model.dart';

class ListingsRepo {
  final ApiProvider _provider = ApiProvider();

  Future<ListingsModel> fetchListingsList() async {
    return _provider.fetchListings();
  }
}

class NetworkError extends Error {}
