class GetMerchantsListModel {
  GetMerchantsListModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  GetMerchantsListModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GetMerchantsListData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<GetMerchantsListData>? data;



}

class GetMerchantsListData {
  GetMerchantsListData({
      this.id, 
      this.name, 
      this.phoneNumber, 
      this.email, 
      this.address, 
      this.unitAmount, 
      this.touchpoints, 
      this.image, 
      this.imageUrl, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  GetMerchantsListData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    address = json['address'];
    unitAmount = json['unit_amount'];
    touchpoints = json['touchpoints'];
    image = json['image'];
    imageUrl = json['image_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? address;
  String? unitAmount;
  String? touchpoints;
  String? image;
  String? imageUrl;
  String? status;
  String? createdAt;
  String? updatedAt;



}