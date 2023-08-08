class SpinGetNowResponse {
  SpinGetNowResponse({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  SpinGetNowResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null &&json['data'].isNotEmpty ? Data.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  String? message;
  Data? data;


}

class Data {
  Data({
      this.productId, 
      this.denomiationAmount, 
      this.discountPrice,});

  Data.fromJson(dynamic json) {
    productId = json['product_id'];
    denomiationAmount = json['denomiation_amount'];
    discountPrice = json['discount_price'];
  }
  int? productId;
  String? denomiationAmount;
  String? discountPrice;

}