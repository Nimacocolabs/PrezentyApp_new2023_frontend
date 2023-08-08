class NotificationResponse {
  int? statusCode;
  List<ListItem>? list;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  int? notificationCount;
  String? message;
  bool? success;

  NotificationResponse(
      {this.statusCode,
      this.list,
      this.page,
      this.perPage,
      this.hasNextPage,
      this.totalCount,
        this.notificationCount,
      this.message,
      this.success});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new ListItem.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totalCount = json['totalCount'];
    notificationCount = json['notification_count'];
    message = json['message'];
    success = json['success'];
  }

}

class ListItem {
  int? id;
  int? eventId;
  int? participantId;
  String? type;
  int? typeId;
  String? message;
  int? status;
  String? createdAt;
  String? modifiedAt;
  String? description;
  String ? url;
  String ? imageUrl;

  ListItem(
      {this.id,
      this.eventId,
      this.participantId,
      this.type,
      this.typeId,
      this.message,
      this.status,
      this.createdAt,
      this.modifiedAt,
      this.description,
      this.url,
      this.imageUrl});

  ListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    participantId = json['participant_id'];
    type = json['type'];
    typeId = json['type_id'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    description = json['description'];
    url = json['url'];
    imageUrl = json['image_url'];
  }

}