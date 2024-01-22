class OrderModel {
  String? orderId;
  String? amount;
  String? convertedAmount;
  int? statusCode;
  String? cardId;
  String? message;
  bool? success;

  OrderModel(
      {this.orderId,
        this.amount,
        this.convertedAmount,
        this.statusCode,
        this.cardId,
        this.message,
        this.success});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    convertedAmount = json['convertedAmount'];
    statusCode = json['statusCode'];
    cardId = json['card_id'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['convertedAmount'] = this.convertedAmount;
    data['statusCode'] = this.statusCode;
    data['card_id'] = this.cardId;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

