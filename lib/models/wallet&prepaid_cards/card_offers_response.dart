// To parse this JSON data, do
//
//     final getCardOffersResponse = getCardOffersResponseFromJson(jsonString);

import 'dart:convert';

GetCardOffersResponse getCardOffersResponseFromJson(String str) =>
    GetCardOffersResponse.fromJson(json.decode(str));

class GetCardOffersResponse {
  GetCardOffersResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  List<CardOffers>? data;
  bool? success;
  int? statusCode;
  String? message;

  GetCardOffersResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CardOffers.fromJson(v));
      });
      success = json["success"];
      statusCode = json["statusCode"];
      message = json["message"];
    }
  }
}

class CardOffers {
  CardOffers({
    this.id,
    this.cardId,
    this.title,
    this.description,
    this.image,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? cardId;
  String? title;
  String? description;
  dynamic image;
  dynamic imageUrl;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  CardOffers.fromJson(dynamic json) {
    id = json["id"];
    cardId = json["card_id"];
    title = json["title"];
    description = json["description"];
    image = json["image"];
    imageUrl = json["image_url"];
    status = json["status"];
    createdAt = DateTime.parse(json["created_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
  }
}
