class CheckIsMobileEmailVerifiedResponse {
  CheckIsMobileEmailVerifiedResponse({
      this.success, 
      this.statusCode, 
      this.data,});

  CheckIsMobileEmailVerifiedResponse.fromJson(dynamic json) {
    success = json['success'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? CheckIsMobileEmailVerifiedData.fromJson(json['data']) : null;
  }
  bool? success;
  int? statusCode;
  CheckIsMobileEmailVerifiedData? data;

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

class CheckIsMobileEmailVerifiedData {
  CheckIsMobileEmailVerifiedData({
      this.mobileVerify, 
      this.emailVerify, 
      this.idVerify, 
      this.panNumber, 
      this.aadarNumber,});

  CheckIsMobileEmailVerifiedData.fromJson(dynamic json) {
    mobileVerify = json['mobile_verify'];
    emailVerify = json['email_verify'];
    idVerify = json['id_verify'];
    panNumber = json['pan_number'];
    aadarNumber = json['aadar_number'];
  }
  String? mobileVerify;
  String? emailVerify;
  String? idVerify;
  String? panNumber;
  String? aadarNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile_verify'] = mobileVerify;
    map['email_verify'] = emailVerify;
    map['id_verify'] = idVerify;
    map['pan_number'] = panNumber;
    map['aadar_number'] = aadarNumber;
    return map;
  }

}