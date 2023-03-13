import 'dart:convert';

SavePersonalInformationRequest savePersonaInformationResponseFromJson(
        String str) =>
    SavePersonalInformationRequest.fromJson(json.decode(str));

String savePersonaInformationResponseToJson(
        SavePersonalInformationRequest data) =>
    json.encode(data.toJson());

class SavePersonalInformationRequest {
  SavePersonalInformationRequest({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.residentialAddress,
    this.city,
    this.state,
    this.lat,
    this.lng,
  });

  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? residentialAddress;
  String? city;
  String? state;
  String? lat;
  String? lng;

  factory SavePersonalInformationRequest.fromJson(Map<String, dynamic> json) =>
      SavePersonalInformationRequest(
        firstName: json["first_name"],
        lastName: json["last_name"],
        dateOfBirth: json["date_of_birth"],
        residentialAddress: json["residential_address"],
        city: json["city"],
        state: json["state"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth": dateOfBirth,
        "residential_address": residentialAddress,
        "city": city,
        "state": state,
        "lat": lat,
        "lng": lng,
      };
}
