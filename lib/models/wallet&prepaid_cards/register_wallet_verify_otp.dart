// To parse this JSON data, do
//
//     final registerWalletVerifyOtp = registerWalletVerifyOtpFromJson(jsonString);

import 'dart:convert';

RegisterWalletVerifyOtp registerWalletVerifyOtpFromJson(String str) =>
    RegisterWalletVerifyOtp.fromJson(json.decode(str));

class RegisterWalletVerifyOtp {
  RegisterWalletVerifyOtp({
    this.statusCode,
    //this.responseCode,
    this.success,
    this.message,
    //this.data,
  });

  int? statusCode;

  //String? responseCode;
  bool? success;
  String? message;

  // Data? data;

  RegisterWalletVerifyOtp.fromJson(dynamic json) {
    statusCode = json["statusCode"];
    //responseCode = json["responseCode"];
    success = json["success"];
    message = json["message"];
    //  data = Data.fromJson(json["data"]);
  }
}
