// To parse this JSON data, do
//
//     final forgetMPinSendOtpResponse = forgetMPinSendOtpResponseFromJson(jsonString);

import 'dart:convert';

ForgetMPinSendOtpResponse forgetMPinSendOtpResponseFromJson(String str) =>
    ForgetMPinSendOtpResponse.fromJson(json.decode(str));

class ForgetMPinSendOtpResponse {
  ForgetMPinSendOtpResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  OtpData? data;
  bool? success;
  int? statusCode;
  String? message;

  ForgetMPinSendOtpResponse.fromJson(dynamic json) {
    data = OtpData.fromJson(json["data"] ?? {});
    success = json["success"];
    statusCode = json["statusCode"];
    message = json["message"];
  }
}

class OtpData {
  OtpData({
    this.otp_reference_id,
  });

  int? otp_reference_id;

  OtpData.fromJson(dynamic json) {
    otp_reference_id = json["reference_id"];
  }
}
