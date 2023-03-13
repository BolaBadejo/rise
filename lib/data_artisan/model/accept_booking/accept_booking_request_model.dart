import 'dart:convert';

AcceptBookingRequest acceptBookingRequestFromJson(String str) =>
    AcceptBookingRequest.fromJson(json.decode(str));

String acceptBookingRequestToJson(AcceptBookingRequest data) =>
    json.encode(data.toJson());

class AcceptBookingRequest {
  AcceptBookingRequest({
    this.bookingId,
    this.amount,
  });

  String? bookingId;
  String? amount;

  factory AcceptBookingRequest.fromJson(Map<String, dynamic> json) =>
      AcceptBookingRequest(
        bookingId: json["booking_id"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "amount": amount,
      };
}
