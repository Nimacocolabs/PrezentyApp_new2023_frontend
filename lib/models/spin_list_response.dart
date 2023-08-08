import 'dart:convert';

class SpinItemsListResponse {
  SpinItemsListResponse({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  int? statusCode;
  bool? success;
  String? message;
  List<SpinItem>? data;

  factory SpinItemsListResponse.fromJson(Map<String, dynamic> json) =>
      SpinItemsListResponse(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data:
            List<SpinItem>.from(json["data"].map((x) => SpinItem.fromJson(x))),
      );
}

class SpinItem {
  SpinItem({
    this.id,
    this.title,
    this.type,
    this.typeId,
    this.targetAmount,
    this.discountAmount,
    this.couponCode,
    this.shortDescription,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? type;
  int? typeId;
  String? targetAmount;
  String? discountAmount;
  dynamic couponCode;
  String? shortDescription;
  DateTime? createdAt;
  dynamic updatedAt;

  factory SpinItem.fromJson(Map<String, dynamic> json) => SpinItem(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        typeId: json["type_id"],
        targetAmount: json["target_amount"],
        discountAmount: json["discount_amount"],
        couponCode: json["coupon_code"],
        shortDescription: json["short_description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );
}
