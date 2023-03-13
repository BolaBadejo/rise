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
  Data({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.userType,
    required this.emailVerified,
    required this.kycVerified,
    required this.riseVerified,
    required this.riseInsured,
    required this.joinedSince,
    required this.fcmToken,
  });

  String fullName;
  String phoneNumber;
  String email;
  String userType;
  bool emailVerified;
  bool kycVerified;
  bool riseVerified;
  bool riseInsured;
  DateTime joinedSince;
  String fcmToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        userType: json["user_type"],
        emailVerified: json["email_verified"],
        kycVerified: json["kyc_verified"],
        riseVerified: json["rise_verified"],
        riseInsured: json["rise_insured"],
        joinedSince: DateTime.parse(json["joined_since"]),
        fcmToken: json["fcm_token"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "phone_number": phoneNumber,
        "email": email,
        "user_type": userType,
        "email_verified": emailVerified,
        "kyc_verified": kycVerified,
        "rise_verified": riseVerified,
        "rise_insured": riseInsured,
        "joined_since": joinedSince.toIso8601String(),
        "fcm_token": fcmToken,
      };
}
