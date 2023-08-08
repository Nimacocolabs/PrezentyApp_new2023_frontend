class GiftHiCardModel {
  GiftHiCardModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.insTableId,});

  GiftHiCardModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    insTableId = json['ins_table_id'];
  }
  int? statusCode;
  bool? success;
  String? message;
  int? insTableId;



}