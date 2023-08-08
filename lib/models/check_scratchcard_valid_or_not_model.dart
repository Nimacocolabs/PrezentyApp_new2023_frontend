class CheckScratchcardValidOrNotModel {
  CheckScratchcardValidOrNotModel({
      this.statusCode, 
      this.message,
      this.success, 
      this.data, 
      this.coupon,});

  CheckScratchcardValidOrNotModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
     message = json['message'];
    data = json['data'] != null ? CheckScratchcardValidOrNotData.fromJson(json['data']) : null;
    coupon = json['coupon'];
  }
  int? statusCode;
  bool? success;
  String? message;
  CheckScratchcardValidOrNotData? data;
  String? coupon;

 

}

class CheckScratchcardValidOrNotData {
 CheckScratchcardValidOrNotData({
      this.rzrPayId, 
      this.userId, 
      this.cardId,
      this.type,});

  CheckScratchcardValidOrNotData.fromJson(dynamic json) {
    rzrPayId = json['rzr_pay_id'];
    userId = json['user_id'];
    cardId = json['card_id'].toString();
    type = json['type'];
  }
  String? rzrPayId;
  String? userId;
  String? cardId;
  String? type;

 

}