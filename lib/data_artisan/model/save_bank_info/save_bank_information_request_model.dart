import 'dart:convert';

SaveBankInformationRequest saveBankInformationRequestFromJson(String str) =>
    SaveBankInformationRequest.fromJson(json.decode(str));

String saveBankInformationRequestToJson(SaveBankInformationRequest data) =>
    json.encode(data.toJson());

class SaveBankInformationRequest {
  SaveBankInformationRequest({
    this.bank,
    this.bankCode,
    this.accountNumber,
    this.accountName,
    this.bvn,
  });

  String? bank;
  String? bankCode;
  String? accountNumber;
  String? accountName;
  String? bvn;

  factory SaveBankInformationRequest.fromJson(Map<String, dynamic> json) =>
      SaveBankInformationRequest(
        bank: json["bank"],
        bankCode: json["bank_code"],
        accountNumber: json["account_number"],
        accountName: json["account_name"],
        bvn: json["bvn"],
      );

  Map<String, dynamic> toJson() => {
        "bank": bank,
        "bank_code": bankCode,
        "account_number": accountNumber,
        "account_name": accountName,
        "bvn": bvn,
      };
}
