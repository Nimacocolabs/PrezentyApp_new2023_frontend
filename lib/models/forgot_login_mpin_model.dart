class ForgotLoginMpinModel {
  ForgotLoginMpinModel({
      this.data, 
      this.success, 
      this.statusCode, 
      this.message,});

  ForgotLoginMpinModel.fromJson(dynamic json) {
    data = json['data'] != null ? ForgotLoginMpinData.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
  }
  ForgotLoginMpinData? data;
  bool? success;
  int? statusCode;
  String? message;



}

class ForgotLoginMpinData {
  ForgotLoginMpinData({
      this.referenceId,});

  ForgotLoginMpinData.fromJson(dynamic json) {
    referenceId = json['reference_id'];
  }
  int? referenceId;


}