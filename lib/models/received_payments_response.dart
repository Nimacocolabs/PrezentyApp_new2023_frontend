class ReceivedPaymentsResponse {
  int? statusCode;
  double? amount;
  List<Data>? data;
  String? message;
  bool? success;

  ReceivedPaymentsResponse({
      this.statusCode, 
      this.amount,
      this.data, 
      this.message, 
      this.success});

  ReceivedPaymentsResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    amount = double.parse(json['amount']??'0');
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  String? id;
  String? decentroTxnId;
  String? participantId;
  dynamic userId;
  String? voucherType;
  String? amount;
  String? referenceId;
  String? eventId;
  String? status;
  dynamic transactionStatusDescription;
  dynamic bankReferenceNumber;
  dynamic npciTxnId;
  String? createdAt;
  String? name;
  String? phone;
  String? email;

  Data({
      this.id, 
      this.decentroTxnId, 
      this.participantId, 
      this.userId, 
      this.voucherType, 
      this.amount, 
      this.referenceId, 
      this.eventId, 
      this.status, 
      this.transactionStatusDescription, 
      this.bankReferenceNumber, 
      this.npciTxnId, 
      this.createdAt, 
      this.name, 
      this.email,
      this.phone});

  Data.fromJson(dynamic json) {
    id = json['id'];
    decentroTxnId = json['decentroTxnId'];
    participantId = json['participant_id'];
    userId = json['user_id'];
    voucherType = json['voucher_type'];
    amount = json['amount'];
    referenceId = json['reference_id'];
    eventId = json['event_id'];
    status = json['status'];
    transactionStatusDescription = json['transaction_status_description'];
    bankReferenceNumber = json['bank_reference_number'];
    npciTxnId = json['npci_txnId'];
    createdAt = json['created_at'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

}
