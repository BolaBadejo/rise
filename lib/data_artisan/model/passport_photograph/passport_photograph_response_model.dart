import 'dart:convert';

PassportPhotographResponse passportPhotographResponseFromJson(String str) =>
    PassportPhotographResponse.fromJson(json.decode(str));

String passportPhotographResponseToJson(PassportPhotographResponse data) =>
    json.encode(data.toJson());

class PassportPhotographResponse {
  PassportPhotographResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  dynamic data;

  factory PassportPhotographResponse.fromJson(Map<String, dynamic> json) =>
      PassportPhotographResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };
}
