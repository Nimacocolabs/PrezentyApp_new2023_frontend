class paymentupiResponse {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  paymentupiResponse({this.success, this.statusCode, this.message, this.data});

  paymentupiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? encodedDynamicQrCode;
  String? paymentLink;
  int? txnTblId;

  Data({this.encodedDynamicQrCode, this.paymentLink, this.txnTblId});

  Data.fromJson(Map<String, dynamic> json) {
    encodedDynamicQrCode = json['encodedDynamicQrCode'];
    paymentLink = json['payment_link'];
    txnTblId = json['txn_tbl_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['encodedDynamicQrCode'] = this.encodedDynamicQrCode;
    data['payment_link'] = this.paymentLink;
    data['txn_tbl_id'] = this.txnTblId;
    return data;
  }
}