class UpgradeCouponTaxInfo {
  UpgradeCouponTaxInfo({
      this.statusCode, 
      this.success, 
      this.data,});

  UpgradeCouponTaxInfo.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? UpgradeCouponTaxResponse.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  UpgradeCouponTaxResponse? data;



}

class UpgradeCouponTaxResponse {
  UpgradeCouponTaxResponse({
      this.cardId, 
      this.amount, 
      this.gst, 
      this.payableAmount, 
      this.discountPrice,});

  UpgradeCouponTaxResponse.fromJson(dynamic json) {
    cardId = json['card_id'];
    amount = json['amount'];
    gst = json['gst'];
    payableAmount = json['payable_amount'];
    discountPrice = json['discount_price'];
  }
  String? cardId;
  int? amount;
  int? gst;
  String? payableAmount;
  String? discountPrice;



}