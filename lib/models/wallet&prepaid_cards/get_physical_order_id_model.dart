class OrderModel {
  int? statusCode;
  bool? success;
  String? message;
  String? orderId;
  String? amount;
  String? convertedAmount;
  int? cardId;
  OrderModel(
      {this.statusCode,
      this.success,
      this.message,
      this.cardId,
      this.orderId,
      this.amount,
      this.convertedAmount});

  OrderModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    convertedAmount = json['convertedAmount'];
    orderId = json['orderId'];
    cardId = json['card_id'];
    amount = json['amount'];
  }
}