class GetHowItWorksModel {
  GetHowItWorksModel({
      this.statusCode, 
      this.success, 
      this.data,});

  GetHowItWorksModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GetHowItWorksData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  List<GetHowItWorksData>? data;

}

class GetHowItWorksData {
  GetHowItWorksData({
      this.id, 
      this.image, 
      this.imageUrl, 
      this.status,});

  GetHowItWorksData.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    imageUrl = json['image_url'];
    status = json['status'];
  }
  int? id;
  String? image;
  String? imageUrl;
  String? status;



}