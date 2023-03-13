
import 'dart:convert';

CreateBookingRequest createBookingRequestFromJson(String str) => CreateBookingRequest.fromJson(json.decode(str));

String createBookingRequestToJson(CreateBookingRequest data) => json.encode(data.toJson());

class CreateBookingRequest {
  CreateBookingRequest({
     this.listingId,
     this.title,
     this.description,
     this.amount,
  });

  String? listingId;
  String? title;
  String? description;
  String? amount;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) => CreateBookingRequest(
    listingId: json["listing_id"],
    title: json["title"],
    description: json["description"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "listing_id": listingId,
    "title": title,
    "description": description,
    "amount": amount,
  };
}
