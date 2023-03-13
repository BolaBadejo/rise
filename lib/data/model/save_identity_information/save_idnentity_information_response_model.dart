import 'dart:convert';

SaveIdentityInformationResponse saveIdentityInformationResponseFromJson(String str) => SaveIdentityInformationResponse.fromJson(json.decode(str));

String saveIdentityInformationResponseFromJsonToJson(SaveIdentityInformationResponse data) => json.encode(data.toJson());

class SaveIdentityInformationResponse {
  SaveIdentityInformationResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory SaveIdentityInformationResponse.fromJson(Map<String, dynamic> json) => SaveIdentityInformationResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
