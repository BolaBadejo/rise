import 'dart:convert';

VerifyInsureAccountResponse verifyInsureAccountResponseFromJson(String str) =>
    VerifyInsureAccountResponse.fromJson(json.decode(str));

String verifyInsureAccountResponseToJson(VerifyInsureAccountResponse data) =>
    json.encode(data.toJson());

class VerifyInsureAccountResponse {
  VerifyInsureAccountResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory VerifyInsureAccountResponse.fromJson(Map<String, dynamic> json) =>
      VerifyInsureAccountResponse(
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
    required this.link,
  });

  String link;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
      };
}
