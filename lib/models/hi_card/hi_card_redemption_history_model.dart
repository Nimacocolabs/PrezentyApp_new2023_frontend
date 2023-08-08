class HiCardRedemptionHistoryModel {
  HiCardRedemptionHistoryModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  HiCardRedemptionHistoryModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(HiCardRedemptionHistoryData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<HiCardRedemptionHistoryData>? data;



}

class HiCardRedemptionHistoryData {
  HiCardRedemptionHistoryData({
      this.id, 
      this.hiCardId, 
      this.amount, 
      this.description, 
      this.createdAt,});

  HiCardRedemptionHistoryData.fromJson(dynamic json) {
    id = json['id'];
    hiCardId = json['hi_card_id'];
    amount = json['amount'];
    description = json['description'];
    createdAt = json['created_at'];
  }
  int? id;
  int? hiCardId;
  String? amount;
  String? description;
  String? createdAt;



}