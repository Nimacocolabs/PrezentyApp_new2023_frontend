import 'dart:convert';

WalletCreationAndPaymentStatus walletCreationAndPaymentStatus(String str) =>
    WalletCreationAndPaymentStatus.fromJson(json.decode(str));

class WalletCreationAndPaymentStatus {
  WalletCreationAndPaymentStatus({
    this.statusCode,
    // this.responseCode,
    this.message,
    this.success,
    this.data,
  });

  int? statusCode;
  // String? responseCode;
  String? message;
  bool? success;

  Data? data;

  WalletCreationAndPaymentStatus.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    //responseCode = json["responseCode"];
    message = json["message"];
    success = json["success"];

    data = Data.fromJson(
      json["data"],
    );
  }
}

class Data {
  Data(
      {this.cardId,
      this.paymentStatus,
      this.walletStatus,
      this.razorpayId,
      this.slug});
  int? cardId;
  bool? paymentStatus;
  bool? walletStatus;
  String? razorpayId;
  String? panNumber;
  String? firstName;
  String? lastName;
  String? slug;

  Data.fromJson(dynamic json) {
    cardId = json["card_id"] ?? 0;
    paymentStatus = json["paymentStatus"] ?? false;
    walletStatus = json["walletStatus"] ?? false;
    razorpayId = json["rzr_pay_id"] ?? "";
    panNumber = json["pan_number"] ?? "";
    firstName = json["first_name"] ?? "";
    lastName = json["last_name"] ?? "";
    slug = json["slug"] ?? "";
  }
}
