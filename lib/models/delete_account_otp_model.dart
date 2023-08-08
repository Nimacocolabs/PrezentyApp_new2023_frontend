class DeleteAccountOtpModel {
  DeleteAccountOtpModel({
      this.success, 
      this.statusCode, 
      this.data,});

  DeleteAccountOtpModel.fromJson(dynamic json) {
    success = json['success'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? DeleteAccountOtpData.fromJson(json['data']) : null;
  }
  bool? success;
  int? statusCode;
  DeleteAccountOtpData? data;
}

class DeleteAccountOtpData {
  DeleteAccountOtpData({
      this.mailToken, 
      this.mailType,});

  DeleteAccountOtpData.fromJson(dynamic json) {
    mailToken = json['mail_token'];
    mailType = json['mailType'];
  }
  int? mailToken;
  String? mailType;



}