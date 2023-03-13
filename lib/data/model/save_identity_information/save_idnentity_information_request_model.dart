import 'dart:convert';

SaveIdentityInformationRequest saveIdentityInformationRequestFromJson(String str) => SaveIdentityInformationRequest.fromJson(json.decode(str));

String saveIdentityInformationRequestToJson(SaveIdentityInformationRequest data) => json.encode(data.toJson());

class SaveIdentityInformationRequest {
  SaveIdentityInformationRequest({
    this.meansOfIdentity,
    this.identityNumber,
  });

  String? meansOfIdentity;
  String? identityNumber;

  factory SaveIdentityInformationRequest.fromJson(Map<String, dynamic> json) => SaveIdentityInformationRequest(
    meansOfIdentity: json["means_of_identity"],
    identityNumber: json["identity_number"],
  );

  Map<String, dynamic> toJson() => {
    "means_of_identity": meansOfIdentity,
    "identity_number": identityNumber,
  };
}