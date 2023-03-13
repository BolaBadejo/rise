
import 'dart:convert';

CreateBookingResponse createBookingResponseFromJson(String str) => CreateBookingResponse.fromJson(json.decode(str));

String createBookingResponseToJson(CreateBookingResponse data) => json.encode(data.toJson());

class CreateBookingResponse {
  CreateBookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  dynamic data;

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) => CreateBookingResponse(
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
