class OrderStatusResponse {
  int? statusCode;
  OrderStatusData? data;
  String? message;
  bool? success;

  int? code;


  OrderStatusResponse({
    this.code,
    this.statusCode,
    this.data,
    this.message,
    this.success});

  OrderStatusResponse.fromJson(dynamic json) {
    code = json['code'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = OrderStatusData.fromJson(json['data']);
    }
    message = json['message'];
    success = json['success'];
  }

}

  class OrderStatusData {
  String? status;
  String? statusLabel;
  String? orderId;
  String? refno;

  OrderStatusData({
      this.status, 
      this.statusLabel, 
      this.orderId, 
      this.refno });

  OrderStatusData.fromJson(dynamic json) {
    status = json['status'];
    statusLabel = json['statusLabel'];
    orderId = json['orderId'];
    refno = json['refno'];
  }

}