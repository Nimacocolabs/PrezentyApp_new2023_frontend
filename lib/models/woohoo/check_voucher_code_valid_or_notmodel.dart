class CheckVoucherCodeValidOrNotmodel {
  CheckVoucherCodeValidOrNotmodel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.offer,});

  CheckVoucherCodeValidOrNotmodel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    offer = json['offer'];
  }
  int? statusCode;
  bool? success;
  String? message;
  String? offer;



}