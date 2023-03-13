import 'dart:convert';

LogOutResponse logOutResponseFromJson(String str) =>
    LogOutResponse.fromJson(json.decode(str));

String logOutResponseToJson(LogOutResponse data) => json.encode(data.toJson());

class LogOutResponse {
  LogOutResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  dynamic data;

  factory LogOutResponse.fromJson(Map<String, dynamic> json) => LogOutResponse(
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
