class RedeemOrderResponse {
  RedeemOrderResponse({
      this.statusCode, 
      this.redeemId, 
      this.message, 
      this.success,});

  RedeemOrderResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    redeemId = json['redeem_id'];
    message = json['message'];
    success = json['success'];
  }
  int? statusCode;
  int? redeemId;
  String? message;
  bool? success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['redeem_id'] = redeemId;
    map['message'] = message;
    map['success'] = success;
    return map;
  }

}