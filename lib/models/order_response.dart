class OrderResponse {
  String? razorPayOrderId;
  int? tableOrderId;
  int? convertedAmount;
  int? statusCode;
  String? message;
  bool? success;
  int? eventParticipantId;

  OrderResponse({
      this.razorPayOrderId,
      this.convertedAmount, 
      this.tableOrderId,
      this.statusCode,
      this.message, 
      this.eventParticipantId,
      this.success});

  OrderResponse.fromJson(dynamic json) {
    razorPayOrderId = json["orderId"];
    tableOrderId = json["productOrderId"];
    convertedAmount = json["convertedAmount"];
    eventParticipantId = json["eventParticipantId"];
    statusCode = json["statusCode"];
    message = json["message"];
    success = json["success"];
  }

}