import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dataproviders/api/api_provider.dart';
import '../model/identity_document/identity_document_response_model.dart';

class IdentityDocumentRepository {
  final ApiProvider _provider = ApiProvider();

  Future<IdentityDocumentResponse> fetchIdentityDocumentData(String filePath) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await _provider.uploadIdentityDocument("/kyc/upload-identity-snapshot",filePath,getToken);
    final responseBody = json.decode(response.toString());
    final identityDocumentResponseData = IdentityDocumentResponse.fromJson(responseBody);
    return identityDocumentResponseData;
  }
}