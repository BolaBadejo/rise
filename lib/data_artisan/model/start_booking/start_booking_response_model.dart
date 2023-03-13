import 'dart:convert';

StartBookingResponse startBookingResponseFromJson(String str) =>
    StartBookingResponse.fromJson(json.decode(str));

String startBookingResponseToJson(StartBookingResponse data) =>
    json.encode(data.toJson());

class StartBookingResponse {
  StartBookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory StartBookingResponse.fromJson(Map<String, dynamic> json) =>
      StartBookingResponse(
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
