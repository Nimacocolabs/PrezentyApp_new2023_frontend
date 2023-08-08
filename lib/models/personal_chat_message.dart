
import 'package:event_app/util/chat_data.dart';
import 'package:event_app/util/date_helper.dart';

class ChatMessageListResponse {
  int? statusCode;
  List<ChatMessage>? list;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  String? message;
  bool? success;

  ChatMessageListResponse({
      this.statusCode, 
      this.list, 
      this.page, 
      this.perPage, 
      this.hasNextPage, 
      this.totalCount, 
      this.message, 
      this.success});

  ChatMessageListResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(ChatMessage.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totalCount = json['totalCount'];
    message = json['message'];
    success = json['success'];
  }

}

class ChatMessage {
  int? id;
  int? eventId;
  String? senderEmail;
  String? receiverEmail;
  String? date;
  String? time;
  String? message;
  int? status;
  String? createdAt;
  String? modifiedAt;

  DateTime? dateTime;
  String? displayTime;

  ChatMessage({
      this.id, 
      this.eventId, 
      this.senderEmail, 
      this.receiverEmail, 
      this.date, 
      this.time, 
      this.message, 
      this.status, 
      this.createdAt, 
      this.modifiedAt,
  this.dateTime,
    this.displayTime
  });

  ChatMessage.fromJson(dynamic json) {
    id = json['id'];
    eventId = json['event_id'];
    senderEmail = json['sender_email'];
    receiverEmail = json['receiver_email'];
    date = json['date'];
    time = json['time'];
    message = json['message']??'';
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];

    dateTime = DateHelper.getDateTime('${this.date} ${this.time}');
    displayTime = DateHelper.formatDateTime(this.dateTime!, 'dd-MMM-yyyy hh:mm a');
  }

  ChatMessage.fromNotificationJson(dynamic json) {
    id = json['id'];
    eventId = int.parse(json['event_id']);
    senderEmail = json['sender_email'];
    receiverEmail = ChatData.chatUserEmail;
    date = json['date'];
    time = json['time'];
    message = json['value']??'';

    dateTime = DateHelper.getDateTime('$date $time');
    displayTime = DateHelper.formatDateTime(dateTime!, 'dd-MMM-yyyy hh:mm a');
  }

}