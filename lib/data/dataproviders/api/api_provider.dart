import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:rise/data/model/listings/listings_model.dart';

import 'custom_exception.dart';

class ApiProvider {
  // final String _baseUrl = "https://admin.rise.ng/api";
  final String _baseUrl = "https://admin.rise.ng/api";
  final Dio _dio = Dio();

  Future<ListingsModel> fetchListings() async {
    var lat = 6.538200;
    var lng = 3.383590;
    var distance = 1000;
    bool ignore = false;
    var responseJson;

    try {
      final response = await http.get(
          Uri.parse("${_baseUrl}listing/fetch/$lat/$lng/$distance/$ignore"));
      responseJson = _response(response);
      // return ListingsModel.fromJson(response.data);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    // catch (error, stacktrace) {
    //   if (kDebugMode) {
    //     // print("Exception error: $error StackTrace: $stacktrace");
    //   }
    //   return ListingsModel.withError("Data Not found");
    // }
    return responseJson;
  }

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

  Future<dynamic> createBookingRequest(
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
