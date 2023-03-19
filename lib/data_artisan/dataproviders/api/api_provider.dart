import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/save_bank_info/save_bank_information_request_model.dart';
import '../../model/verify_insure_account/verify_insure_account_request_model.dart';
import 'custom_exception.dart';

class ApiProvider {
  final String _baseUrl = "https://admin.rise.ng/api";
  // final String _baseUrl = "https://admin.rise.ng";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postLoginRequest(String url, var requestBody) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson());
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postGenerateOtpRequest(String url, var requestBody) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson());
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postVerifyOtpRequest(String url, var requestBody) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson());
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> logOut(String url, String getToken) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken'
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> updateFCMToken(String url, String getToken) async {
    var responseJson;
    var body = {
      "fcm_token": await FirebaseMessaging.instance.getToken(),
    };
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: body,
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> search(String url, String getToken) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken'
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAuthUser(String url, String getToken) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken'
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getListing(String url, String getToken) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken'
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getCategory(String url, String getToken) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken'
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postSavePersonalInformationRequest(
      String url, var requestBody, String getToken) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson(),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postSaveIdentityInformationRequest(
      String url, var requestBody, String getToken) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson(),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> uploadPassportPhotograph(
      String url, String filePath, String getToken) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll(
          {"Accept": "application/json", 'Authorization': 'Bearer $getToken'});
      request.files
          .add(await http.MultipartFile.fromPath("photo_snapshot", filePath));
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> uploadIdentityDocument(
      String url, String filePath, String getToken) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll(
          {"Accept": "application/json", 'Authorization': 'Bearer $getToken'});
      request.files.add(
          await http.MultipartFile.fromPath("identity_snapshot", filePath));
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> uploadAddressDocument(
      String url, String filePath, String getToken) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll(
          {"Accept": "application/json", 'Authorization': 'Bearer $getToken'});
      request.files
          .add(await http.MultipartFile.fromPath("address_snapshot", filePath));
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postForgotPasswordRequest(String url, var requestBody) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson());
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getBooking(String url, String getToken) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken'
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> findByTaskId(String url, String getToken) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken'
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> saveBusinessVerification(
      String url,
      String filePath,
      String getToken,
      String isBusinessRegistered,
      String belongToUnion,
      String hasPhysicalStore,
      String businessAddress) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll(
          {"Accept": "application/json", 'Authorization': 'Bearer $getToken'});
      request.fields['is_business_registered'] = isBusinessRegistered;
      request.fields['belong_to_union'] = belongToUnion;
      request.fields['has_physical_store'] = hasPhysicalStore;
      request.fields['business_address'] = businessAddress;
      request.files
          .add(await http.MultipartFile.fromPath("address_snapshot", filePath));
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> verifyInsureAccount(String url,
      VerifyInsureAccountRequest requestBody, String getToken) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll(
          {"Accept": "application/json", 'Authorization': 'Bearer $getToken'});
      request.fields['verify_account'] = requestBody.verifyAccount!;
      request.fields['insure_product'] = requestBody.insureProduct!;
      //request.fields['amount'] = requestBody.amount!;
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> saveBankInformation(String url, String getToken,
      SaveBankInformationRequest requestBody) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll(
          {"Accept": "application/json", 'Authorization': 'Bearer $getToken'});
      request.fields['bank'] = requestBody.bank!;
      request.fields['bank_code'] = requestBody.bankCode!;
      request.fields['account_number'] = requestBody.accountNumber!;
      request.fields['account_name'] = requestBody.accountName!;
      request.fields['bvn'] = requestBody.bvn!;
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> newListing(
      String url,
      String getToken,
      List<XFile>? imageFileList,
      String category,
      String serviceOffering,
      String serviceTitle,
      String serviceDescription,
      String amount,
      List serviceTags) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll({
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $getToken'
      });
      var multipartImageFile;
      for (int i = 0; i < imageFileList!.length; i++) {
        File imageFile = File(imageFileList[i].toString());
        String filePath = imageFile.path;
        //request.files.add(await http.MultipartFile.fromPath("images[$i]",filePath));
        multipartImageFile = http.MultipartFile(
            'images[$i]',
            File(imageFileList[i].path).readAsBytes().asStream(),
            File(imageFileList[i].path).lengthSync(),
            filename: basename(imageFileList[i].path));
        request.files.add(multipartImageFile);
      }
      for (int i = 0; i < serviceTags.length; i++) {
        request.fields["tags[$i]"] = serviceTags[i].toString();
      }
      request.fields['category'] = category;
      request.fields['service_offering'] = serviceOffering;
      request.fields['service_title'] = serviceTitle;
      request.fields['description'] = serviceDescription;
      request.fields['minimum_service_offer'] = amount;
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> updateListing(
      String url,
      String getToken,
      File? imageFile,
      String category,
      String serviceOffering,
      String serviceTitle,
      String serviceDescription,
      String amount,
      List serviceTags) async {
    var responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
      request.headers.addAll({
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $getToken'
      });
      var multipartImageFile;
      for (int i = 0; i < serviceTags.length; i++) {
        request.fields["tags[$i]"] = serviceTags[i].toString();
      }
      multipartImageFile = http.MultipartFile(
          'images[0]',
          File(imageFile!.path).readAsBytes().asStream(),
          File(imageFile.path).lengthSync(),
          filename: basename(imageFile.path));
      request.files.add(multipartImageFile);
      request.fields['category'] = category;
      request.fields['service_offering'] = serviceOffering;
      request.fields['service_title'] = serviceTitle;
      request.fields['description'] = serviceDescription;
      request.fields['minimum_service_offer'] = amount;
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> acceptBookingRequest(
      String url, var requestBody, String getToken) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson(),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> createStartBookingRequest(
      String url, var requestBody, String getToken) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson(),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> createUpdateBookingStatusRequest(
      String url, var requestBody, String getToken) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: requestBody.toJson(),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        log(responseJson);
        return responseJson;
      case 201:
        var responseJson = response.body;
        log(responseJson);
        return responseJson;
      case 400:
        log(response.body);
        throw BadRequestException(json.decode(response.body)['message']);
      case 401:
        log(response.body);
        throw UnauthorisedException(json.decode(response.body)['message']);
      case 403:
        log(response.body);
        throw UnauthorisedException(json.decode(response.body)['message']);
      case 422:
        log(response.body);
        throw InvalidInputException(json.decode(response.body)['message']);
      case 500:
        log(response.body);
        throw BadRequestException(json.decode(response.body)['message']);
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
