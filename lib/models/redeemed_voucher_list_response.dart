// To parse this JSON data, do
//
//     final redeemedVouchersResponse = redeemedVouchersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:event_app/models/redeemed_voucher_response_model.dart';

RedeemedVoucherListResponse redeemedVouchersResponseFromJson(String str) =>
    RedeemedVoucherListResponse.fromJson(json.decode(str));

class RedeemedVoucherListResponse {
  RedeemedVoucherListResponse({
    this.statusCode,
    this.basePathWoohooImages,
    this.data,
    this.message,
    this.success,
  });

  int? statusCode;
  String? basePathWoohooImages;
  List<RedeemedVoucherData>? data;
  String? message;
  bool? success;

  RedeemedVoucherListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];

    basePathWoohooImages = json["base_path_woohoo_images"];

    if (json["data"] != null) {
      data = List<RedeemedVoucherData>.from(
          json["data"].map((x) => RedeemedVoucherData.fromJson(x)));
    }
    message = json["message"];
    success = json["success"];
  }
}

class RedeemedVoucherData {
  RedeemedVoucherData({
    this.image,
    this.orders,
    this.payment,
    this.product,
    this.jsonData,
  });

  String? image;
  List<Order>? orders;
  PaymentData? payment;
  ProductData? product;
  dynamic jsonData;

  RedeemedVoucherData.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    orders = List<Order>.from(json["orders"].map((x) => Order.fromJson(x)));
    payment = PaymentData.fromJson(json["payment"]);
    product = ProductData.fromJson(json["product"]);
    jsonData = RedeemedVouchersResponse.fromJson(jsonDecode(json["jsonData"]));
    //RedeemedVouchersResponse.fromJson(json.decode(json["jsonData"]));
  }
}

class Order {
  Order({
    this.id,
    this.amount,
    this.status,
    this.cardNo,
    this.cardPin,
    this.eventId,
    this.validity,
    this.createdAt,
    this.issueDate,
    this.requestBody,
    this.activationUrl,
    this.recipientName,
    this.activationCode,
    this.recipientEmail,
    this.recipientMobile,
  });

  int? id;
  int? amount;
  String? status;
  String? cardNo; 
  String? cardPin;
  String? eventId;
  DateTime? validity;
  DateTime? createdAt;
  DateTime? issueDate;
  RequestBody? requestBody;
  dynamic activationUrl;
  String? recipientName;
  dynamic activationCode;
  String? recipientEmail;
  String? recipientMobile;

  Order.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    amount = json["amount"];
    status = json["status"];
    cardNo = json["card_no"];
    cardPin = json["card_pin"];
    eventId = json["event_id"];
    validity = DateTime.parse(json["validity"]);
    createdAt = DateTime.parse(json["created_at"]);
    issueDate = DateTime.parse(json["issue_date"]);
    requestBody = RequestBody.fromJson(json["request_body"]);
    activationUrl = json["activation_url"];
    recipientName = json["recipient_name"];
    activationCode = json["activation_code"];
    recipientEmail = json["recipient_email"];
    recipientMobile = json["recipient_mobile"];
  }
}

class RequestBody {
  RequestBody({
    this.refno,
    this.address,
    this.billing,
    this.payments,
    this.products,
    this.syncOnly,
    this.deliveryMode,
  });

  String? refno;
  Address? address;
  Address? billing;
  List<PaymentElement>? payments;
  List<ProductElement>? products;
  bool? syncOnly;
  String? deliveryMode;

  RequestBody.fromJson(Map<String, dynamic> json) {
    refno = json["refno"];
    address = Address.fromJson(json["address"]);
    billing = Address.fromJson(json["billing"]);
    payments = List<PaymentElement>.from(
        json["payments"].map((x) => PaymentElement.fromJson(x)));
    products = List<ProductElement>.from(
        json["products"].map((x) => ProductElement.fromJson(x)));
    syncOnly = json["syncOnly"];
    deliveryMode = json["deliveryMode"];
  }
}

class Address {
  Address({
    this.email,
    this.country,
    this.lastname,
    this.firstname,
    this.telephone,
    this.billToThis,
  });

  String? email;
  String? country;
  String? lastname;
  String? firstname;
  String? telephone;
  bool? billToThis;

  Address.fromJson(Map<String, dynamic> json) {
    email = json["email"] ?? '';
    country = json["country"] ?? '';
    lastname = json["lastname"] ?? '';
    firstname = json["firstname"] ?? '';
    telephone = json["telephone"] ?? '';
    billToThis = json["billToThis"] == null ? null : json["billToThis"];
  }
}

class PaymentElement {
  PaymentElement({
    this.code,
    this.amount,
  });

  String? code;
  int? amount;

  PaymentElement.fromJson(Map<String, dynamic> json) {
    code = json["code"] ?? '';
    amount = json["amount"] ?? '';
  }
}

class ProductElement {
  ProductElement({
    this.qty,
    this.sku,
    this.price,
    this.currency,
    this.giftMessage,
  });

  dynamic qty;
  String? sku;
  String? price;
  int? currency;
  String? giftMessage;

  ProductElement.fromJson(Map<String, dynamic> json) {
    qty = json["qty"] ?? '';
    sku = json["sku"] ?? '';
    price = json["price"] ?? '';
    currency = json["currency"] ?? '';
    giftMessage = json["giftMessage"] ?? '';
  }
}

class PaymentData {
  PaymentData({
    this.id,
    this.amount,
    this.status,
    this.invNoId,
    this.createdAt,
  });

  int? id;
  String? amount;
  String? status;
  String? invNoId;
  DateTime? createdAt;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        id: json["id"],
        amount: json["amount"].toString(),
        status: json["status"],
        invNoId: json["inv_no_id"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "status": status,
        "inv_no_id": invNoId,
        "created_at": createdAt?.toIso8601String(),
      };
}

class ProductData {
  ProductData({
    this.id,
    this.image,
    this.productName,
  });

  int? id;
  String? image;
  String? productName;

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    image = json["image"];
    productName = json["product_name"];
  }
}
