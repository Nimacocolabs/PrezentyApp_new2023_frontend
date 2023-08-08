class GetCurrentDateAndTimeModel {
  GetCurrentDateAndTimeModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  GetCurrentDateAndTimeModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }
  int? statusCode;
  bool? success;
  String? message;
  String? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}