class PaymentTaxResponse {
  PaymentTaxResponse({
      this.statusCode, 
      this.amount,
      this.orderId,
      this.data, 
      this.message, 
      this.success,
      this.insTableId,
  }
  );

  PaymentTaxResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    amount = json['amount'].toString();
    orderId = json['order_id'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TaxData.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
    insTableId = json['ins_table_id'];
  }
  int? statusCode;
  String? amount;
  int? orderId;
  List<TaxData>? data;
  String? message;
  bool? success;
  int? insTableId;

}

class TaxData {
  TaxData({
      this.key, 
      this.value,});

  TaxData.fromJson(dynamic json) {
    key = json['key'];
    value = json['value'];
  }
  String? key;
  String? value;
}