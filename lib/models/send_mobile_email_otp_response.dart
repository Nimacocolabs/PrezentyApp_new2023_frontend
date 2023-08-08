class SendMobileEmailOtpResponse {
  SendMobileEmailOtpResponse({
      this.success, 
      this.statusCode, 
      this.data,});

  SendMobileEmailOtpResponse.fromJson(dynamic json) {
    success = json['success'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? SendMobileEmailOtpData.fromJson(json['data']) : null;
  }
  bool? success;
  int? statusCode;
  SendMobileEmailOtpData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class SendMobileEmailOtpData {
  SendMobileEmailOtpData({
      this.otpToken, 
      this.mailToken, 
      this.mailType,});

  SendMobileEmailOtpData.fromJson(dynamic json) {
    otpToken = json['otp_token'];
    mailToken = json['mail_token'];
    mailType = json['mailType'];
  }
  int? otpToken;
  int? mailToken;
  String? mailType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp_token'] = otpToken;
    map['mail_token'] = mailToken;
    map['mailType'] = mailType;
    return map;
  }

}