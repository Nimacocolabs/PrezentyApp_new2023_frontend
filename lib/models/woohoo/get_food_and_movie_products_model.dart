class GetFoodAndMovieProductsModel {
  GetFoodAndMovieProductsModel({
      this.statusCode, 
      this.success, 
      this.data,});

  GetFoodAndMovieProductsModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GetFoodAndMovieProductsData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<GetFoodAndMovieProductsData>? data;



}

class  GetFoodAndMovieProductsData {
  GetFoodAndMovieProductsData({
      this.id, 
      this.productId, 
      this.category, 
      this.image, 
      this.status, 
      this.createdAt, 
      this.title, 
      this.imageUrl,});

  GetFoodAndMovieProductsData.fromJson(dynamic json) {
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