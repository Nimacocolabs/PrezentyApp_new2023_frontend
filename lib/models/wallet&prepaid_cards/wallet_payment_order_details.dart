// WalletPaymentOrderDetails walletPaymentOrderDetails(String str) =>
//     WalletPaymentOrderDetails.fromJson(json.decode(str));

class WalletPaymentOrderDetails {
  WalletPaymentOrderDetails(
      {this.orderId,
        this.amount,
        this.convertedAmount,
        this.couponCode,
        this.discountAmount,
        this.couponValue,
        this.statusCode,
        this.message,
        this.success});

  String? orderId;
  String? amount;
  String? convertedAmount;
  String? couponCode;
  dynamic discountAmount;
  String? couponValue;
  int? statusCode;
  String? message;
  bool? success;

  WalletPaymentOrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    convertedAmount = json['convertedAmount'];
    couponCode = json['coupon_code'];
    discountAmount = json['discount_amount'];
    couponValue = json['coupon_value'];
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
  }
}

// class Data {
//   Data({
//
//   });
//
//
//
//   Data.fromJson(Map<String, dynamic> json) {
//
//   }
// }
