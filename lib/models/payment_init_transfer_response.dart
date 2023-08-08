class PaymentInitTransferResponse {
  int? statusCode;
  int? id;
  bool? success;

  PaymentInitTransferResponse({
    this.statusCode,
    this.id,
    this.success});

  PaymentInitTransferResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    id = json['id'];
    success = json['success'];
  }

}
