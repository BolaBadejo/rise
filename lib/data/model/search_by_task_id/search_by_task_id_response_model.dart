import 'dart:convert';

SearchByTaskIdResponse searchByTaskIdResponseFromJson(String str) =>
    SearchByTaskIdResponse.fromJson(json.decode(str));

String searchByTaskIdResponseToJson(SearchByTaskIdResponse data) =>
    json.encode(data.toJson());

class SearchByTaskIdResponse {
  SearchByTaskIdResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory SearchByTaskIdResponse.fromJson(Map<String, dynamic> json) =>
      SearchByTaskIdResponse(
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
  Data(
      {required this.taskId,
      required this.tentativeAmount,
      required this.bargainedAmount,
      required this.status,
      required this.title,
      required this.description,
      required this.rating,
      required this.ratingReview,
      required this.acceptedAt,
      required this.rejectedAt,
      required this.startedAt,
      required this.arrivedAt,
      required this.cancelledAt,
      required this.completedAt,
      required this.listing});

  String taskId;
  String tentativeAmount;
  String bargainedAmount;
  String status;
  String title;
  String description;
  dynamic rating;
  dynamic ratingReview;
  String acceptedAt;
  dynamic rejectedAt;
  dynamic startedAt;
  dynamic arrivedAt;
  dynamic cancelledAt;
  dynamic completedAt;
  Listing listing;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        taskId: json['task_id'],
        tentativeAmount: json['tentative_amount'],
        bargainedAmount: json['bargained_amount'],
        status: json['status'],
        title: json['title'],
        description: json['description'],
        rating: json['rating'],
        ratingReview: json['rating_review'],
        acceptedAt: json['accepted_at'],
        rejectedAt: json['rejected_at'],
        startedAt: json['started_at'],
        arrivedAt: json['arrived_at'],
        cancelledAt: json['cancelled_at'],
        completedAt: json['completed_at'],
        listing: Listing.fromJson(json["listing"]),
      );

  Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "tentative_amount": tentativeAmount,
        "bargained_amount": bargainedAmount,
        "status": status,
        "title": title,
        "description": description,
        "rating": rating,
        "rating_review": ratingReview,
        "accepted_at": acceptedAt,
        "rejected_at": rejectedAt,
        "started_at": startedAt,
        "arrived_at": arrivedAt,
        "cancelled_at": cancelledAt,
        "completed_at": completedAt,
        "listing": listing.toJson(),
      };
}

class Listing {
  Listing({
    required this.category,
    required this.serviceOffering,
    required this.title,
    required this.description,
    required this.profileImage,
    required this.listingImages,
    required this.minimumOffer,
    required this.slug,
    required this.user,
  });

  String category;
  String serviceOffering;
  String title;
  String description;
  String profileImage;
  List<String> listingImages;
  String minimumOffer;
  String slug;
  User user;

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        category: json["category"],
        serviceOffering: json["service_offering"],
        title: json["title"],
        description: json["description"],
        profileImage: json["profile_image"],
        listingImages: List<String>.from(json["listing_images"].map((x) => x)),
        minimumOffer: json["minimum_offer"],
        slug: json["slug"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "service_offering": serviceOffering,
        "title": title,
        "description": description,
        "profile_image": profileImage,
        "listing_images": List<dynamic>.from(listingImages.map((x) => x)),
        "minimum_offer": minimumOffer,
        "slug": slug,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  String name;
  String phoneNumber;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
        "email": email,
      };
}
