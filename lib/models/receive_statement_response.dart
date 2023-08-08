class ReceiveStatementResponse {
  ReceiveStatementResponse({
      this.statusCode, 
      this.data, 
      this.message, 
      this.success,});

  ReceiveStatementResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ReceiveData.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }
  int? statusCode;
  List<ReceiveData>? data;
  String? message;
  bool? success;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['statusCode'] = statusCode;
  //   if (data != null) {
  //     map['data'] = data?.map((v) => v.toJson()).toList();
  //   }
  //   map['message'] = message;
  //   map['success'] = success;
  //   return map;
  // }

}

class ReceiveData {
  ReceiveData({
      // this.id,
      // this.decentroTxnId,
      // this.participantId,
      // this.userId,
      // this.voucherType,
      this.amount, 
      // this.referenceId,
      this.eventId, 
      // this.status,
      // this.transactionStatusDescription,
      // this.bankReferenceNumber,
      // this.npciTxnId,
      this.createdAt, 
      // this.woohooId,
      // this.state,
      this.name,});

  ReceiveData.fromJson(dynamic json) {
    //id = json['id'];
    // decentroTxnId = json['decentroTxnId'];
    // participantId = json['participant_id'];
    // userId = json['user_id'];
   // voucherType = json['voucher_type'];
    amount = json['amount'];
    //referenceId = json['reference_id'];
    eventId = json['event_id'];
  //  status = json['status'];
  //   transactionStatusDescription = json['transaction_status_description'];
  //   bankReferenceNumber = json['bank_reference_number'];
  //   npciTxnId = json['npci_txnId'];
    createdAt = json['created_at'];
    // woohooId = json['woohoo_id'];
    // state = json['state'];
    name = json['name'];
  }
  //String? id;
  // String? decentroTxnId;
  // String? participantId;
  // dynamic userId;
  // String? voucherType;
  String? amount;
  // String? referenceId;
  String? eventId;
  // String? status;
  // String? transactionStatusDescription;
  // dynamic bankReferenceNumber;
  // String? npciTxnId;
  String? createdAt;
  // String? woohooId;
  // String? state;
  String? name;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['id'] = id;
  //   map['decentroTxnId'] = decentroTxnId;
  //   map['participant_id'] = participantId;
  //   map['user_id'] = userId;
  //   map['voucher_type'] = voucherType;
  //   map['amount'] = amount;
  //   map['reference_id'] = referenceId;
  //   map['event_id'] = eventId;
  //   map['status'] = status;
  //   map['transaction_status_description'] = transactionStatusDescription;
  //   map['bank_reference_number'] = bankReferenceNumber;
  //   map['npci_txnId'] = npciTxnId;
  //   map['created_at'] = createdAt;
  //   map['woohoo_id'] = woohooId;
  //   map['state'] = state;
  //   map['name'] = name;
  //   return map;
  // }

}