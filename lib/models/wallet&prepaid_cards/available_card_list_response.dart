// To parse this JSON data, do
//
//     final getAllAvailableCardList = getAllAvailableCardListFromJson(jsonString);

import 'dart:convert';

GetAllAvailableCardListResponse getAllAvailableCardListFromJson(String str) =>
    GetAllAvailableCardListResponse.fromJson(json.decode(str));

class GetAllAvailableCardListResponse {
  GetAllAvailableCardListResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  List<CardDetails?>? data;
  bool? success;
  int? statusCode;
  String? message;

  GetAllAvailableCardListResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CardDetails.fromJson(v));
      });

      success = json["success"];
      statusCode = json["statusCode"];
      message = json["message"];
    }
  }
}

class CardDetails {
  CardDetails({
    this.id,
    this.title,
    this.shortDescription,
    this.longDescription,
    this.image,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.bgImage,
  });

  int? id;
  String? title;
  String? shortDescription;
  String? longDescription;
  int? amount;
  dynamic image;
  String? imageUrl;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? bgImage;

  CardDetails.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    shortDescription = json["short_description"];
    longDescription = json["long_description"];
    amount = (json["amount"]);
    image = json["image"];
    imageUrl = json["image_url"];
    status = json["status"];
    createdAt = DateTime.parse(json["created_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
    bgImage = json["bg_img"];
  }
}
