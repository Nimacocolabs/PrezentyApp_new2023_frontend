class ReportOrderListResponse {
  ReportOrderListResponse({
      this.success, 
      this.message,
    this.basePathWoohooImages,
    this.statusCode,
      this.data,});

  ReportOrderListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ReportOrder.fromJson(v));
      });
    }
    basePathWoohooImages = json['base_path_woohoo_images'];
  }
  bool? success;
  String? message;
  int? statusCode;
  List<ReportOrder>? data;
  String? basePathWoohooImages;

}

class ReportOrder {
  ReportOrder({
    this.image,
    this.orders,
      this.payment, 
      this.product,});

  ReportOrder.fromJson(dynamic json) {
    image = json['image'];
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(Orders.fromJson(v));
      });
    }
    payment = json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
  String? image;
  List<Orders>? orders;
  Payment? payment;
  Product? product;

}

class Product {
  Product({
      this.id, 
      this.image, 
      this.productName,});

  Product.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    productName = json['product_name'];
  }
  int? id;
  String? image;
  String? productName;
}

class Payment {
  Payment({
    this.invNo,
    this.id,
      this.amount, 
      this.status, 
      this.createdAt,});

  Payment.fromJson(dynamic json) {
    invNo = json['inv_no_id'];
    id = json['id'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
  }
  String? invNo;
  int? id;
  String? amount;
  String? status;
  String? createdAt;

}

class Orders {
  Orders({
      this.id,
      this.amount, 
      this.status, 
      this.cardNo, 
      this.cardPin,
      this.validity, 
      this.createdAt, 
      this.issueDate, 
      this.activationUrl, 
      this.recipientName, 
      this.activationCode, 
      this.recipientEmail, 
      this.recipientMobile,});

  Orders.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    status = json['status'];
    cardNo = json['card_no'];
    cardPin = json['card_pin'];
    validity = json['validity'];
    createdAt = json['created_at'];
    issueDate = json['issue_date'];
    activationUrl = json['activation_url'];
    recipientName = json['recipient_name'];
    activationCode = json['activation_code'];
    recipientEmail = json['recipient_email'];
    recipientMobile = json['recipient_mobile'];
  }
  int? id;
  int? amount;
  String? status;
  String? cardNo;
  String? cardPin;
  String? validity;
  String? createdAt;
  String? issueDate;
  dynamic activationUrl;
  String? recipientName;
  dynamic activationCode;
  String? recipientEmail;
  String? recipientMobile;

}