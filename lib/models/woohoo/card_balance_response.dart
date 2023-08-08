class CardBalanceResponse {
  int? statusCode;
  CardBalanceData? data;
  bool? success;
  String? message;

  CardBalanceResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success});

  CardBalanceResponse.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? CardBalanceData.fromJson(json['data']) : null;
    success = json['success'];
  }

}


class CardBalanceData {
  String? cardNumber;
  String? balance;
  String? expiry;
  String? status;
  Currency? currency;
  AdditionalTxnFields? additionalTxnFields;

  CardBalanceData({
      this.cardNumber, 
      this.balance, 
      this.expiry, 
      this.status, 
      this.currency, 
      this.additionalTxnFields});

  CardBalanceData.fromJson(dynamic json) {
    cardNumber = json['cardNumber'];
    balance = json['balance'];
    expiry = json['expiry'];
    status = json['status'];
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    additionalTxnFields = json['additionalTxnFields'] != null ? AdditionalTxnFields.fromJson(json['additionalTxnFields']) : null;
  }
}

class AdditionalTxnFields {
  dynamic extendedParameters;
  String? responseCode;

  AdditionalTxnFields({
      this.extendedParameters, 
      this.responseCode});

  AdditionalTxnFields.fromJson(dynamic json) {
    extendedParameters = json['extendedParameters'];
    responseCode = json['responseCode'].toString();
  }
}

class Currency {
  String? code;
  String? numericCode;
  String? symbol;
  String? countryName;
  String? currencyName;

  Currency({
      this.code, 
      this.numericCode, 
      this.symbol, 
      this.countryName, 
      this.currencyName});

  Currency.fromJson(dynamic json) {
    code = json['code'];
    numericCode = json['numericCode'];
    symbol = json['symbol'];
    countryName = json['countryName'];
    currencyName = json['currencyName'];
  }
}