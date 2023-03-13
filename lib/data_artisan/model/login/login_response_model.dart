import 'dart:convert';

LoginResponse loginResponseModelFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
    required this.accessToken,
    required this.expiresIn,
    required this.user,
    required this.kyc,
  });

  String accessToken;
  String expiresIn;
  User user;
  Kyc kyc;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        user: User.fromJson(json["user"]),
        kyc: Kyc.fromJson(json["kyc"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_in": expiresIn,
        "user": user.toJson(),
        "kyc": kyc.toJson(),
      };
}

class Kyc {
  Kyc({
    this.personalInfo,
    this.passportPhoto,
    this.identityInfo,
    this.identitySnapshot,
    this.addressSnapshot,
    this.bankInfo,
    this.businessVerification,
  });

  bool? personalInfo;
  bool? passportPhoto;
  bool? identityInfo;
  bool? identitySnapshot;
  bool? addressSnapshot;
  bool? bankInfo;
  bool? businessVerification;

  factory Kyc.fromJson(Map<String, dynamic> json) => Kyc(
        personalInfo: json["personal_info"],
        passportPhoto: json["passport_photo"],
        identityInfo: json["identity_info"],
        identitySnapshot: json["identity_snapshot"],
        addressSnapshot: json["address_snapshot"],
        bankInfo: json["bank_info"],
        businessVerification: json["business_verification"],
      );

  Map<String, dynamic> toJson() => {
        "personal_info": personalInfo,
        "passport_photo": passportPhoto,
        "identity_info": identityInfo,
        "identity_snapshot": identitySnapshot,
        "address_snapshot": addressSnapshot,
        "bank_info": bankInfo,
        "business_verification": businessVerification,
      };
}

class User {
  User({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.userType,
    this.emailVerified,
    this.kycVerified,
    this.riseVerified,
    this.riseInsured,
    this.joinedSince,
    this.fcmToken,
  });

  String? fullName;
  String? phoneNumber;
  String? email;
  String? userType;
  bool? emailVerified;
  bool? kycVerified;
  bool? riseVerified;
  bool? riseInsured;
  DateTime? joinedSince;
  String? fcmToken;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        "joined_since": joinedSince?.toIso8601String(),
        "fcm_token": fcmToken,
      };
}
