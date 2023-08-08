class EventRelatedVouchersListModel {
  String? baseUrl;
  String? baseUrlBg;
  String? message;
  int? statusCode;
  bool? success;
  Detail? detail;
  List<Gifts>? gifts;

  EventRelatedVouchersListModel(
      {this.baseUrl,
      this.baseUrlBg,
      this.message,
      this.statusCode,
      this.success,
      this.detail,
      this.gifts});

  EventRelatedVouchersListModel.fromJson(Map<String, dynamic> json) {
    baseUrl = json['baseUrl'];
    baseUrlBg = json['baseUrlBg'];
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    if (json['Gifts'] != null) {
      gifts = [];
      json['Gifts'].forEach((v) {
        gifts?.add(new Gifts.fromJson(v));
      });
    }
  }

}

class Detail {
  int? id;
  String? title;
  String? date;
  String? time;
  String? imageUrl;
  String? musicFileUrl;
  int? userId;
  int? status;
  String? createdAt;
  String? modifiedAt;

  Detail(
      {this.id,
      this.title,
      this.date,
      this.time,
      this.imageUrl,
      this.musicFileUrl,
      this.userId,
      this.status,
      this.createdAt,
      this.modifiedAt});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    imageUrl = json['image_url'];
    musicFileUrl = json['music_file_url'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

}

class Gifts {
  int? id;
  String? title;
  String? imageUrl;
  String? imageBgUrl;
  int? status;
  String? createdAt;
  String? modifiedAt;
  String? colorCode;

  Gifts(
      {this.id,
      this.title,
      this.imageUrl,
      this.imageBgUrl,
      this.status,
      this.createdAt,
      this.modifiedAt,
      this.colorCode});

  Gifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    imageBgUrl = json['image_bg_url'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    colorCode = json['color_code'];
  }

}
