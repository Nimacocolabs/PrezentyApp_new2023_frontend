class HiCardEarningHistoryModel {
  HiCardEarningHistoryModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  HiCardEarningHistoryModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(HiCardEarningHistoryData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<HiCardEarningHistoryData>? data;



}

class HiCardEarningHistoryData {
  HiCardEarningHistoryData({
      this.id, 
      this.hiCardId, 
      this.upiId, 
      this.eventId, 
      this.amount, 
      this.razorpayId, 
      this.description, 
      this.status, 
      this.createdAt,});

  HiCardEarningHistoryData.fromJson(dynamic json) {
    id = json['id'];
    hiCardId = json['hi_card_id'];
    upiId = json['upi_id'];
    eventId = json['event_id'];
    amount = json['amount'];
    razorpayId = json['razorpay_id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    
  }
  int? id;
  int? hiCardId;
  String? upiId;
  int? eventId;
  String? amount;
  dynamic razorpayId;
  String? description;
  String? status;
  String? createdAt;

 

}