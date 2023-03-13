import 'dart:convert';

UpdateListingResponse updateListingResponseFromJson(String str) =>
    UpdateListingResponse.fromJson(json.decode(str));

String updateListingResponseToJson(UpdateListingResponse data) =>
    json.encode(data.toJson());

class UpdateListingResponse {
  UpdateListingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory UpdateListingResponse.fromJson(Map<String, dynamic> json) =>
      UpdateListingResponse(
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
    required this.id,
    required this.category,
    required this.serviceOffering,
    required this.title,
    required this.description,
    required this.listingImages,
    required this.minimumOffer,
    required this.slug,
  });

  int id;
  String category;
  String serviceOffering;
  String title;
  String description;
  List<String> listingImages;
  String minimumOffer;
  String slug;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        category: json["category"],
        serviceOffering: json["service_offering"],
        title: json["title"],
        description: json["description"],
        listingImages: List<String>.from(json["listing_images"].map((x) => x)),
        minimumOffer: json["minimum_offer"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "service_offering": serviceOffering,
        "title": title,
        "description": description,
        "listing_images": List<dynamic>.from(listingImages.map((x) => x)),
        "minimum_offer": minimumOffer,
        "slug": slug,
      };
}
