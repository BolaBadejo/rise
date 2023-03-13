import 'dart:convert';

SaveBankInformationResponse saveBankInformationResponseFromJson(String str) =>
    SaveBankInformationResponse.fromJson(json.decode(str));

String saveBankInformationResponseToJson(SaveBankInformationResponse data) =>
    json.encode(data.toJson());

class SaveBankInformationResponse {
  SaveBankInformationResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory SaveBankInformationResponse.fromJson(Map<String, dynamic> json) =>
      SaveBankInformationResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
