import 'dart:convert';

RegisterNewUserRequest registerNewUserRequestFromJson(String str) => RegisterNewUserRequest.fromJson(json.decode(str));

String registerNewUserRequestToJson(RegisterNewUserRequest data) => json.encode(data.toJson());

class RegisterNewUserRequest {
  RegisterNewUserRequest({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.userType,
  });

  String? fullName;
  String? phoneNumber;
  String? email;
  String? password;
  String? passwordConfirmation;
  String? userType;

  factory RegisterNewUserRequest.fromJson(Map<String, dynamic> json) => RegisterNewUserRequest(
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    email: json["email"],
    password: json["password"],
    passwordConfirmation: json["password_confirmation"],
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "phone_number": "234${phoneNumber!.substring(1)}",
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
    "user_type": userType,
  };
}