class EventGiftsReceivedModel {
  EventGiftsReceivedModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  EventGiftsReceivedModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(EventGiftsReceivedData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<EventGiftsReceivedData>? data;


}

class EventGiftsReceivedData {
  EventGiftsReceivedData({
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
      this.woohooId, 
      this.state, 
      this.name, 
      this.phone, 
      this.email,});

  EventGiftsReceivedData.fromJson(dynamic json) {
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
    woohooId = json['woohoo_id'];
    state = json['state'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }
  int? id;
  String? decentroTxnId;
  String? participantId;
  dynamic userId;
  String? voucherType;
  String? amount;
  dynamic referenceId;
  int? eventId;
  String? status;
  dynamic transactionStatusDescription;
  dynamic bankReferenceNumber;
  dynamic npciTxnId;
  String? createdAt;
  dynamic woohooId;
  dynamic state;
  String? name;
  String? phone;
  String? email;


}