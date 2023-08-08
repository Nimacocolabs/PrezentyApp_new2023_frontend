class CoinTransferHistoryModel {
  CoinTransferHistoryModel({
      this.statusCode, 
      this.success, 
      this.data,});

  CoinTransferHistoryModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CoinTransferHistoryData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<CoinTransferHistoryData>? data;

}

class CoinTransferHistoryData {
  CoinTransferHistoryData({
      this.id, 
      this.eventId,
      this.userId, 
      this.amount, 
      this.comment, 
      this.createdAt, 
      this.updatedAt, 
      this.balance, 
      this.status,});

  CoinTransferHistoryData.fromJson(dynamic json) {
  eventId = json['event_id'];
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    balance = json['balance'];
    status = json['status'];
  }
  int? eventId;
  int? id;
  int? userId;
  String? amount;
  String? comment;
  String? createdAt;
  dynamic updatedAt;
  String? balance;
  String? status;


}