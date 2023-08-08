class TouchPointsEarningHistoryModel {
  TouchPointsEarningHistoryModel({
      this.statusCode, 
      this.success, 
      this.data,});

  TouchPointsEarningHistoryModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TPEarningHistoryResponse.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<TPEarningHistoryResponse>? data;



}

class TPEarningHistoryResponse {
  TPEarningHistoryResponse({
      this.id, 
      this.userId, 
      this.transactionAmount, 
      this.earnPoints, 
      this.earnDate, 
      this.paymentId, 
      this.description, 
      this.createdAt, 
      this.updatedAt,});

  TPEarningHistoryResponse.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    transactionAmount = json['transaction_amount'];
    earnPoints = json['earn_points'];
    earnDate = json['earn_date'];
    paymentId = json['payment_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? userId;
  String? transactionAmount;
  String? earnPoints;
  String? earnDate;
  dynamic paymentId;
  String? description;
  String? createdAt;
  String? updatedAt;



}