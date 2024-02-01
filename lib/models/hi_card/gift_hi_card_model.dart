class GiftHiCardModel {
  GiftHiCardModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.insTableId,
  this.decentro_txn_id});

  GiftHiCardModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    insTableId = json['ins_table_id'];
    decentro_txn_id = json["decentro_txn_id"];
  }
  int? statusCode;
  bool? success;
  String? message;
  int? insTableId;
  String?decentro_txn_id;



}