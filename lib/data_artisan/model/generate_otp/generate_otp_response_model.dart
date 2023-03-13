import 'dart:convert';

GenerateOtpResponse generateOtpResponseFromJson(String str) =>
    GenerateOtpResponse.fromJson(json.decode(str));

String generateOtpResponseToJson(GenerateOtpResponse data) =>
    json.encode(data.toJson());

class GenerateOtpResponse {
  GenerateOtpResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory GenerateOtpResponse.fromJson(Map<String, dynamic> json) =>
      GenerateOtpResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
