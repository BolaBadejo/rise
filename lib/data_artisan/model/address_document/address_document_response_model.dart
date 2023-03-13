import 'dart:convert';

AddressDocumentResponse addressDocumentResponseFromJson(String str) =>
    AddressDocumentResponse.fromJson(json.decode(str));

String addressDocumentResponseToJson(AddressDocumentResponse data) =>
    json.encode(data.toJson());

class AddressDocumentResponse {
  AddressDocumentResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory AddressDocumentResponse.fromJson(Map<String, dynamic> json) =>
      AddressDocumentResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
