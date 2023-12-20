// To parse this JSON data, do
//
//     final walletStatementResponse = walletStatementResponseFromJson(jsonString);

import 'dart:convert';

WalletStatementResponse walletStatementResponseFromJson(String str) =>
    WalletStatementResponse.fromJson(json.decode(str));

// class WalletStatementResponse {
//   WalletStatementResponse({
//     this.statusCode,
//     // this.responseCode,
//     this.success,
//     this.message,
//     this.data,
//   });
//
//   int? statusCode;
//
//   //String? responseCode;
//   bool? success;
//   String? message;
//   Data? data;
//
//   factory WalletStatementResponse.fromJson(dynamic json) =>
//       WalletStatementResponse(
//         statusCode: json["statusCode"],
//         //  responseCode: json["responseCode"],
//         success: json["success"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//       );
// }
//
// class Data {
//   Data({
//     this.transactionStatus,
//     this.transactionDescription,
//     this.count,
//     this.balance,
//     this.statement,
//   });
//
//   String? transactionStatus;
//   String? transactionDescription;
//   Count? count;
//   Balance? balance;
//   List<Statement>? statement;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         transactionStatus: json["transactionStatus"],
//         transactionDescription: json["transactionDescription"],
//         count: Count.fromJson(json["count"]),
//         balance: Balance.fromJson(json["balance"]),
//         statement: json["statement"] != null
//             ? List<Statement>.from(
//                 json["statement"].map((x) => Statement.fromJson(x)))
//             : [],
//       );
// }
//
// class Balance {
//   Balance({
//     this.openingBalance,
//     this.closingBalance,
//   });
//
//   double? openingBalance;
//   double? closingBalance;
//
//   factory Balance.fromJson(Map<String, dynamic> json) => Balance(
//         openingBalance: json["openingBalance"].toDouble(),
//         closingBalance: json["closingBalance"].toDouble(),
//       );
// }
//
// class Count {
//   Count({
//     this.total,
//     this.credit,
//     this.debit,
//   });
//
//   int? total;
//   int? credit;
//   int? debit;
//
//   factory Count.fromJson(Map<String, dynamic> json) => Count(
//         total: json["total"],
//         credit: json["credit"],
//         debit: json["debit"],
//       );
// }
//
// class Statement {
//   Statement({
//     this.timestamp,
//     this.description,
//     this.bankReferenceNumber,
//     this.transactionId,
//     this.type,
//     this.amount,
//     this.providerFee,
//     this.openingBalance,
//     this.closingBalance,
//     this.beneficiaryCode,
//     this.sender,
//     this.recipient,
//     this.transactionType,
//     this.transferType,
//     this.status,
//   });
//
//   DateTime? timestamp;
//   String? description;
//   String? bankReferenceNumber;
//   String? transactionId;
//   String? type;
//   double? amount;
//   int? providerFee;
//   double? openingBalance;
//   double? closingBalance;
//   String? beneficiaryCode;
//   String? sender;
//   String? recipient;
//   String? transactionType;
//   String? transferType;
//   String? status;
//
//   factory Statement.fromJson(Map<String, dynamic> json) => Statement(
//         timestamp: DateTime.parse(json["timestamp"]),
//         description: json["description"],
//         bankReferenceNumber: json["bankReferenceNumber"] == null
//             ? null
//             : json["bankReferenceNumber"],
//         transactionId: json["transactionId"],
//         type: json["type"],
//         amount: json["amount"].toDouble(),
//         providerFee: json["providerFee"],
//         openingBalance: json["openingBalance"].toDouble(),
//         closingBalance: json["closingBalance"].toDouble(),
//         beneficiaryCode: json["beneficiaryCode"],
//         sender: json["sender"],
//         recipient: json["recipient"],
//         transactionType: json["transactionType"],
//         transferType: json["transferType"],
//         status: json["status"],
//       );
// }
class WalletStatementResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<Transactions>? transactions;
  Pagination? pagination;

  WalletStatementResponse(
      {this.success,
        this.statusCode,
        this.message,
        this.transactions,
        this.pagination});

  WalletStatementResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Transactions {
  Transaction? transaction;
  Null? balance;

  Transactions({this.transaction, this.balance});

  Transactions.fromJson(Map<String, dynamic> json) {
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    data['balance'] = this.balance;
    return data;
  }
}

class Transaction {
  String? amount;
  int? balance;
  String? transactionType;
  String? type;
  String? time;
  int? txRef;
  Null? businessId;
  String? beneficiaryName;
  Null? beneficiaryType;
  String? beneficiaryId;
  String? description;
  String? otherPartyName;
  String? otherPartyId;
  String? txnOrigin;
  String? transactionStatus;
  Null? status;
  String? yourWallet;
  Null? yourWalletCurrency;
  String? beneficiaryWallet;
  String? externalTransactionId;
  Null? retrivalReferenceNo;
  Null? authCode;
  Null? billRefNo;
  String? bankTid;
  Null? acquirerId;
  Null? mcc;
  int? convertedAmount;
  Null? networkType;
  Null? limitCurrencyCode;
  String? kitNo;
  Null? sorTxnId;
  Null? transactionCurrencyCode;
  Null? fxConvDetails;
  Null? convDetails;
  Null? disputedDto;
  Null? disputeRef;
  Null? accountNo;
  String? date;
  String? timeAgo;

  Transaction(
      {this.amount,
        this.balance,
        this.transactionType,
        this.type,
        this.time,
        this.txRef,
        this.businessId,
        this.beneficiaryName,
        this.beneficiaryType,
        this.beneficiaryId,
        this.description,
        this.otherPartyName,
        this.otherPartyId,
        this.txnOrigin,
        this.transactionStatus,
        this.status,
        this.yourWallet,
        this.yourWalletCurrency,
        this.beneficiaryWallet,
        this.externalTransactionId,
        this.retrivalReferenceNo,
        this.authCode,
        this.billRefNo,
        this.bankTid,
        this.acquirerId,
        this.mcc,
        this.convertedAmount,
        this.networkType,
        this.limitCurrencyCode,
        this.kitNo,
        this.sorTxnId,
        this.transactionCurrencyCode,
        this.fxConvDetails,
        this.convDetails,
        this.disputedDto,
        this.disputeRef,
        this.accountNo,
        this.date,
        this.timeAgo});

  Transaction.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    balance = json['balance'];
    transactionType = json['transactionType'];
    type = json['type'];
    time = json['time'];
    txRef = json['txRef'];
    businessId = json['businessId'];
    beneficiaryName = json['beneficiaryName'];
    beneficiaryType = json['beneficiaryType'];
    beneficiaryId = json['beneficiaryId'];
    description = json['description'];
    otherPartyName = json['otherPartyName'];
    otherPartyId = json['otherPartyId'];
    txnOrigin = json['txnOrigin'];
    transactionStatus = json['transactionStatus'];
    status = json['status'];
    yourWallet = json['yourWallet'];
    yourWalletCurrency = json['yourWalletCurrency'];
    beneficiaryWallet = json['beneficiaryWallet'];
    externalTransactionId = json['externalTransactionId'];
    retrivalReferenceNo = json['retrivalReferenceNo'];
    authCode = json['authCode'];
    billRefNo = json['billRefNo'];
    bankTid = json['bankTid'];
    acquirerId = json['acquirerId'];
    mcc = json['mcc'];
    convertedAmount = json['convertedAmount'];
    networkType = json['networkType'];
    limitCurrencyCode = json['limitCurrencyCode'];
    kitNo = json['kitNo'];
    sorTxnId = json['sorTxnId'];
    transactionCurrencyCode = json['transactionCurrencyCode'];
    fxConvDetails = json['fxConvDetails'];
    convDetails = json['convDetails'];
    disputedDto = json['disputedDto'];
    disputeRef = json['disputeRef'];
    accountNo = json['accountNo'];
    date = json['date'];
    timeAgo = json['timeAgo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['balance'] = this.balance;
    data['transactionType'] = this.transactionType;
    data['type'] = this.type;
    data['time'] = this.time;
    data['txRef'] = this.txRef;
    data['businessId'] = this.businessId;
    data['beneficiaryName'] = this.beneficiaryName;
    data['beneficiaryType'] = this.beneficiaryType;
    data['beneficiaryId'] = this.beneficiaryId;
    data['description'] = this.description;
    data['otherPartyName'] = this.otherPartyName;
    data['otherPartyId'] = this.otherPartyId;
    data['txnOrigin'] = this.txnOrigin;
    data['transactionStatus'] = this.transactionStatus;
    data['status'] = this.status;
    data['yourWallet'] = this.yourWallet;
    data['yourWalletCurrency'] = this.yourWalletCurrency;
    data['beneficiaryWallet'] = this.beneficiaryWallet;
    data['externalTransactionId'] = this.externalTransactionId;
    data['retrivalReferenceNo'] = this.retrivalReferenceNo;
    data['authCode'] = this.authCode;
    data['billRefNo'] = this.billRefNo;
    data['bankTid'] = this.bankTid;
    data['acquirerId'] = this.acquirerId;
    data['mcc'] = this.mcc;
    data['convertedAmount'] = this.convertedAmount;
    data['networkType'] = this.networkType;
    data['limitCurrencyCode'] = this.limitCurrencyCode;
    data['kitNo'] = this.kitNo;
    data['sorTxnId'] = this.sorTxnId;
    data['transactionCurrencyCode'] = this.transactionCurrencyCode;
    data['fxConvDetails'] = this.fxConvDetails;
    data['convDetails'] = this.convDetails;
    data['disputedDto'] = this.disputedDto;
    data['disputeRef'] = this.disputeRef;
    data['accountNo'] = this.accountNo;
    data['date'] = this.date;
    data['timeAgo'] = this.timeAgo;
    return data;
  }
}

class Pagination {
  bool? isList;
  int? pageSize;
  int? pageNo;
  int? totalPages;
  int? totalElements;

  Pagination(
      {this.isList,
        this.pageSize,
        this.pageNo,
        this.totalPages,
        this.totalElements});

  Pagination.fromJson(Map<String, dynamic> json) {
    isList = json['isList'];
    pageSize = json['pageSize'];
    pageNo = json['pageNo'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isList'] = this.isList;
    data['pageSize'] = this.pageSize;
    data['pageNo'] = this.pageNo;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}