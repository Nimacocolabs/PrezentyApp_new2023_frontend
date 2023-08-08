// class UpgradeCardListResponse {
//   UpgradeCardListResponse({
//       this.statusCode,
//       this.success,
//       this.data,});
//
//   UpgradeCardListResponse.fromJson(dynamic json) {
//     print(json);
//     statusCode = json['statusCode'];
//     success = json['success'];
//     if (json['data'] != null) {
//       data = [];
//       json['data'].forEach((v) {
//         data?.add(CardDetails.fromJson(v));
//       });
//     }
//   }
//   dynamic statusCode;
//   bool? success;
//   List<CardDetails>? data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['statusCode'] = statusCode.toString();
//     map['success'] = success;
//     if (data != null) {
//       map['data'] = data?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// class CardDetails {
//   CardDetails({
//       this.id,
//       this.title,
//       this.shortDescription,
//       this.longDescription,
//       this.amount,
//       this.image,
//       this.imageUrl,
//       this.status,
//       this.createdAt,
//       this.updatedAt,});
//
//   CardDetails.fromJson(dynamic json) {
//     id = json['id'];
//     title = json['title'];
//     shortDescription = json['short_description'];
//     longDescription = json['long_description'];
//     amount = json['amount'];
//     image = json['image'];
//     imageUrl = json['image_url'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   int? id;
//   String? title;
//   String? shortDescription;
//   String? longDescription;
//   int? amount;
//   String? image;
//   String? imageUrl;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['title'] = title;
//     map['short_description'] = shortDescription;
//     map['long_description'] = longDescription;
//     map['amount'] = amount;
//     map['image'] = image;
//     map['image_url'] = imageUrl;
//     map['status'] = status;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }