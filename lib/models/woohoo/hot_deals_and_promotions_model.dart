class HotDealsAndPromotionsModel {
  HotDealsAndPromotionsModel({
      this.statusCode, 
      this.success, 
      this.data,});

  HotDealsAndPromotionsModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(HotDealsAndPromotionsData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<HotDealsAndPromotionsData>? data;



}

class HotDealsAndPromotionsData {
  HotDealsAndPromotionsData({
      this.id, 
      this.productId, 
      this.category, 
      this.image, 
      this.status, 
      this.createdAt, 
      this.title, 
      this.imageUrl,});

  HotDealsAndPromotionsData.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    category = json['category'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    title = json['title'];
    imageUrl = json['image_url'];
  }
  int? id;
  int? productId;
  int? category;
  String? image;
  String? status;
  String? createdAt;
  String? title;
  String? imageUrl;



}