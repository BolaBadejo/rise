import 'dart:convert';

FindListingResponse findListingResponseFromJson(String str) =>
    FindListingResponse.fromJson(json.decode(str));

String findListingResponseToJson(FindListingResponse data) =>
    json.encode(data.toJson());

class FindListingResponse {
  FindListingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory FindListingResponse.fromJson(Map<String, dynamic> json) =>
      FindListingResponse(
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
    required this.profileImage,
    required this.listingImages,
    required this.minimumOffer,
    required this.slug,
    required this.user,
    required this.tags,
  });

  int id;
  String category;
  String serviceOffering;
  String title;
  String description;
  String profileImage;
  List<String> listingImages;
  String minimumOffer;
  String slug;
  User user;
  List<String> tags;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        category: json["category"],
        serviceOffering: json["service_offering"],
        title: json["title"],
        description: json["description"],
        profileImage: json["profile_image"],
        listingImages: List<String>.from(json["listing_images"].map((x) => x)),
        minimumOffer: json["minimum_offer"],
        slug: json["slug"],
        user: User.fromJson(json["user"]),
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "service_offering": serviceOffering,
        "title": title,
        "description": description,
        "profile_image": profileImage,
        "listing_images": List<dynamic>.from(listingImages.map((x) => x)),
        "minimum_offer": minimumOffer,
        "slug": slug,
        "user": user.toJson(),
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}

class User {
  User({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.type,
    required this.residentialAddress,
    required this.city,
    required this.state,
    required this.lat,
    required this.lng,
    required this.businessAddress,
  });

  String name;
  String phoneNumber;
  String email;
  String type;
  String residentialAddress;
  String city;
  String state;
  String lat;
  String lng;
  String businessAddress;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        type: json["type"],
        residentialAddress: json["residential_address"],
        city: json["city"],
        state: json["state"],
        lat: json["lat"],
        lng: json["lng"],
        businessAddress: json["business_address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
        "email": email,
        "type": type,
        "residential_address": residentialAddress,
        "city": city,
        "state": state,
        "lat": lat,
        "lng": lng,
        "business_address": businessAddress,
      };
}
