
import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

class CommonResponse {
  String? message;
  int? statusCode;
  bool? success;
  String? walletNumber;

  CommonResponse({
      this.message, 
      this.statusCode, 
      this.success,
      this.walletNumber});

  CommonResponse.fromJson(dynamic json) {
    message = json["message"];
    statusCode = json["statusCode"];
    success = json["success"];
    walletNumber = json["wallet_number"];

    
  }

}