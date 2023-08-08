class CheckLoginmpinSetOrNotModel {
  CheckLoginmpinSetOrNotModel({
      this.message, 
      this.statusCode, 
      this.success, 
      this.data,});

  CheckLoginmpinSetOrNotModel.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? CheckLoginmpinSetOrNotData.fromJson(json['data']) : null;
  }
  String? message;
  int? statusCode;
  bool? success;
  CheckLoginmpinSetOrNotData? data;



}

class CheckLoginmpinSetOrNotData {
  CheckLoginmpinSetOrNotData({
      this.loginMpin,});

  CheckLoginmpinSetOrNotData.fromJson(dynamic json) {
    loginMpin = json['login_mpin'];
  }
  String? loginMpin;

}