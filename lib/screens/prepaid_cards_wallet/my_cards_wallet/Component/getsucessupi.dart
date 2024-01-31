class UpiSucess {
  bool? success;
  int? statusCode;
  String? message;
  int? txnTblId;
  String? amount;
String ? decentro_txn_id;
  UpiSucess(
      {this.success,
        this.statusCode,
        this.message,
        this.txnTblId,
        this.amount,
      this.decentro_txn_id});

  UpiSucess.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    txnTblId = json['txn_tbl_id'];
    amount = json['amount'];
    decentro_txn_id = json["decentro_txn_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['txn_tbl_id'] = this.txnTblId;
    data['amount'] = this.amount;
    data["decentro_txn_id"]= this.decentro_txn_id;
    return data;
  }
}