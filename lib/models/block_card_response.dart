class BlockCardResponse {
  BlockCardResponse({
      this.message, 
      this.statusCode, 
      this.success, 
      this.data,});

  BlockCardResponse.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  int? statusCode;
  bool? success;
  Data? data;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['message'] = message;
  //   map['statusCode'] = statusCode;
  //   map['success'] = success;
  //   if (data != null) {
  //     map['data'] = data?.toJson();
  //   }
  //   return map;
  // }

}

class Data {
  Data({
      this.transactionStatus, 
      this.transactionDescription,});

  Data.fromJson(dynamic json) {
    transactionStatus = json['transactionStatus'];
    transactionDescription = json['transactionDescription'];
  }
  String? transactionStatus;
  String? transactionDescription;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['transactionStatus'] = transactionStatus;
  //   map['transactionDescription'] = transactionDescription;
  //   return map;
  // }

}