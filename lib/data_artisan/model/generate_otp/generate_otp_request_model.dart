import 'dart:convert';

GenerateOtpRequest loginRequestModelFromJson(String str) =>
    GenerateOtpRequest.fromJson(json.decode(str));

String loginRequestModelToJson(GenerateOtpRequest data) =>
    json.encode(data.toJson());

class GenerateOtpRequest {
  GenerateOtpRequest({
    this.phoneNumber,
  });

  String? phoneNumber;

  factory GenerateOtpRequest.fromJson(Map<String, dynamic> json) =>
      GenerateOtpRequest(
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": "234${phoneNumber!.substring(1)}",
      };
}
