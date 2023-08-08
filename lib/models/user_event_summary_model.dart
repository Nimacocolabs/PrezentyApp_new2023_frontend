class UserEventSummaryModel {
  UserEventSummaryModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  UserEventSummaryModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserEventSummaryData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<UserEventSummaryData>? data;



}

class UserEventSummaryData {
  UserEventSummaryData({
      this.eventId, 
      this.eventName, 
      this.eventDate, 
      this.recievedAmount,});

  UserEventSummaryData.fromJson(dynamic json) {
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventDate = json['event_date'];
    recievedAmount = json['recieved_amount'];
  }
  int? eventId;
  String? eventName;
  String? eventDate;
  int? recievedAmount;


}