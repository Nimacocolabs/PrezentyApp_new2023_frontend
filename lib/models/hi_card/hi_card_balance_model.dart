class HiCardBalanceModel {
  HiCardBalanceModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  HiCardBalanceModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? HiCardBalanceData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  String? message;
  HiCardBalanceData? data;
}

class HiCardBalanceData {
  HiCardBalanceData(
      {this.balance, this.cardNumber, this.pinNumber, this.hiCardID,this.rfidNumber,this.serialNumber,this.hiRewardTAndC});

  HiCardBalanceData.fromJson(dynamic json) {
    balance = json['balance'];
    cardNumber = json['card_number'];
    pinNumber = json['pin_number'];
    hiCardID = json['hi_card_id'];

    rfidNumber = json['RFID_number'];
    serialNumber = json['serial_number'];
     hiRewardTAndC = json['terms_hicard'];
  }
  int? balance;
  String? cardNumber;
  int? pinNumber;
  int? hiCardID;
  String? rfidNumber;
  String? serialNumber;
  String? hiRewardTAndC;
}
