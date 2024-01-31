class WoohooCreateOrderResponse {
  int? statusCode;
  WoohooCreateOrderData? data;
  bool? success;

  WoohooCreateOrderResponse({
    this.statusCode,
    this.data,
    this.success});

  WoohooCreateOrderResponse.fromJson(dynamic json) {
    statusCode = json-['statusCode'];
    data = json['data'] != null ? WoohooCreateOrderData.fromJson(json['data']) : null;
    success = json['success'];
  }

}


class WoohooCreateOrderData {
  String? status;
  String? orderId;
  String? refno;
  Map? cancel;
  Map? curreny;
  Map? payment;

  int? code;
  String? message;


  WoohooCreateOrderData({
    this.code,
    this.message,

    this.status,
    this.cancel,
    this.curreny,
    this.orderId,
    this.payment,
    this.refno,
  });

  WoohooCreateOrderData.fromJson(dynamic json) {
    code = json["code"];
    message = json["message"];

    status = json["status"];
    cancel = json["cancel"];
    curreny = json["curreny"];
    orderId = json["orderId"];
    refno = json["refno"];
    payment = json["payment"];
  }
}
