import 'dart:convert';

LoginResponse loginResponseModelFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  bool? success;
  String? message;
  Data? data;

  LoginResponse({this.success, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? accessToken;
  String? expiresIn;
  User? user;
  Kyc? kyc;

  Data({this.accessToken, this.expiresIn, this.user, this.kyc});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    kyc = json['kyc'] != null ? new Kyc.fromJson(json['kyc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.kyc != null) {
      data['kyc'] = this.kyc!.toJson();
    }
    return data;
  }
}

class User {
  String? fullName;
  String? phoneNumber;
  String? email;
  String? userType;
  late bool emailVerified;
  late bool kycVerified;
  late bool riseVerified;
  late bool riseInsured;
  String? joinedSince;
  String? fcmToken;
  String? referralToken;
  Wallet? wallet;

  User(
      {this.fullName,
      this.phoneNumber,
      this.email,
      this.userType,
      required this.emailVerified,
      required this.kycVerified,
      required this.riseVerified,
      required this.riseInsured,
      this.joinedSince,
      this.fcmToken,
      this.referralToken,
      this.wallet});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    userType = json['user_type'];
    emailVerified = json['email_verified'];
    kycVerified = json['kyc_verified'];
    riseVerified = json['rise_verified'];
    riseInsured = json['rise_insured'];
    joinedSince = json['joined_since'];
    fcmToken = json['fcm_token'];
    referralToken = json['referral_token'];
    wallet =
        json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    data['email_verified'] = this.emailVerified;
    data['kyc_verified'] = this.kycVerified;
    data['rise_verified'] = this.riseVerified;
    data['rise_insured'] = this.riseInsured;
    data['joined_since'] = this.joinedSince;
    data['fcm_token'] = this.fcmToken;
    data['referral_token'] = this.referralToken;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    return data;
  }
}

class Wallet {
  String? id;
  int? userId;
  String? accountNumber;
  int? balance;
  int? ledgerBalance;
  String? status;
  String? failedWithdrawalAttempt;
  String? createdAt;
  String? updatedAt;

  Wallet(
      {this.id,
      this.userId,
      this.accountNumber,
      this.balance,
      this.ledgerBalance,
      this.status,
      this.failedWithdrawalAttempt,
      this.createdAt,
      this.updatedAt});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    accountNumber = json['account_number'];
    balance = json['balance'];
    ledgerBalance = json['ledger_balance'];
    status = json['status'];
    failedWithdrawalAttempt = json['failed_withdrawal_attempt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['account_number'] = this.accountNumber;
    data['balance'] = this.balance;
    data['ledger_balance'] = this.ledgerBalance;
    data['status'] = this.status;
    data['failed_withdrawal_attempt'] = this.failedWithdrawalAttempt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Kyc {
  bool? personalInfo;
  bool? passportPhoto;
  bool? identityInfo;
  bool? identitySnapshot;
  bool? addressSnapshot;

  Kyc(
      {this.personalInfo,
      this.passportPhoto,
      this.identityInfo,
      this.identitySnapshot,
      this.addressSnapshot});

  Kyc.fromJson(Map<String, dynamic> json) {
    personalInfo = json['personal_info'];
    passportPhoto = json['passport_photo'];
    identityInfo = json['identity_info'];
    identitySnapshot = json['identity_snapshot'];
    addressSnapshot = json['address_snapshot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personal_info'] = this.personalInfo;
    data['passport_photo'] = this.passportPhoto;
    data['identity_info'] = this.identityInfo;
    data['identity_snapshot'] = this.identitySnapshot;
    data['address_snapshot'] = this.addressSnapshot;
    return data;
  }
}
