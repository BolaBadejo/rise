import 'dart:convert';

SaveBusinessVerificationResponse saveBusinessVerificationResponseFromJson(
        String str) =>
    SaveBusinessVerificationResponse.fromJson(json.decode(str));

String saveBusinessVerificationResponseToJson(
        SaveBusinessVerificationResponse data) =>
    json.encode(data.toJson());

class SaveBusinessVerificationResponse {
  SaveBusinessVerificationResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory SaveBusinessVerificationResponse.fromJson(
          Map<String, dynamic> json) =>
      SaveBusinessVerificationResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
