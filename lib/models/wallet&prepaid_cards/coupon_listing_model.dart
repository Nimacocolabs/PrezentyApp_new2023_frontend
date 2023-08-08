class CouponListingModel {
  CouponListingModel({
      this.statusCode, 
      this.success, 
      this.data,});

  CouponListingModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CouponListingResponse.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<CouponListingResponse>? data;


}

class CouponListingResponse {
  CouponListingResponse({
      this.couponCode, 
      this.couponvalue, 
      this.expiresOn, 
     // this.saveamount,
      });

  CouponListingResponse.fromJson(dynamic json) {
    couponCode = json['coupon_code'];
    couponvalue = json['couponvalue'];
    expiresOn = json['expires_on'];
    //saveamount = json['saveamount'];
  }
  String? couponCode;
  String? couponvalue;
  String? expiresOn;
  //String? saveamount;


}