class TouchPointsModel {
  TouchPointsModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.touchpoints,});

  TouchPointsModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    touchpoints = json['touchpoints'];
  }
  int? statusCode;
  bool? success;
  String? message;
  dynamic touchpoints;



}