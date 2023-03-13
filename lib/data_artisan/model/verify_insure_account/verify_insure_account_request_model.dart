import 'dart:convert';

VerifyInsureAccountRequest verifyInsureAccountRequestFromJson(String str) =>
    VerifyInsureAccountRequest.fromJson(json.decode(str));

String verifyInsureAccountRequestToJson(VerifyInsureAccountRequest data) =>
    json.encode(data.toJson());

class VerifyInsureAccountRequest {
  VerifyInsureAccountRequest({
    this.verifyAccount,
    this.insureProduct,
    // this.amount
  });

  String? verifyAccount;
  String? insureProduct;
  //String? amount;

  factory VerifyInsureAccountRequest.fromJson(Map<String, dynamic> json) =>
      VerifyInsureAccountRequest(
        verifyAccount: json["verify_account"],
        insureProduct: json["insure_product"],
        //amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "verify_account": verifyAccount,
        "insure_product": insureProduct,
        //"amount": amount
      };
}
