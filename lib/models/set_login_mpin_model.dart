class SetLoginMpinModel {
  SetLoginMpinModel({
      this.message, 
      this.statusCode, 
      this.success,});

  SetLoginMpinModel.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
  }
  String? message;
  int? statusCode;
  bool? success;



}