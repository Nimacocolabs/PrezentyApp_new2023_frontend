// To parse this JSON data, do
//
//     final walletStatementResponse = walletStatementResponseFromJson(jsonString);

import 'dart:convert';

WalletStatementResponse walletStatementResponseFromJson(String str) =>
    WalletStatementResponse.fromJson(json.decode(str));

class WalletStatementResponse {
  WalletStatementResponse({
    this.statusCode,
    // this.responseCode,
    this.success,
    this.message,
    this.data,
  });

  int? statusCode;

  //String? responseCode;
  bool? success;
  String? message;
  Data? data;

  factory WalletStatementResponse.fromJson(dynamic json) =>
      WalletStatementResponse(
        statusCode: json["statusCode"],
        //  responseCode: json["responseCode"],
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.transactionStatus,
    this.transactionDescription,
    this.count,
    this.balance,
    this.statement,
  });

  String? transactionStatus;
  String? transactionDescription;
  Count? count;
  Balance? balance;
  List<Statement>? statement;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactionStatus: json["transactionStatus"],
        transactionDescription: json["transactionDescription"],
        count: Count.fromJson(json["count"]),
        balance: Balance.fromJson(json["balance"]),
        statement: json["statement"] != null
            ? List<Statement>.from(
                json["statement"].map((x) => Statement.fromJson(x)))
            : [],
      );
}

class Balance {
  Balance({
    this.openingBalance,
    this.closingBalance,
  });

  double? openingBalance;
  double? closingBalance;

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        openingBalance: json["openingBalance"].toDouble(),
        closingBalance: json["closingBalance"].toDouble(),
      );
}

class Count {
  Count({
    this.total,
    this.credit,
    this.debit,
  });

  int? total;
  int? credit;
  int? debit;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        total: json["total"],
        credit: json["credit"],
        debit: json["debit"],
      );
}

class Statement {
  Statement({
    this.timestamp,
    this.description,
    this.bankReferenceNumber,
    this.transactionId,
    this.type,
    this.amount,
    this.providerFee,
    this.openingBalance,
    this.closingBalance,
    this.beneficiaryCode,
    this.sender,
    this.recipient,
    this.transactionType,
    this.transferType,
    this.status,
  });

  DateTime? timestamp;
  String? description;
  String? bankReferenceNumber;
  String? transactionId;
  String? type;
  double? amount;
  int? providerFee;
  double? openingBalance;
  double? closingBalance;
  String? beneficiaryCode;
  String? sender;
  String? recipient;
  String? transactionType;
  String? transferType;
  String? status;

  factory Statement.fromJson(Map<String, dynamic> json) => Statement(
        timestamp: DateTime.parse(json["timestamp"]),
        description: json["description"],
        bankReferenceNumber: json["bankReferenceNumber"] == null
            ? null
            : json["bankReferenceNumber"],
        transactionId: json["transactionId"],
        type: json["type"],
        amount: json["amount"].toDouble(),
        providerFee: json["providerFee"],
        openingBalance: json["openingBalance"].toDouble(),
        closingBalance: json["closingBalance"].toDouble(),
        beneficiaryCode: json["beneficiaryCode"],
        sender: json["sender"],
        recipient: json["recipient"],
        transactionType: json["transactionType"],
        transferType: json["transferType"],
        status: json["status"],
      );
}
