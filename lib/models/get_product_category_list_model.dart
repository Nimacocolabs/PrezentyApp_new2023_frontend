class GetProductCategoryListModel {
  GetProductCategoryListModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  GetProductCategoryListModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GetProductCategoryListData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<GetProductCategoryListData>? data;



}

class GetProductCategoryListData {
  GetProductCategoryListData({
      this.id, 
      this.name, 
      this.image, 
      this.caption, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  GetProductCategoryListData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    caption = json['caption'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  String? image;
  String? caption;
  String? status;
  String? createdAt;
  String? updatedAt;



}