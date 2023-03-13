import 'dart:convert';

StartBookingRequest startBookingRequestFromJson(String str) =>
    StartBookingRequest.fromJson(json.decode(str));

String startBookingRequestToJson(StartBookingRequest data) =>
    json.encode(data.toJson());

class StartBookingRequest {
  StartBookingRequest({
    this.bookingId,
    this.taskId,
  });

  int? bookingId;
  int? taskId;

  factory StartBookingRequest.fromJson(Map<String, dynamic> json) =>
      StartBookingRequest(
        bookingId: json["booking_id"],
        taskId: json["task_id"],
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "task_id": taskId,
      };
}
