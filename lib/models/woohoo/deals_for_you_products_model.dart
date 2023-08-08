class DealsForYouProductsModel {
  DealsForYouProductsModel({
      this.statusCode, 
      this.success, 
      this.data,});

  DealsForYouProductsModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DealsForYouProductsData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<DealsForYouProductsData>? data;



}

class DealsForYouProductsData {
  DealsForYouProductsData({
      this.id, 
      this.productId, 
      this.image, 
      this.status, 
      this.createdAt, 
      this.title, 
      this.imageUrl,});

  DealsForYouProductsData.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    title = json['title'];
    imageUrl = json['image_url'];
  }
  int? id;
  int? productId;
  String? image;
  String? status;
  String? createdAt;
  String? title;
  String? imageUrl;


}