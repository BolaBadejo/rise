import 'dart:convert';

UpdateBookingStatusRequest updateBookingStatusRequestFromJson(String str) =>
    UpdateBookingStatusRequest.fromJson(json.decode(str));

String updateBookingStatusRequestToJson(UpdateBookingStatusRequest data) =>
    json.encode(data.toJson());

class UpdateBookingStatusRequest {
  UpdateBookingStatusRequest({
    this.bookingId,
    this.status,
  });

  String? bookingId;
  String? status;

  factory UpdateBookingStatusRequest.fromJson(Map<String, dynamic> json) =>
      UpdateBookingStatusRequest(
        bookingId: json["booking_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "status": status,
      };
}
