class AuthenticateLoginMpinModel {
  AuthenticateLoginMpinModel({
      this.message, 
      this.statusCode, 
      this.success, 
      this.data,});

  AuthenticateLoginMpinModel.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? AuthenticateLoginMpinData.fromJson(json['data']) : null;
  }
  String? message;
  int? statusCode;
  bool? success;
  AuthenticateLoginMpinData? data;



}

class AuthenticateLoginMpinData {
  AuthenticateLoginMpinData({
      this.accountId, 
      this.kycVerified,});

  AuthenticateLoginMpinData.fromJson(dynamic json) {
    accountId = json['account_id'];
    kycVerified = json['kyc_verified'];
  }
  int? accountId;
  bool? kycVerified;


}