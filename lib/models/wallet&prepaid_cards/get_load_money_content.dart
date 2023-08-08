class GetLoadMoneyContent {
  GetLoadMoneyContent({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  GetLoadMoneyContent.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }
  int? statusCode;
  bool? success;
  String? message;
  String? data;



}