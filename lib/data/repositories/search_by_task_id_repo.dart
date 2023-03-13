import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/search_by_task_id/search_by_task_id_response_model.dart';

class SearchByTaskIdRepository {
  final ApiProvider _provider = ApiProvider();

  Future<SearchByTaskIdResponse> fetchSearchByTaskIdData(String taskId) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.findByTaskId("/booking/search?taskId=$taskId",getToken);
    final responseBody = json.decode(response);
    final searchByTaskIdData = SearchByTaskIdResponse.fromJson(responseBody);
    return searchByTaskIdData;
  }
}