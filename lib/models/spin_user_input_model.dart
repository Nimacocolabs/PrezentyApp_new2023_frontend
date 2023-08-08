import 'spin_voucher_list_response.dart';

class SpinUserInputModel {
  SpinUserInputModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data, 
      this.screen,});

  SpinUserInputModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? SpinUserInputResponse.fromJson(json['data']) : null;
    screen = json['screen'];
  }
  int? statusCode;
  bool? success;
  String? message;
  SpinUserInputResponse? data;
  String? screen;



}

class SpinUserInputResponse {
  SpinUserInputResponse({
      this.insTableId, this.currentDate,
      this.spinList,this.spinDate, this.spinData});

  SpinUserInputResponse.fromJson(dynamic json) {
    insTableId = json['ins_table_id'];
    if (json['spin_list'] != null) {
      spinList = [];
      json['spin_list'].forEach((v) {
        spinList?.add(SpinList.fromJson(v));
      });
    }
    currentDate = json['current_date'];
    spinDate = json['spin_date'];
    spinData = json['spin_data'] != null
        ? new SpinVoucherData.fromJson(json['spin_data'])
        : null;
  }
  int? insTableId;
  List<SpinList>? spinList;
  String? spinDate;
  String? currentDate;
  SpinVoucherData? spinData;



}

// class SpinData {
//   int? id;
//   String? title;
//   String? type;
//   int? typeId;
//   String? targetAmount;
//   String? discountAmount;
//   String? couponCode;
//   String? shortDescription;
//   String? createdAt;
//   String? updatedAt;
//
//   SpinData({this.id,
//     this.title,
//     this.type,
//     this.typeId,
//     this.targetAmount,
//     this.discountAmount,
//     this.couponCode,
//     this.shortDescription,
//     this.createdAt,
//     this.updatedAt});
//
//   SpinData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     type = json['type'];
//     typeId = json['type_id'];
//     targetAmount = json['target_amount'];
//     discountAmount = json['discount_amount'];
//     couponCode = json['coupon_code'];
//     shortDescription = json['short_description'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
// }

class SpinList {
  SpinList({
      this.id, 
      this.title, 
      this.type, 
      this.typeId, 
      this.targetAmount, 
      this.discountAmount, 
      this.couponCode, 
      this.shortDescription, 
      this.createdAt, 
      this.updatedAt,});

  SpinList.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    typeId = json['type_id'];
    targetAmount = json['target_amount'];
    discountAmount = json['discount_amount'];
    couponCode = json['coupon_code'];
    shortDescription = json['short_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? title;
  String? type;
  int? typeId;
  String? targetAmount;
  String? discountAmount;
  dynamic couponCode;
  String? shortDescription;
  String? createdAt;
  dynamic updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['type'] = type;
    map['type_id'] = typeId;
    map['target_amount'] = targetAmount;
    map['discount_amount'] = discountAmount;
    map['coupon_code'] = couponCode;
    map['short_description'] = shortDescription;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}