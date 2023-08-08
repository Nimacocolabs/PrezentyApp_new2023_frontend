class TransactionHistoryResponse {
  int? statusCode;
  TransactionHistoryData? data;
  String? message;
  bool? success;

  TransactionHistoryResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success});

  TransactionHistoryResponse.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? TransactionHistoryData.fromJson(json['data']) : null;
    success = json['success'];
  }

}


class TransactionHistoryData {
  String? code;
  String? message;
  // List<dynamic>? messages;
  String? refno;
  List<Cards>? cards;
  int? store;
  Provider? provider;
  int? responseCode;

  TransactionHistoryData({
      this.code, 
      this.message, 
      // this.messages,
      this.refno, 
      this.cards, 
      this.store, 
      this.provider, 
      this.responseCode});

  TransactionHistoryData.fromJson(dynamic json) {
    // code = '${json['code']}';
    message = json['message'];
    // if (json['messages'] != null) {
    //   messages = [];
    //   json['messages'].forEach((v) {
    //     messages?.add(dynamic.fromJson(v));
    //   });
    // }
    refno = json['refno'];
    if (json['cards'] != null) {
      cards = [];
      json['cards'].forEach((v) {
        cards?.add(Cards.fromJson(v));
      });
    }
    store = json['store'];
    provider = json['provider'] != null ? Provider.fromJson(json['provider']) : null;
    responseCode = json['responseCode'];
  }

}

class Provider {
  String? code;
  String? message;

  Provider({
      this.code, 
      this.message});

  Provider.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
  }

}

class Cards {
  String? cardNumber;
  String? currencyNumericCode;
  int? balance;
  String? status;
  String? expiryDate;
  List<Transactions>? transactions;
  String? activationDate;

  Cards({
      this.cardNumber, 
      this.currencyNumericCode, 
      this.balance, 
      this.status, 
      this.expiryDate, 
      this.transactions, 
      this.activationDate});

  Cards.fromJson(dynamic json) {
    cardNumber = json['cardNumber'];
    currencyNumericCode = json['currencyNumericCode'];
    balance = json['balance'];
    status = json['status'];
    expiryDate = json['expiryDate'];
    if (json['Transactions'] != null) {
      transactions = [];
      json['Transactions'].forEach((v) {
        transactions?.add(Transactions.fromJson(v));
      });
    }
    activationDate = json['activationDate'];
  }

}

class Transactions {
  String? type;
  int? amount;
  int? balance;
  String? status;
  String? currencyNumericCode;
  String? outletName;
  String? invoiceNumber;
  String? date;
  String? notes;
  AdditionalTxnFields? additionalTxnFields;

  Transactions({
      this.type, 
      this.amount, 
      this.balance, 
      this.status, 
      this.currencyNumericCode, 
      this.outletName, 
      this.invoiceNumber, 
      this.date, 
      this.notes, 
      this.additionalTxnFields});

  Transactions.fromJson(dynamic json) {
    type = json['type'];
    amount = json['amount'];
    balance = json['balance'];
    status = json['status'];
    currencyNumericCode = json['currencyNumericCode'];
    outletName = json['outletName'];
    invoiceNumber = json['invoiceNumber'];
    date = json['date'];
    notes = json['notes'];
    additionalTxnFields = json['additionalTxnFields'] != null ? AdditionalTxnFields.fromJson(json['additionalTxnFields']) : null;
  }

}

class AdditionalTxnFields {
  int? adjustmentAmount;
  String? approvalCode;
  int? batchNumber;
  String? businessReferenceNumber;
  String? currencyCode;
  String? currencySymbol;
  dynamic errorCode;
  dynamic extendedParameters;
  int? loyalty;
  int? originalXactionReference;
  String? outletCode;
  String? pGReferenceNumber;
  dynamic reason;
  int? responseCode;
  String? responseMessage;
  int? transactionId;
  String? userName;
  int? xactionReference;

  AdditionalTxnFields({
      this.adjustmentAmount, 
      this.approvalCode, 
      this.batchNumber, 
      this.businessReferenceNumber, 
      this.currencyCode, 
      this.currencySymbol, 
      this.errorCode, 
      this.extendedParameters, 
      this.loyalty, 
      this.originalXactionReference, 
      this.outletCode, 
      this.pGReferenceNumber, 
      this.reason, 
      this.responseCode, 
      this.responseMessage, 
      this.transactionId, 
      this.userName, 
      this.xactionReference});

  AdditionalTxnFields.fromJson(dynamic json) {
    adjustmentAmount = json['AdjustmentAmount'];
    approvalCode = json['ApprovalCode'];
    batchNumber = json['BatchNumber'];
    businessReferenceNumber = json['BusinessReferenceNumber'];
    currencyCode = json['CurrencyCode'];
    currencySymbol = json['CurrencySymbol'];
    errorCode = json['ErrorCode'];
    extendedParameters = json['ExtendedParameters'];
    loyalty = json['Loyalty'];
    originalXactionReference = json['OriginalXactionReference'];
    outletCode = json['OutletCode'];
    pGReferenceNumber = json['PGReferenceNumber'];
    reason = json['Reason'];
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    transactionId = json['TransactionId'];
    userName = json['UserName'];
    xactionReference = json['XactionReference'];
  }

}