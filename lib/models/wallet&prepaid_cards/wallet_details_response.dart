// To parse this JSON data, do
//
//     final walletDetailsResponse = walletDetailsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WalletDetailsResponse walletDetailsResponseFromJson(String str) =>
    WalletDetailsResponse.fromJson(json.decode(str));

class WalletDetailsResponse {
  bool? success;
  int? statusCode;
  String? message;
  WalletDetails? walletDetails;

  WalletDetailsResponse(
      {this.success, this.statusCode, this.message, this.walletDetails});

  WalletDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    walletDetails = json['walletDetails'] != null
        ? new WalletDetails.fromJson(json['walletDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.walletDetails != null) {
      data['walletDetails'] = this.walletDetails!.toJson();
    }
    return data;
  }
}

class WalletDetails {
  String? entityId;
  String? kitNo;
  String? token;
  String? dob;
  String? walletNumber;
  String? prepaidCardId;
  String? virtualAccountNumber;
  String? phoneNumber;
  int? referredBy;
  Null? couponCode;
  int? valid;
  String? cardName;
  String? slug;
  CardDetails? cardDetails;
  BalanceInfo? balanceInfo;

  WalletDetails(
      {this.entityId,
        this.kitNo,
        this.token,
        this.dob,
        this.walletNumber,
        this.prepaidCardId,
        this.virtualAccountNumber,
        this.phoneNumber,
        this.referredBy,
        this.couponCode,
        this.valid,
        this.cardName,
        this.slug,
        this.cardDetails,
        this.balanceInfo});

  WalletDetails.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    kitNo = json['kit_no'];
    token = json['token'];
    dob = json['dob'];
    walletNumber = json['wallet_number'];
    prepaidCardId = json['prepaid_card_id'];
    virtualAccountNumber = json['virtual_account_number'];
    phoneNumber = json['phone_number'];
    referredBy = json['referred_by'];
    couponCode = json['coupon_code'];
    valid = json['valid'];
    cardName = json['card_name'];
    slug = json['slug'];
    cardDetails = json['CardDetails'] != null
        ? new CardDetails.fromJson(json['CardDetails'])
        : null;
    balanceInfo = json['balanceInfo'] != null
        ? new BalanceInfo.fromJson(json['balanceInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity_id'] = this.entityId;
    data['kit_no'] = this.kitNo;
    data['token'] = this.token;
    data['dob'] = this.dob;
    data['wallet_number'] = this.walletNumber;
    data['prepaid_card_id'] = this.prepaidCardId;
    data['virtual_account_number'] = this.virtualAccountNumber;
    data['phone_number'] = this.phoneNumber;
    data['referred_by'] = this.referredBy;
    data['coupon_code'] = this.couponCode;
    data['valid'] = this.valid;
    data['card_name'] = this.cardName;
    data['slug'] = this.slug;
    if (this.cardDetails != null) {
      data['CardDetails'] = this.cardDetails!.toJson();
    }
    if (this.balanceInfo != null) {
      data['balanceInfo'] = this.balanceInfo!.toJson();
    }
    return data;
  }
}

class CardDetails {
  String? cardNumber;
  String? kitNo;
  String? expiry;
  String? status;
  String? type;
  String? network;

  CardDetails(
      {this.cardNumber,
        this.kitNo,
        this.expiry,
        this.status,
        this.type,
        this.network});

  CardDetails.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    kitNo = json['kitNo'];
    expiry = json['expiry'];
    status = json['status'];
    type = json['type'];
    network = json['network'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNumber'] = this.cardNumber;
    data['kitNo'] = this.kitNo;
    data['expiry'] = this.expiry;
    data['status'] = this.status;
    data['type'] = this.type;
    data['network'] = this.network;
    return data;
  }
}

class BalanceInfo {
  String? balance;
  String? lienBalance;

  BalanceInfo({this.balance, this.lienBalance});

  BalanceInfo.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    lienBalance = json['lienBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['lienBalance'] = this.lienBalance;
    return data;
  }
}
// class WalletDetailsResponse {
//   bool? success;
//   int? statusCode;
//   String? message;
//   WalletDetails? walletDetails;
//
//   WalletDetailsResponse(
//       {this.success, this.statusCode, this.message, this.walletDetails});
//
//   WalletDetailsResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     statusCode = json['status_code'];
//     message = json['message'];
//     walletDetails = json['walletDetails'] != null
//         ? new WalletDetails.fromJson(json['walletDetails'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['status_code'] = this.statusCode;
//     data['message'] = this.message;
//     if (this.walletDetails != null) {
//       data['walletDetails'] = this.walletDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class WalletDetails {
//   String? entityId;
//   String? kitNo;
//   String? token;
//   String? dob;
//   String? walletNumber;
//   String? prepaidCardId;
//   String? virtualAccountNumber;
//   String? phoneNumber;
//   int? referredBy;
//   Null? couponCode;
//   int? valid;
//   String? cardName;
//   String? slug;
//   List<CardDetails>? cardDetails;
//   BalanceInfo? balanceInfo;
//
//   WalletDetails(
//       {this.entityId,
//         this.kitNo,
//         this.token,
//         this.dob,
//         this.walletNumber,
//         this.prepaidCardId,
//         this.virtualAccountNumber,
//         this.phoneNumber,
//         this.referredBy,
//         this.couponCode,
//         this.valid,
//         this.cardName,
//         this.slug,
//         this.cardDetails,
//         this.balanceInfo});
//
//   WalletDetails.fromJson(Map<String, dynamic> json) {
//     entityId = json['entity_id'];
//     kitNo = json['kit_no'];
//     token = json['token'];
//     dob = json['dob'];
//     walletNumber = json['wallet_number'];
//     prepaidCardId = json['prepaid_card_id'];
//     virtualAccountNumber = json['virtual_account_number'];
//     phoneNumber = json['phone_number'];
//     referredBy = json['referred_by'];
//     couponCode = json['coupon_code'];
//     valid = json['valid'];
//     cardName = json['card_name'];
//     slug = json['slug'];
//     if (json['cardDetails'] != null) {
//       cardDetails = <CardDetails>[];
//       json['cardDetails'].forEach((v) {
//         cardDetails!.add(new CardDetails.fromJson(v));
//       });
//     }
//     balanceInfo = json['balanceInfo'] != null
//         ? new BalanceInfo.fromJson(json['balanceInfo'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['entity_id'] = this.entityId;
//     data['kit_no'] = this.kitNo;
//     data['token'] = this.token;
//     data['dob'] = this.dob;
//     data['wallet_number'] = this.walletNumber;
//     data['prepaid_card_id'] = this.prepaidCardId;
//     data['virtual_account_number'] = this.virtualAccountNumber;
//     data['phone_number'] = this.phoneNumber;
//     data['referred_by'] = this.referredBy;
//     data['coupon_code'] = this.couponCode;
//     data['valid'] = this.valid;
//     data['card_name'] = this.cardName;
//     data['slug'] = this.slug;
//     if (this.cardDetails != null) {
//       data['cardDetails'] = this.cardDetails!.map((v) => v.toJson()).toList();
//     }
//     if (this.balanceInfo != null) {
//       data['balanceInfo'] = this.balanceInfo!.toJson();
//     }
//     return data;
//   }
// }
//
// class CardDetails {
//   String? cardNumber;
//   String? expiry;
//   String? status;
//   String? type;
//   String? network;
//   String? cardUrl;
//
//   CardDetails(
//       {this.cardNumber,
//         this.expiry,
//         this.status,
//         this.type,
//         this.network,
//         this.cardUrl});
//
//   CardDetails.fromJson(Map<String, dynamic> json) {
//     cardNumber = json['cardNumber'];
//     expiry = json['expiry'];
//     status = json['status'];
//     type = json['type'];
//     network = json['network'];
//     cardUrl = json['card_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['cardNumber'] = this.cardNumber;
//     data['expiry'] = this.expiry;
//     data['status'] = this.status;
//     data['type'] = this.type;
//     data['network'] = this.network;
//     data['card_url'] = this.cardUrl;
//     return data;
//   }
// }
//
// class BalanceInfo {
//   String? balance;
//   String? lienBalance;
//
//   BalanceInfo({this.balance, this.lienBalance});
//
//   BalanceInfo.fromJson(Map<String, dynamic> json) {
//     balance = json['balance'];
//     lienBalance = json['lienBalance'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['balance'] = this.balance;
//     data['lienBalance'] = this.lienBalance;
//     return data;
//   }
// }

//
// class WalletDetailsResponse {
//   WalletDetailsResponse({
//     @required this.message,
//     @required this.statusCode,
//     @required this.success,
//     @required this.data,
//   });
//
//   String? message;
//   int? statusCode;
//   bool? success;
//   WalletDetailsData? data;
//
//   factory WalletDetailsResponse.fromJson(Map<String, dynamic> json) =>
//       WalletDetailsResponse(
//         message: json["message"],
//         statusCode: json["statusCode"],
//         success: json["success"],
//         data: json["data"] == null ? null : WalletDetailsData.fromJson(json["data"]),
//       );
// }
//
// class WalletDetailsData {
//   WalletDetailsData({
//     @required this.walletDetails,
//     @required this.cardDetails,
//   });
//
//   WalletDetails? walletDetails;
//   List<CardDetail>? cardDetails;
//
//   factory WalletDetailsData.fromJson(Map<String, dynamic> json) => WalletDetailsData(
//         walletDetails: json["wallet_details"] == null
//             ? null
//             : WalletDetails.fromJson(json["wallet_details"]),
//         cardDetails: json["card_details"] == null
//             ? null
//             : List<CardDetail>.from(
//                 json["card_details"].map((x) => CardDetail.fromJson(x))),
//       );
// }
//
// class CardDetail {
//   CardDetail({
//     @required this.userId,
//     @required this.cardNumber,
//     @required this.cvv,
//     @required this.expiryMonth,
//     @required this.expiryYear,
//     @required this.kitNumber,
//     @required this.type,
//     @required this.subType,
//     @required this.updatedAt,
//   });
//
//   String? userId;
//   String? cardNumber;
//   String? cvv;
//   String? expiryMonth;
//   String? expiryYear;
//   String? kitNumber;
//   String? type;
//   String? subType;
//   DateTime? updatedAt;
//
//   factory CardDetail.fromJson(Map<String, dynamic> json) => CardDetail(
//         userId: json["user_id"] == null ? null : json["user_id"],
//         cardNumber: json["card_number"] == null ? null : json["card_number"],
//         cvv: json["cvv"] == null ? null : json["cvv"],
//         expiryMonth: json["expiry_month"] == null ? null : json["expiry_month"],
//         expiryYear: json["expiry_year"] == null ? null : json["expiry_year"],
//         kitNumber: json["kit_number"] == null ? null : json["kit_number"],
//         type: json["type"] == null ? null : json["type"],
//         subType: json["sub_type"] == null ? null : json["sub_type"],
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//       );
// }
//
// class WalletDetails {
//
//   WalletDetails({
//     @required this.walletNumber,
//     @required this.balance,
//     @required this.walletStatus,
//     @required this.walletType,
//     @required this.virtualAccountNumber,
//     @required this.ifsc,
//     @required this.upiid,
//     @required this.planType,
//     @required this.cardName,
//     @required this.cardId,
//     @required this.monthyTrxLimit,
//     @required this.monthlyLoadLimit,
//     @required this.monthlyBalanceLimit,
//     @required this.annualLoadLimit,
//   });
//
//   String? walletNumber;
//   dynamic? balance;
//   String? walletStatus;
//   String? walletType;
//   String? virtualAccountNumber;
//   String? ifsc;
//   String? upiid;
//   String? planType;
//   String? cardName;
//   int? cardId;
//   int? monthyTrxLimit;
//   int? monthlyLoadLimit;
//   int? monthlyBalanceLimit;
//   int? annualLoadLimit;
//
//   factory WalletDetails.fromJson(Map<String, dynamic> json) => WalletDetails(
//         walletNumber:
//             json["wallet_number"] == null ? null : json["wallet_number"],
//         balance: json["balance"] == null ? null : json["balance"],
//         walletStatus:
//             json["wallet_status"] == null ? null : json["wallet_status"],
//         walletType: json["wallet_type"] == null ? null : json["wallet_type"],
//     cardName: json["card_name"] == null ? null : json["card_name"],
//     cardId: json["card_id"] == null ? null : json["card_id"],
//         virtualAccountNumber: json["virtual_account_number"] == null
//             ? null
//             : json["virtual_account_number"],
//         ifsc: json["ifsc"] == null ? null : json["ifsc"],
//         upiid: json["upiid"] == null ? null : json["upiid"],
//         planType: json["plan_type"] == null ? null : json["plan_type"],
//         monthyTrxLimit:
//             json["monthy_trx_limit"] == null ? null : json["monthy_trx_limit"],
//         monthlyLoadLimit: json["monthly_load_limit"] == null
//             ? null
//             : json["monthly_load_limit"],
//         monthlyBalanceLimit: json["monthly_balance_limit"] == null
//             ? null
//             : json["monthly_balance_limit"],
//         annualLoadLimit: json["annual_load_limit"] == null
//             ? null
//             : json["annual_load_limit"],
//       );
// }
