// To parse this JSON data, do
//
//     final verifyMPinResponse = verifyMPinResponseFromJson(jsonString);

import 'dart:convert';

AuthMPinResponse authMPinResponseFromJson(String str) =>
    AuthMPinResponse.fromJson(json.decode(str));

class AuthMPinResponse {
  AuthMPinResponse({
    this.message,
    this.statusCode,
    this.success,
    this.data,
  });

  String? message;
  int? statusCode;
  bool? success;
  Data? data;

  AuthMPinResponse.fromJson(dynamic json) {
    message = json["message"];
    statusCode = json["statusCode"];
    success = json["success"];
    data = Data.fromJson(json["data"] ?? {});
  }
}

class Data {
  Data({
    this.accountId,
    this.kycVerified,
  });

  int? accountId;
  bool? kycVerified;

  Data.fromJson(Map<String, dynamic> json) {
    accountId = json["account_id"];
    kycVerified = json["kyc_verified"];
  }
}
