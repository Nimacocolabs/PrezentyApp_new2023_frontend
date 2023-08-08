class SendSmsEmailAccountVerificationSignupModel {
  SendSmsEmailAccountVerificationSignupModel({
      this.success, 
      this.statusCode, 
      this.data,});

  SendSmsEmailAccountVerificationSignupModel.fromJson(dynamic json) {
    success = json['success'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? SendSmsEmailAccountVerificationSignupData.fromJson(json['data']) : null;
  }
  bool? success;
  int? statusCode;
  SendSmsEmailAccountVerificationSignupData? data;

 

}

class SendSmsEmailAccountVerificationSignupData {
  SendSmsEmailAccountVerificationSignupData({
      this.otpToken, 
      this.mailToken, 
      this.mailType,});

  SendSmsEmailAccountVerificationSignupData.fromJson(dynamic json) {
    otpToken = json['otp_token'];
    mailToken = json['mail_token'];
    mailType = json['mailType'];
  }
  int? otpToken;
  int? mailToken;
  String? mailType;



}