class PopupImageModel {
  PopupImageModel({
      this.statusCode, 
      this.success, 
      this.data,});

  PopupImageModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? PopupImageData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  PopupImageData? data;



}

class PopupImageData {
  PopupImageData({
      this.id, 
      this.image, 
      this.imageUrl, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  PopupImageData.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    imageUrl = json['image_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  dynamic id;
  String? image;
  String? imageUrl;
  String? status;
  String? createdAt;
  String? updatedAt;


}