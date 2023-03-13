import 'dart:convert';

IdentityDocumentResponse identityDocumentResponseFromJson(String str) => IdentityDocumentResponse.fromJson(json.decode(str));

String identityDocumentResponseToJson(IdentityDocumentResponse data) => json.encode(data.toJson());

class IdentityDocumentResponse {
  IdentityDocumentResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory IdentityDocumentResponse.fromJson(Map<String, dynamic> json) => IdentityDocumentResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
