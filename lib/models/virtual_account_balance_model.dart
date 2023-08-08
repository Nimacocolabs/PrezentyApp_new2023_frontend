
import 'dart:convert';

VirtualAccountBalanceModel virtualAccountBalanceFromJson(String str) => VirtualAccountBalanceModel.fromJson(json.decode(str));

class VirtualAccountBalanceModel {
  String? message;
  int? statusCode;
  bool? success;
  String? virtualAccountBalance;

  VirtualAccountBalanceModel({
    this.message,
    this.statusCode,
    this.success,
    this.virtualAccountBalance,
  });

  VirtualAccountBalanceModel.fromJson(dynamic json) {
    message = json["message"];
    statusCode = json["statusCode"];
    success = json["success"];
    virtualAccountBalance=json["amount"];
  }

}