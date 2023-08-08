class OffersResponse {
  OffersResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,});

  OffersResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
  }
  List<Data>? data;
  bool? success;
  int? statusCode;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['success'] = success;
    map['statusCode'] = statusCode;
    map['message'] = message;
    return map;
  }

}

class Data {
  Data({
    this.id,
    this.cardId,
    this.title,
    this.description,
    this.image,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    cardId = json['card_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    imageUrl = json['image_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? cardId;
  String? title;
  String? description;
  String? image;
  String? imageUrl;
  String? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['card_id'] = cardId;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['image_url'] = imageUrl;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}