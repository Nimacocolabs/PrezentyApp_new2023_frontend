class PaymentCreateUpiLinkResponse {
  String? message;
  int? statusCode;
  bool? success;
  Detail? detail;
  Map <String,dynamic>? response;

  PaymentCreateUpiLinkResponse({
      this.message, 
      this.statusCode, 
      this.success,
      this.detail,
      this.response});

  PaymentCreateUpiLinkResponse.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;

    response = json['response'];
  }
}

class Detail {
  String? encodedDynamicQrCode;
  String? upiUri;
  int? id;
  String? message;

  Detail({
      this.encodedDynamicQrCode, 
      this.upiUri, 
      this.id});

  Detail.fromJson(dynamic json) {
    message = json['message'];
    encodedDynamicQrCode = json['encodedDynamicQrCode'];
    upiUri = json['upiUri'];
    id = json['id'];
  }
}