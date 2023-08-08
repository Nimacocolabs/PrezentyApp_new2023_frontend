// To parse this JSON data, do
//
//     final registerWalletResponse = registerWalletResponseFromJson(jsonString);

import 'dart:convert';

RegisterWalletResponse registerWalletResponseFromJson(String str) =>
    RegisterWalletResponse.fromJson(json.decode(str));

class RegisterWalletResponse {
  RegisterWalletResponse({
    this.statusCode,
    //this.responseCode,
    this.message,
    this.success,
    this.data,
  });

  int? statusCode;

  //String? responseCode;
  String? message;
  bool? success;
  Data? data;

  RegisterWalletResponse.fromJson(dynamic json) {
    statusCode = json["statusCode"];

    //responseCode = json["statusCode"];
    message = json["message"];
    success = json["success"];
    data = Data.fromJson(
      json["data"],
    );
  }
}

class Data {
  Data({
    this.kycReferenceId,
  });

  int? kycReferenceId;

  Data.fromJson(Map<String, dynamic> json) {
    kycReferenceId = json["min_kyc_reference_id"];
  }
}
