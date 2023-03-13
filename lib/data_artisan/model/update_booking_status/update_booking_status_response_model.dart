import 'dart:convert';

UpdateBookingStatusResponse updateBookingStatusResponseFromJson(String str) =>
    UpdateBookingStatusResponse.fromJson(json.decode(str));

String updateBookingStatusResponseToJson(UpdateBookingStatusResponse data) =>
    json.encode(data.toJson());

class UpdateBookingStatusResponse {
  UpdateBookingStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  dynamic data;

  factory UpdateBookingStatusResponse.fromJson(Map<String, dynamic> json) =>
      UpdateBookingStatusResponse(
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
