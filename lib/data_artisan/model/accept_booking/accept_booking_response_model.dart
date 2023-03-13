import 'dart:convert';

AcceptBookingResponse acceptBookingResponseFromJson(String str) => AcceptBookingResponse.fromJson(json.decode(str));

String acceptBookingResponseToJson(AcceptBookingResponse data) => json.encode(data.toJson());

class AcceptBookingResponse {
  AcceptBookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  dynamic data;

  factory AcceptBookingResponse.fromJson(Map<String, dynamic> json) => AcceptBookingResponse(
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
