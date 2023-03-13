import 'dart:convert';

NewListingResponse newListingResponseFromJson(String str) =>
    NewListingResponse.fromJson(json.decode(str));

String newListingResponseToJson(NewListingResponse data) =>
    json.encode(data.toJson());

class NewListingResponse {
  NewListingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory NewListingResponse.fromJson(Map<String, dynamic> json) =>
      NewListingResponse(
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
    required this.slug,
  });

  String slug;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
      };
}
