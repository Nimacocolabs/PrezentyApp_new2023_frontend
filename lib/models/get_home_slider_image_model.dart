class GetHomeSliderImageModel {
  GetHomeSliderImageModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  GetHomeSliderImageModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GetHomeSliderImageData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<GetHomeSliderImageData>? data;


}

class GetHomeSliderImageData {
  GetHomeSliderImageData({
      this.id, 
      this.image, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  GetHomeSliderImageData.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;



}