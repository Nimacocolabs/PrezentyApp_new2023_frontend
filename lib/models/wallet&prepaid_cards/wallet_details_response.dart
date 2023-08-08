// To parse this JSON data, do
//
//     final walletDetailsResponse = walletDetailsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WalletDetailsResponse walletDetailsResponseFromJson(String str) =>
    WalletDetailsResponse.fromJson(json.decode(str));


class WalletDetailsResponse {
  WalletDetailsResponse({
    @required this.message,
    @required this.statusCode,
    @required this.success,
    @required this.data,
  });

  String? message;
  int? statusCode;
  bool? success;
  WalletDetailsData? data;

  factory WalletDetailsResponse.fromJson(Map<String, dynamic> json) =>
      WalletDetailsResponse(
        message: json["message"],
        statusCode: json["statusCode"],
        success: json["success"],
        data: json["data"] == null ? null : WalletDetailsData.fromJson(json["data"]),
      );
}

class WalletDetailsData {
  WalletDetailsData({
    @required this.walletDetails,
    @required this.cardDetails,
  });

  WalletDetails? walletDetails;
  List<CardDetail>? cardDetails;

  factory WalletDetailsData.fromJson(Map<String, dynamic> json) => WalletDetailsData(
        walletDetails: json["wallet_details"] == null
            ? null
            : WalletDetails.fromJson(json["wallet_details"]),
        cardDetails: json["card_details"] == null
            ? null
            : List<CardDetail>.from(
                json["card_details"].map((x) => CardDetail.fromJson(x))),
      );
}

class CardDetail {
  CardDetail({
    @required this.userId,
    @required this.cardNumber,
    @required this.cvv,
    @required this.expiryMonth,
    @required this.expiryYear,
    @required this.kitNumber,
    @required this.type,
    @required this.subType,
    @required this.updatedAt,
  });

  String? userId;
  String? cardNumber;
  String? cvv;
  String? expiryMonth;
  String? expiryYear;
  String? kitNumber;
  String? type;
  String? subType;
  DateTime? updatedAt;

  factory CardDetail.fromJson(Map<String, dynamic> json) => CardDetail(
        userId: json["user_id"] == null ? null : json["user_id"],
        cardNumber: json["card_number"] == null ? null : json["card_number"],
        cvv: json["cvv"] == null ? null : json["cvv"],
        expiryMonth: json["expiry_month"] == null ? null : json["expiry_month"],
        expiryYear: json["expiry_year"] == null ? null : json["expiry_year"],
        kitNumber: json["kit_number"] == null ? null : json["kit_number"],
        type: json["type"] == null ? null : json["type"],
        subType: json["sub_type"] == null ? null : json["sub_type"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}

class WalletDetails {

  WalletDetails({
    @required this.walletNumber,
    @required this.balance,
    @required this.walletStatus,
    @required this.walletType,
    @required this.virtualAccountNumber,
    @required this.ifsc,
    @required this.upiid,
    @required this.planType,
    @required this.cardName,
    @required this.cardId,
    @required this.monthyTrxLimit,
    @required this.monthlyLoadLimit,
    @required this.monthlyBalanceLimit,
    @required this.annualLoadLimit,
  });

  String? walletNumber;
  dynamic? balance;
  String? walletStatus;
  String? walletType;
  String? virtualAccountNumber;
  String? ifsc;
  String? upiid;
  String? planType;
  String? cardName;
  int? cardId;
  int? monthyTrxLimit;
  int? monthlyLoadLimit;
  int? monthlyBalanceLimit;
  int? annualLoadLimit;

  factory WalletDetails.fromJson(Map<String, dynamic> json) => WalletDetails(
        walletNumber:
            json["wallet_number"] == null ? null : json["wallet_number"],
        balance: json["balance"] == null ? null : json["balance"],
        walletStatus:
            json["wallet_status"] == null ? null : json["wallet_status"],
        walletType: json["wallet_type"] == null ? null : json["wallet_type"],
    cardName: json["card_name"] == null ? null : json["card_name"],
    cardId: json["card_id"] == null ? null : json["card_id"],
        virtualAccountNumber: json["virtual_account_number"] == null
            ? null
            : json["virtual_account_number"],
        ifsc: json["ifsc"] == null ? null : json["ifsc"],
        upiid: json["upiid"] == null ? null : json["upiid"],
        planType: json["plan_type"] == null ? null : json["plan_type"],
        monthyTrxLimit:
            json["monthy_trx_limit"] == null ? null : json["monthy_trx_limit"],
        monthlyLoadLimit: json["monthly_load_limit"] == null
            ? null
            : json["monthly_load_limit"],
        monthlyBalanceLimit: json["monthly_balance_limit"] == null
            ? null
            : json["monthly_balance_limit"],
        annualLoadLimit: json["annual_load_limit"] == null
            ? null
            : json["annual_load_limit"],
      );
}
