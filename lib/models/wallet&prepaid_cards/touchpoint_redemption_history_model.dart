class TouchPointsRedemptionHistoryModel {
  TouchPointsRedemptionHistoryModel({
      this.statusCode, 
      this.success, 
      this.data,});

  TouchPointsRedemptionHistoryModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TPRedemptionResponse.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<TPRedemptionResponse>? data;


}

class TPRedemptionResponse {
  TPRedemptionResponse({
      this.touchPoint, 
      this.productName, 
      this.payAmount, 
      this.totalPaidAmount, 
      this.createdAt,});

  TPRedemptionResponse.fromJson(dynamic json) {
    touchPoint = json['touch_point'];
    productName = json['product_name'];
    payAmount = json['pay_amount'];
    totalPaidAmount = json['total_paid_amount'];
    createdAt = json['created_at'];
  }
  String? touchPoint;
  String? productName;
  dynamic payAmount;
  dynamic totalPaidAmount;
  String? createdAt;

 

}