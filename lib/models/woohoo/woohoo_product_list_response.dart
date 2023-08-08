class WoohooProductListResponse {
  int? statusCode;
  List<WoohooProductListItem>? data;
  String? message;
  String? basePathWoohooImages;
  bool? success;

  WoohooProductListResponse(
      {this.statusCode,
      this.data,
      this.message,
      this.basePathWoohooImages,
      this.success});

  WoohooProductListResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(WoohooProductListItem.fromJson(v));
      });
    }
    message = json['message'];
    basePathWoohooImages = json['base_path_woohoo_images'];
    success = json['success'];
  }
}

class WoohooProductListItem {
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
  String? imageBase;
  String? imageSmall;
  String? createdAt;
  String? updatedAt;
  String? created_At;

  WoohooProductListItem(
      {this.id,
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
      this.imageBase,
      this.imageSmall,
      this.createdAt,
      this.updatedAt,
      this.created_At});

  WoohooProductListItem.fromJson(dynamic json) {
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
    offers =
        json['offers'] != "" || json['offers'] != " " || json['offers'] != null
            ? json['offers']
            : null;
    image = json['image'];
    imageThumbnail = json['image_thumbnail'];
    imageMobile = json['image_mobile'];
    imageBase = json['image_base'];
    imageSmall = json['image_small'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    created_At = json['created_at'];
  }
}
