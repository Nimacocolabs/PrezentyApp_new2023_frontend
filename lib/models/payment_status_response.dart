class PaymentStatusResponse {
  String? message;
  int? statusCode;
  bool? success;
  Detail? detail;

  PaymentStatusResponse({
      this.message, 
      this.statusCode, 
      this.success, 
      this.detail});

  PaymentStatusResponse.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;
  }
}

class Detail {
  int? id;
  String? decentroTxnId;
  int? participantId;
  int? userId;
  String? voucherType;
  String? amount;
  String? referenceId;
  int? eventId;
  String? status;
  String? transactionStatusDescription;
  String? bankReferenceNumber;
  String? npciTxnId;
  String? createdAt;

  Detail({
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
      this.createdAt});

  Detail.fromJson(dynamic json) {
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
  }
}