class UpiSucess {
  bool? success;
  int? statusCode;
  String? message;
  int? txnTblId;
  String? amount;

  UpiSucess(
      {this.success,
        this.statusCode,
        this.message,
        this.txnTblId,
        this.amount});

  UpiSucess.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    txnTblId = json['txn_tbl_id'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['txn_tbl_id'] = this.txnTblId;
    data['amount'] = this.amount;
    return data;
  }
}