import 'dart:convert';

SavePersonalInformationResponse savePersonaInformationResponseFromJson(
        String str) =>
    SavePersonalInformationResponse.fromJson(json.decode(str));

String savePersonaInformationResponseToJson(
        SavePersonalInformationResponse data) =>
    json.encode(data.toJson());

class SavePersonalInformationResponse {
  SavePersonalInformationResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory SavePersonalInformationResponse.fromJson(Map<String, dynamic> json) =>
      SavePersonalInformationResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
