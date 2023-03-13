import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rise/pages/artisan/home_artisan/home_nav_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/booking/booking_reponse_model.dart';
import '../data/model/get_auth_user/get_auth_user_response_model.dart';
import '../data/model/listings/listings_model.dart';
import '../data/model/login/login_response_model.dart';
import '../data_artisan/dataproviders/api/custom_exception.dart';
import '../pages/user/home/home_nav_screen.dart';
import '../pages/vendor/home_vendor/home_nav_screen.dart';
import '../utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_snack_bar.dart';
import 'package:http/http.dart';
//
// import 'package:http/http.dart';
// import 'package:rise/constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:rise/data/model/generate_otp/generate_otp_response_model.dart';
// import 'package:rise/data/model/listings/listings_model.dart';
// import 'package:rise/data/model/login/login_response_model.dart';
// import 'package:rise/data/model/logout/logout_response_model.dart';
// import 'package:rise/data_artisan/model/register_new_user/register_new_user_response_model.dart';

class APIHandler {
  final String baseUrl = "https://test.rise.ng/api/";

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

  Future<void> logIn(context, email, password) async {
    try {
      Response response = await post(
          Uri.parse("https://test.rise.ng/api/auth/login"),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        await Preferences.saveUserData(data['data']['user']);
        showCustomSnackBar(
            context, data['message'], Colors.green, Colors.white);
        if (data['data']['user']['user_type'] == 'Artisan' ||
            data['data']['user']['user_type'] == 'artisan') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeNavScreenArtisan()));
        } else if (data['data']['user']['user_type'] == 'Vendor' ||
            data['data']['user']['user_type'] == 'vendor') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeNavScreenVendor()));
        } else if (data['data']['user']['user_type'] == 'Default' ||
            data['data']['user']['user_type'] == 'default') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeNavScreen()));
        } else {
          showCustomSnackBar(
              context, 'User type not defined', Colors.red, Colors.white);
        }

        // print(data['data']['user']);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
        EasyLoading.dismiss();
        showCustomSnackBar(context, 'error ${response.statusCode.toString()}',
            Colors.red, Colors.white);
      }
    } catch (e) {
      // print(e.toString());
      EasyLoading.dismiss();
      showCustomSnackBar(context, e.toString(), Colors.red, Colors.white);
    }
  }

  static Future<List<DataModel>> fetchListings(
      getLatitude, getLongitude, distance, ignore) async {
    var val = "data";
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    var response = await http.get(
        Uri.parse(
            "https://test.rise.ng/api/listing/fetch/$getLongitude/$getLongitude/$distance/$ignore"),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $getToken'
        });
    var res = jsonDecode(response.body.toString());
    // print("response ${jsonDecode(response.body)}");
    List<dynamic> result = res[val][val];
    List tempList = [];

    for (var v in result) {
      tempList.add(v);
    }

    return DataModel.dataFromSnapshot(tempList);
  }

  Future<ListingsModel> fetchMyListings() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response =
        await get(Uri.parse('https://test.rise.ng/api/listing/all'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $getToken'
    });
    var data = jsonDecode(response.body.toString());
    // userData = data['data']['user'];
    // names = userData!.fullName!.split(' ');
    // print(data);
    var res = jsonDecode(response.body);
    // print("Listings fetched");
    return res;
  }

  Future<BookingResponse> fetchMyBookings() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    final response = await get(
        Uri.parse('https://test.rise.ng/api/booking/current'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $getToken'
        });
    var data = jsonDecode(response.body.toString());
    // userData = data['data']['user'];
    // names = userData!.fullName!.split(' ');
    print(data);
    var res = jsonDecode(response.body);
    print("Bookings fetched");
    return res;
  }

  static Future<List<DataModel>> fetchAllServices(
      getLatitude, getLongitude, distance, ignore) async {
    var val = "data";

    var response =
        await http.get(Uri.parse("https://test.rise.ng/api/services/all"));
    var res = jsonDecode(response.body);
    print("response ${jsonDecode(response.body)}");
    List<dynamic> result = res[val][val];
    List tempList = [];

    for (var v in result) {
      tempList.add(v);
    }

    return DataModel.dataFromSnapshot(tempList);
  }

  Future<GetAuthUserResponse> fetchUserData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    var responseJson;
    try {
      final response =
          await http.get(Uri.parse('https://test.rise.ng/api/user'), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $getToken',
        "Content-Type": "application/json",
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    final responseBody = json.decode(responseJson);
    final getAuthUserData = GetAuthUserResponse.fromJson(responseBody);
    return getAuthUserData;
  }

  //  https://test.rise.ng/api/user
  //
  // Future<RegisterNewUserResponse> registration(fullName, phoneNumber, email,
  //     userType, password, passwordConfirmation) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['full_name'] = fullName;
  //   map['phone_number'] = phoneNumber;
  //   map["user_type"] = userType;
  //   map['email'] = email;
  //   map['password'] = password;
  //   map['password_confirmation'] = passwordConfirmation;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+auth/register"), body: map);
  //   var res = jsonDecode(response.body);
  //   final registeredUser = RegisterNewUserResponse.fromJson(res);
  //   print("response ${jsonDecode(response.body)}");
  //
  //   return registeredUser;
  // }
  //
  // Future<LoginResponse> login(email, password) async {
  //   var map = <String, dynamic>{};
  //   map['email'] = email;
  //   map['password'] = password;
  //
  //   var response = await http.post(Uri.parse("$baseUrl+auth/login"), body: map);
  //   var res = jsonDecode(response.body);
  //   final loginData = LoginResponse.fromJson(res);
  //   print("response ${jsonDecode(response.body)}");
  //
  //   return loginData;
  // }
  //
  // Future<LoginResponse> logIn(email, password) async {
  //   LoginResponse loginData = LoginResponse();
  //   try {
  //     Response response = await post(
  //         Uri.parse("https://test.rise.ng/api/auth/login"),
  //         body: {'email': email, 'password': password});
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body.toString());
  //       loginData = data;
  //       print(data['data']['user']);
  //       print("done successfully");
  //     } else {
  //       print("mission failed");
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //
  //   return loginData;
  // }
  //
  // Future<LogOutResponse> logOut(token) async {
  //   var response = await http.post(Uri.parse("$baseUrl+logout"), headers: {
  //     "Accept": "application/json",
  //     'Authorization': 'Bearer $token'
  //   });
  //   var res = jsonDecode(response.body);
  //   final logOutData = LogOutResponse.fromJson(res);
  //   print("response ${jsonDecode(response.body)}");
  //
  //   return logOutData;
  // }
  //
  // Future<GenerateOtpResponse> generateOTPToken(var phoneNumber) async {
  //   var map = {"phone_number": phoneNumber};
  //   // map['phone_number'] = phoneNumber;
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+auth/generate-otp"), body: map);
  //   var res = json.decode(response.body);
  //   final generatedOTP = GenerateOtpResponse.fromJson(res);
  //   print("response ${jsonDecode(response.body)}");
  //
  //   return generatedOTP;
  // }
  //
  // Future<dynamic> verifyOTP(phoneNumber, otp) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['phone_number'] = phoneNumber;
  //   map["otp"] = otp;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+auth/verify-otp"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> forgotPassword(email) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['email'] = email;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+auth/forgot-password"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> resetPassword(
  //     email, password, passwordConfirmation, token) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['email'] = email;
  //   map['password'] = password;
  //   map['password_confirmation'] = passwordConfirmation;
  //   map['token'] = token;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+auth/reset-password"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> createListing(category, service_offering, service_title,
  //     description, tags, images, minimum_service_offer) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['category'] = category;
  //   map['service_offering'] = service_offering;
  //   map["service_title"] = service_title;
  //   map['description'] = description;
  //   map['tags'] = tags;
  //   map['images'] = images;
  //   map['minimum_service_offer'] = minimum_service_offer;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+listing/new"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> KYCPersonalInfo(first_name, last_name, date_of_birth,
  //     residential_address, city, state, lat, lng) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['first_name'] = first_name;
  //   map['last_name'] = last_name;
  //   map["date_of_birth"] = date_of_birth;
  //   map['residential_address'] = residential_address;
  //   map['city'] = city;
  //   map['state'] = state;
  //   map['lat'] = lat;
  //   map['lng'] = lng;
  //
  //   var response = await http.post(Uri.parse("$baseUrl+kyc/save-personal-info"),
  //       body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> KYCUploadPhotoSnapshot(photo_snapshot) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['photo_snapshot'] = photo_snapshot;
  //
  //   var response = await http
  //       .post(Uri.parse("$baseUrl+kyc/upload-photo-snapshot"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> KYCUploadAddressSnapshot(address_snapshot) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['address_snapshot'] = address_snapshot;
  //
  //   var response = await http
  //       .post(Uri.parse("$baseUrl+kyc/upload-address-snapshot"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> KYCSaveIdentityInfo(
  //     means_of_identity, identity_number) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['means_of_identity'] = means_of_identity;
  //   map['identity_number'] = identity_number;
  //
  //   var response = await http.post(Uri.parse("$baseUrl+kyc/save-identity-info"),
  //       body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> KYCUploadIdentitySnapshot(identity_snapshot) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['identity_snapshot'] = identity_snapshot;
  //
  //   var response = await http
  //       .post(Uri.parse("$baseUrl+kyc/upload-identity-snapshot"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> KYCSaveBankInfo(
  //     bvn, bank, bank_code, account_number, account_name) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['bvn'] = bvn;
  //   map['bank'] = bank;
  //   map["bank_code"] = bank_code;
  //   map['account_number'] = account_number;
  //   map['account_name'] = account_name;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+kyc/save-bank-info"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // Future<dynamic> KYCSaveBusinessVerification(business_registered,
  //     belongs_to_union, has_physical_store, business_address) async {
  //   var val = "data";
  //   var map = <String, dynamic>{};
  //   map['business_registered'] = business_registered;
  //   map['belongs_to_union'] = belongs_to_union;
  //   map["has_physical_store"] = has_physical_store;
  //   map['business_address'] = business_address;
  //
  //   var response = await http
  //       .post(Uri.parse("$baseUrl+/save-business-verification"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return res;
  // }
  //
  // static Future<dynamic> KYCProgress() async {
  //   var val = "data";
  //
  //   var response =
  //       await http.get(Uri.parse("  http:// 178.62.29.92/api/kyc/progress"));
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> initializeTransactionPurchase(
  //     type, amount, walletID, listingID, bookingID, taskID) async {
  //   var val = "data";
  //   var type = "purchase";
  //   var map = <String, dynamic>{};
  //   map['amount'] = amount;
  //   map['listing_ids'] = listingID;
  //   map['task_id'] = taskID;
  //
  //   var response = await http
  //       .post(Uri.parse("$baseUrl+payment/initialize/$type"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> initializeTransactionWalletTopUp(
  //     type, amount, walletID, listingID, bookingID, taskID) async {
  //   var val = "data";
  //   var type = "wallet_funding_type";
  //   var map = <String, dynamic>{};
  //   map['amount'] = amount;
  //   map['walletID'] = walletID;
  //
  //   var response = await http
  //       .post(Uri.parse("$baseUrl+payment/initialize/$type"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // static Future<dynamic> verifyPayment(payment_reference) async {
  //   var val = "data";
  //
  //   var response = await http.get(Uri.parse(
  //       "http:// 178.62.29.92/api/payment/verify/${payment_reference}"));
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // static Future<dynamic> withdrawalPin() async {
  //   var val = "data";
  //
  //   var response = await http
  //       .get(Uri.parse("http:// 178.62.29.92/api/payment/withdrawal-pin"));
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> walletToWalletTransfer(
  //     recipient_account_number, amount, pin, password) async {
  //   var val = "data";
  //   var type = "wallet_funding_type";
  //   var map = <String, dynamic>{};
  //   map['recipient_account_number'] = recipient_account_number;
  //   map['amount'] = amount;
  //   map['pin'] = pin;
  //   map['password'] = password;
  //
  //   var response = await http.post(
  //       Uri.parse("$baseUrl+payment/wallet-to-wallet/transfer"),
  //       body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> walletCashout(kyc_id, amount, pin, password) async {
  //   var val = "data";
  //   var type = "wallet_funding_type";
  //   var map = <String, dynamic>{};
  //   map['kyc_id'] = kyc_id;
  //   map['amount'] = amount;
  //   map['pin'] = pin;
  //   map['password'] = password;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+payment/cashout"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> verifyUserWallet(walletID) async {
  //   var val = "data";
  //   var type = "wallet_funding_type";
  //   var map = <String, dynamic>{};
  //   map['walletId'] = walletID;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+payment/verify_wallet"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> newBooking(listingID, title, description, amount) async {
  //   var val = "data";
  //   var type = "wallet_funding_type";
  //   var map = <String, dynamic>{};
  //   map['listing_id'] = listingID;
  //   map['title'] = title;
  //   map['description'] = description;
  //   map['amount'] = amount;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+booking/new"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> acceptBooking(booking_id, amount) async {
  //   var val = "data";
  //   var type = "wallet_funding_type";
  //   var map = <String, dynamic>{};
  //   map['booking_id'] = booking_id;
  //   map['amount'] = amount;
  //
  //   var response = await http.post(Uri.parse("$baseUrl+booking/accept-booking"),
  //       body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
  //
  // Future<dynamic> updateStatus(status) async {
  //   var val = "data";
  //   var type = "wallet_funding_type";
  //   var map = <String, dynamic>{};
  //   map['status'] = status;
  //
  //   var response =
  //       await http.post(Uri.parse("$baseUrl+booking/update-status"), body: map);
  //   var res = jsonDecode(response.body);
  //   print("response ${jsonDecode(response.body)}");
  //   List<dynamic> result = res[val][val];
  //   List tempList = [];
  //
  //   for (var v in result) {
  //     tempList.add(v);
  //   }
  //
  //   return DataModel.dataFromSnapshot(tempList);
  // }
}
