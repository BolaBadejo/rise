import 'dart:convert';

VerifyOtpRequest verifyOtpRequestFromJson(String str) => VerifyOtpRequest.fromJson(json.decode(str));

String verifyOtpRequestToJson(VerifyOtpRequest data) => json.encode(data.toJson());

class VerifyOtpRequest {
  VerifyOtpRequest({
    this.phoneNumber,
    this.otp,
  });

  String? phoneNumber;
  String? otp;

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => VerifyOtpRequest(
    phoneNumber: json["phone_number"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "phone_number": "234${phoneNumber!.substring(1)}",
    "otp": otp,
  };
}