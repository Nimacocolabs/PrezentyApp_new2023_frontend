class ReferralCodeModel {
  ReferralCodeModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.referealCode, 
      this.referalTouchpoint,
      this.title,
      });

  ReferralCodeModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    referealCode = json['refereal_code'];
    referalTouchpoint = json['referal_touchpoint'];
    title = json['title'];
  }
  int? statusCode;
  bool? success;
  String? message;
  String? referealCode;
  int? referalTouchpoint;
  String? title;


}