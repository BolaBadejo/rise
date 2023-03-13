import 'dart:convert';

ListingResponseModel listingResponseModelFromJson(String str) =>
    ListingResponseModel.fromJson(json.decode(str));

String listingResponseModelToJson(ListingResponseModel data) =>
    json.encode(data.toJson());

class ListingResponseModel {
  ListingResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory ListingResponseModel.fromJson(Map<String, dynamic> json) =>
      ListingResponseModel(
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
    required this.listing,
    required this.page,
  });

  List<Listing> listing;
  Page page;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        listing:
            List<Listing>.from(json["listing"].map((x) => Listing.fromJson(x))),
        page: Page.fromJson(json["page"]),
      );

  Map<String, dynamic> toJson() => {
        "listing": List<dynamic>.from(listing.map((x) => x.toJson())),
        "page": page.toJson(),
      };
}

class Listing {
  Listing({
    required this.id,
    required this.category,
    required this.serviceOffering,
    required this.title,
    required this.description,
    required this.profileImage,
    required this.listingImages,
    required this.minimumOffer,
    required this.slug,
    required this.tags,
    required this.user,
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
  List<String> tags;
  User user;

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        id: json["id"],
        category: json["category"],
        serviceOffering: json["service_offering"],
        title: json["title"],
        description: json["description"],
        profileImage: json["profile_image"],
        listingImages: List<String>.from(json["listing_images"].map((x) => x)),
        minimumOffer: json["minimum_offer"],
        slug: json["slug"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        user: User.fromJson(json["user"]),
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
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "user": user.toJson(),
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

class Page {
  Page({
    required this.hasPreviousPage,
    required this.currentPage,
    required this.hasNextPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool hasPreviousPage;
  int currentPage;
  bool hasNextPage;
  int lastPage;
  int perPage;
  int total;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        hasPreviousPage: json["has_previous_page"],
        currentPage: json["current_page"],
        hasNextPage: json["has_next_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "has_previous_page": hasPreviousPage,
        "current_page": currentPage,
        "has_next_page": hasNextPage,
        "last_page": lastPage,
        "per_page": perPage,
        "total": total,
      };
}
