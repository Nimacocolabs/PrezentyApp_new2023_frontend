class OffersProductListModel {
  OffersProductListModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,
      this.imageURL,});

  OffersProductListModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OffersProductListData.fromJson(v));
      });
    }
     imageURL = json['imageURL'];
  }
  int? statusCode;
  bool? success;
  String? message;
  List<OffersProductListData>? data;
   String? imageURL;

}

class OffersProductListData {
  OffersProductListData({
      this.id, 
      this.categoryId, 
      this.sku, 
      this.name, 
      this.currencyCode, 
      this.currencySymbol, 
      this.currencyNumericCode, 
      this.url, 
      this.minPrice, 
      this.maxPrice, 
      this.offers, 
      this.image, 
      this.imageThumbnail, 
      this.imageMobile, 
      this.voucherType, 
      this.imageBase, 
      this.imageSmall, 
      this.createdAt, 
      this.updatedAt, 
      // this.createdAt, 
      this.status,});

  OffersProductListData.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    sku = json['sku'];
    name = json['name'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyNumericCode = json['currency_numeric_code'];
    url = json['url'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    offers = json['offers'];
    image = json['image'];
    imageThumbnail = json['image_thumbnail'];
    imageMobile = json['image_mobile'];
    voucherType = json['voucher_type'];
    imageBase = json['image_base'];
    imageSmall = json['image_small'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['created_at'];
    status = json['status'];
  }
  int? id;
  int? categoryId;
  String? sku;
  String? name;
  String? currencyCode;
  String? currencySymbol;
  int? currencyNumericCode;
  String? url;
  int? minPrice;
  int? maxPrice;
  String? offers;
  String? image;
  String? imageThumbnail;
  String? imageMobile;
  String? voucherType;
  String? imageBase;
  String? imageSmall;
  String? createdAt;
  String? updatedAt;
  // String? createdAt;
  int? status;



}