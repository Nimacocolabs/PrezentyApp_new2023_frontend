class GatewayKeyResponse {
  String? apiKey;
  String? orderId;
  int? statusCode;
  String? message;
  bool? success;

  GatewayKeyResponse({
      this.apiKey, 
      this.orderId,
      this.statusCode,
      this.message, 
      this.success});

  GatewayKeyResponse.fromJson(dynamic json) {
    apiKey = json["apiKey"];
    orderId = json["orderId"];
    statusCode = json["statusCode"];
    message = json["message"];
    success = json["success"];
  }

}