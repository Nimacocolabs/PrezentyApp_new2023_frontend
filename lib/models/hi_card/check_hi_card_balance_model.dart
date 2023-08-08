class CheckHiCardBalanceModel {
  CheckHiCardBalanceModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  CheckHiCardBalanceModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? CheckHiCardBalanceData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  String? message;
  CheckHiCardBalanceData? data;



}

class CheckHiCardBalanceData {
  CheckHiCardBalanceData({
      this.balance,
      this.cardNumber,
      this.pinNumber,
      
      });

  CheckHiCardBalanceData.fromJson(dynamic json) {
    balance = json['balance'];
    cardNumber = json['card_number'];
    pinNumber =json['pin_number'];
  }
  int? balance;
  String? cardNumber;
  String? pinNumber;


}