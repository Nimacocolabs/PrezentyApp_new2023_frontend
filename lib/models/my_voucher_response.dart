import 'woohoo/woohoo_product_detail_response.dart';

class MyVoucherListResponse {
  MyVoucherListResponse({
      this.success, 
      this.message, 
      this.statusCode,
    this.basePathWoohooImages,
    this.data,});

  MyVoucherListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MyVoucher.fromJson(v));
      });
    }
    basePathWoohooImages = json['base_path_woohoo_images'];
  }
  bool? success;
  String? message;
  int? statusCode;
  List<MyVoucher>? data;
  String? basePathWoohooImages;

}

class MyVoucher {
  MyVoucher({
    this.invNo,
    this.image,
    this.id,
      this.amount, 
      this.status, 
      this.product, 
      this.cardPin, 
      this.eventId,
      this.isGifted,
      this.validity, 
      this.createdAt, 
      this.issueDate, 
      this.cardNo,
      this.activationUrl, 
      this.recipientName, 
      this.activationCode, 
      this.recipientEmail,
      this.recipientMobile,
    this.giftedBy,
    });

  MyVoucher.fromJson(dynamic json) {
    invNo = json['inv_no_id'];
    image = json['image'];
    id = json['id'];
    amount = json['amount'];
    status = json['status'];
    product = json['product'] != null ? WoohooProductDetail.fromJson(json['product']) : null;
    cardPin = json['card_pin'];
    eventId = json['event_id'];
    isGifted = json['is_gifted']??0;
    validity = json['validity'];
    createdAt = json['created_at'];
    issueDate = json['issue_date'];
    cardNo = json['card_no'];
    activationUrl = json['activation_url'];
    recipientName = json['recipient_name'];
    activationCode = json['activation_code'];
    recipientEmail = json['recipient_email'];
    recipientMobile = json['recipient_mobile'];
    giftedBy = json['gifted_by'] != null ? VoucherGiftedBy.fromJson(json['gifted_by']) : null;

  }
  String? invNo;
  String? image;
  int? id;
  int? amount;
  String? status;
  WoohooProductDetail? product;
  String? cardPin;
  String? eventId;
  int? isGifted;
  String? validity;
  String? createdAt;
  String? issueDate;
  String? cardNo;
  dynamic activationUrl;
  String? recipientName;
  dynamic activationCode;
  String? recipientEmail;
  String? recipientMobile;
  VoucherGiftedBy? giftedBy;
}

class VoucherGiftedBy {
  VoucherGiftedBy({
    this.name,
    this.email,
    this.phone,});

  VoucherGiftedBy.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }
  String? name;
  String? email;
  String? phone;

}
