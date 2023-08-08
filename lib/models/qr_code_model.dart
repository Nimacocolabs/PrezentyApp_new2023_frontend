class QrCodeModel {
  QrCodeModel({
      this.message, 
      this.statusCode, 
      this.success, 
      this.data,});

  QrCodeModel.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? WalletPaymentUpiResponse.fromJson(json['data']) : null;
  }
  String? message;
  int? statusCode;
  bool? success;
  WalletPaymentUpiResponse? data;


}

class WalletPaymentUpiResponse {
  WalletPaymentUpiResponse({
     this.encodedDynamicQrCode, 
      this.upiUri, 
      this.insTableId,});

  WalletPaymentUpiResponse.fromJson(dynamic json) {
    encodedDynamicQrCode = json['encodedDynamicQrCode'];
    upiUri = json['upiUri'];
    insTableId = json['ins_table_id'];
  }
  String? encodedDynamicQrCode;
  String? upiUri;
  int? insTableId;


}