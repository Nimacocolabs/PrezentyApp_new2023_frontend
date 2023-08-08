class SpinVoucherListResponse {
  SpinVoucherListResponse({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  SpinVoucherListResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SpinVoucherData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<SpinVoucherData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SpinVoucherData {
  SpinVoucherData({
      this.id, 
      this.email, 
      this.spinId, 
      this.spinType, 
      this.phoneNumber, 
      this.spinDate, 
      this.touchPoint, 
      this.couponCode, 
      this.voucherPayment, 
      this.voucherStatus, 
      this.orderId, 
      this.createdAt, 
      this.updatedAt, 
      this.status, 
      this.title, 
      this.shortDescription, 
      this.targetAmount, 
      this.discountAmount, 
      this.type, 
      this.typeId,
      
      });

  SpinVoucherData.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    spinId = json['spin_id'];
    spinType = json['spin_type'];
    phoneNumber = json['phone_number'];
    spinDate = json['spin_date'];
    touchPoint = json['touch_point'];
    couponCode = json['coupon_code'];
    voucherPayment = json['voucher_payment'];
    voucherStatus = json['voucher_status'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    title = json['title'];
    shortDescription = json['short_description'];
    targetAmount = json['target_amount'];
    discountAmount = json['discount_amount'];
    type = json['type'];
    typeId = json['type_id'];
  }
  int? id;
  String? email;
  int? spinId;
  String? spinType;
  String? phoneNumber;
  String? spinDate;
  dynamic touchPoint;
  dynamic couponCode;
  dynamic voucherPayment;
  String? voucherStatus;
  dynamic orderId;
  String? createdAt;
  dynamic updatedAt;
  String? status;
  String? title;
  String? shortDescription;
  String? targetAmount;
  String? discountAmount;
  String? type;
  int? typeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['spin_id'] = spinId;
    map['spin_type'] = spinType;
    map['phone_number'] = phoneNumber;
    map['spin_date'] = spinDate;
    map['touch_point'] = touchPoint;
    map['coupon_code'] = couponCode;
    map['voucher_payment'] = voucherPayment;
    map['voucher_status'] = voucherStatus;
    map['order_id'] = orderId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['title'] = title;
    map['short_description'] = shortDescription;
    map['target_amount'] = targetAmount;
    map['discount_amount'] = discountAmount;
    map['type'] = type;
    map['type_id'] = typeId;
    return map;
  }

}