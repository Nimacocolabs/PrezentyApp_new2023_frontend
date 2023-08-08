class WoohooCategoriesResponse {
  int? statusCode;
  List<WoohooCategory>? data;
  String? message;
  bool? success;

  WoohooCategoriesResponse({
      this.statusCode, 
      this.data, 
      this.message, 
      this.success});

  WoohooCategoriesResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(WoohooCategory.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

}

class WoohooCategory {
  int? id;
  String? name;
  dynamic url;
  dynamic description;
  dynamic image;
  dynamic thumbnail;
  int? subcategoriesCount;
  String? createdAt;

  WoohooCategory({
      this.id, 
      this.name, 
      this.url, 
      this.description, 
      this.image, 
      this.thumbnail, 
      this.subcategoriesCount, 
      this.createdAt});

  WoohooCategory.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    description = json['description'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    subcategoriesCount = json['subcategories_count'];
    createdAt = json['created_at'];
  }

}