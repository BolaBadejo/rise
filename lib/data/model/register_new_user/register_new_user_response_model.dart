import 'dart:convert';

RegisterNewUserResponse registerNewUserResponseFromJson(String str) => RegisterNewUserResponse.fromJson(json.decode(str));

String registerNewUserResponseToJson(RegisterNewUserResponse data) => json.encode(data.toJson());

class RegisterNewUserResponse {
  RegisterNewUserResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory RegisterNewUserResponse.fromJson(Map<String, dynamic> json) => RegisterNewUserResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
