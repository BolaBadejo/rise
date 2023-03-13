import 'dart:convert';

GetAuthUserResponse getAuthUserResponseFromJson(String str) =>
    GetAuthUserResponse.fromJson(json.decode(str));

String getAuthUserResponseToJson(GetAuthUserResponse data) =>
    json.encode(data.toJson());

class GetAuthUserResponse {
  GetAuthUserResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory GetAuthUserResponse.fromJson(Map<String, dynamic> json) =>
      GetAuthUserResponse(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
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
  int? kycId;
  Wallet? wallet;

  Data(
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
      this.kycId,
      this.referralToken,
      this.wallet});

  Data.fromJson(Map<String, dynamic> json) {
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
    kycId = json['kyc_id'];
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
    data['kyc_id'] = this.kycId;
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


// class Data {
//   Data({
//     required this.fullName,
//     required this.phoneNumber,
//     required this.email,
//     required this.userType,
//     required this.emailVerified,
//     required this.kycVerified,
//     required this.riseVerified,
//     required this.riseInsured,
//     required this.joinedSince,
//     this.fcmToken,
//   });

//   String fullName;
//   String phoneNumber;
//   String email;
//   String userType;
//   bool emailVerified;
//   bool kycVerified;
//   bool riseVerified;
//   bool riseInsured;
//   DateTime joinedSince;
//   String? fcmToken;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     fullName: json["full_name"],
//     phoneNumber: json["phone_number"],
//     email: json["email"],
//     userType: json["user_type"],
//     emailVerified: json["email_verified"],
//     kycVerified: json["kyc_verified"],
//     riseVerified: json["rise_verified"],
//     riseInsured: json["rise_insured"],
//     joinedSince: DateTime.parse(json["joined_since"]),
//     fcmToken: json["fcm_token"],
//   );

//   Map<String, dynamic> toJson() => {
//     "full_name": fullName,
//     "phone_number": phoneNumber,
//     "email": email,
//     "user_type": userType,
//     "email_verified": emailVerified,
//     "kyc_verified": kycVerified,
//     "rise_verified": riseVerified,
//     "rise_insured": riseInsured,
//     "joined_since": joinedSince.toIso8601String(),
//     "fcm_token": fcmToken ?? " ",
//   };
// }
