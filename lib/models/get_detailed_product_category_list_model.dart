class GetDetailedProductCategoryListModel {
  GetDetailedProductCategoryListModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  GetDetailedProductCategoryListModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GetDetailedProductCategoryListData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<GetDetailedProductCategoryListData>? data;



}

class GetDetailedProductCategoryListData {
  GetDetailedProductCategoryListData({
      this.id, 
      this.categoryId, 
      this.productCategoryId, 
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
      this.imageUrl,
      //this.createdAt, 
      this.status,});

  GetDetailedProductCategoryListData.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    productCategoryId = json['product_category_id'];
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
    imageUrl = json['imageURL'];
  }
  int? id;
  int? categoryId;
  int? productCategoryId;
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
  //String? createdAt;
  int? status;
  String? imageUrl;


}