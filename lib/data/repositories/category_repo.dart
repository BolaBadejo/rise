import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/category/category_reposne_model.dart';

class CategoryRepository {
  final ApiProvider _provider = ApiProvider();

  Future<CategoryResponse> fetchCategoryData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.getCategory("/listing/category/all",getToken);
    final responseBody = json.decode(response);
    final categoryData = CategoryResponse.fromJson(responseBody);
    return categoryData;
  }
}