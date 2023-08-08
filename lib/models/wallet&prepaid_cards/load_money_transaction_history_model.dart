class LoadMoneyTransactionHistoryModel {
  LoadMoneyTransactionHistoryModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  LoadMoneyTransactionHistoryModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(LoadMoneyTransactionHistoryData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<LoadMoneyTransactionHistoryData>? data;

 

}

class LoadMoneyTransactionHistoryData {
  LoadMoneyTransactionHistoryData({
      this.amount, 
      this.type, 
      this.walletNumber, 
      this.status, 
      this.decentroTxnId, 
      this.transactionDate,
      this.eventId,
      this.description,
      });

  LoadMoneyTransactionHistoryData.fromJson(dynamic json) {
    amount = json['amount'];
    type = json['type'];
    walletNumber = json['wallet_number'];
    status = json['Status'];
    decentroTxnId = json['decentroTxnId'];
    transactionDate = json['transaction_date'];
    eventId = json['event_id'];
   description = json['description'];
  }
  String? amount;
  String? type;
  dynamic walletNumber;
  dynamic status;
  String? decentroTxnId;
  String? transactionDate;
  String? eventId;
  String? description;


}