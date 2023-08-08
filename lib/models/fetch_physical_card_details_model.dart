class FetchPhysicalCardDetailsModel {
  FetchPhysicalCardDetailsModel({
      this.message, 
      this.statusCode, 
      this.success, 
      this.data, 
      this.apply,});

  FetchPhysicalCardDetailsModel.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      // json['data'].forEach((v) {
      //   data?.add(Dynamic.fromJson(v));
      // });
    }
    else{
      data=null;
    }
    apply = json['apply'];
  }
  String? message;
  int? statusCode;
  bool? success;
  List? data;
  String? apply;



}