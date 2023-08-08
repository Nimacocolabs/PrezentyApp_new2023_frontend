class WoohooProductDetailResponse {
  int? statusCode;
  WoohooProductDetail? data;
  String? image;
  String? offers;
  bool? success;
  String? basePathTemplatesImages;
  List<Templates>? templates;

  WoohooProductDetailResponse(
      {this.statusCode, this.image, this.data, this.offers, this.success, this.basePathTemplatesImages,this.templates});

  WoohooProductDetailResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? WoohooProductDetail.fromJson(json['data'])
        : null;
    if (json['templates'] != null) {
      templates = <Templates>[];
      json['templates'].forEach((v) {
        templates!.add(new Templates.fromJson(v));
      });
    }

    success = json['success'];
    basePathTemplatesImages=json["base_path_templates_images"];
    image = json['image'];
    offers =
        json['offers'] != null || json['offers'] != "" ? json['offers'] : null;
  }
}

class WoohooProductDetail {
  String? id;
  String? sku;
  String? name;
  String? description;
  Price? price;
  String? kycEnabled;

  // dynamic? additionalForm;
  // MetaInformation? metaInformation;
  String? type;
  bool? schedulingEnabled;
  String? currency;
  Images? images;
  Tnc? tnc;
  List<String>? categories;

  // List<dynamic>? themes;
  // List<dynamic>? handlingCharges;
  bool? reloadCardNumber;
  String? expiry;

  // dynamic? formatExpiry;
  // List<dynamic>? discounts;
  // List<dynamic>? relatedProducts;
  // dynamic? storeLocatorUrl;
  String? brandName;
  String? etaMessage;
  String? createdAt;
  String? updatedAt;

  // Cpg? cpg;

  WoohooProductDetail({
    this.id,
    this.sku,
    this.name,
    this.description,
    this.price,
    this.kycEnabled,
    // this.additionalForm,
    // this.metaInformation,
    this.type,
    this.schedulingEnabled,
    this.currency,
    this.images,
    this.tnc,
    this.categories,
    // this.themes,
    // this.handlingCharges,
    this.reloadCardNumber,
    this.expiry,
    // this.formatExpiry,
    // this.discounts,
    // this.relatedProducts,
    // this.storeLocatorUrl,
    this.brandName,
    this.etaMessage,
    this.createdAt,
    this.updatedAt,
    // this.cpg
  });

  WoohooProductDetail.fromJson(dynamic json) {
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    description = json['description'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    kycEnabled = json['kycEnabled'];
    // additionalForm = json['additionalForm'];
    // metaInformation = json['metaInformation'] != null ? MetaInformation.fromJson(json['metaInformation']) : null;
    type = json['type'];
    schedulingEnabled = json['schedulingEnabled'];
    currency = json['currency'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    tnc = json['tnc'] != null ? Tnc.fromJson(json['tnc']) : null;
    categories =
        json['categories'] != null ? json['categories'].cast<String>() : [];
    // if (json['themes'] != null) {
    //   themes = [];
    //   json['themes'].forEach((v) {
    //     themes?.add(dynamic.fromJson(v));
    //   });
    // }
    // if (json['handlingCharges'] != null) {
    //   handlingCharges = [];
    //   json['handlingCharges'].forEach((v) {
    //     handlingCharges?.add(dynamic.fromJson(v));
    //   });
    // }
    reloadCardNumber = json['reloadCardNumber'];
    expiry = json['expiry'];
    // formatExpiry = json['formatExpiry'];
    // if (json['discounts'] != null) {
    //   discounts = [];
    //   json['discounts'].forEach((v) {
    //     discounts?.add(dynamic.fromJson(v));
    //   });
    // }
    // if (json['relatedProducts'] != null) {
    //   relatedProducts = [];
    //   json['relatedProducts'].forEach((v) {
    //     relatedProducts?.add(dynamic.fromJson(v));
    //   });
    // }
    // storeLocatorUrl = json['storeLocatorUrl'];
    brandName = json['brandName'];
    etaMessage = json['etaMessage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // cpg = json['cpg'] != null ? Cpg.fromJson(json['cpg']) : null;
  }
}

// class Cpg {
//   Barcode? barcode;
//   List<dynamic>? redemptionTerms;
//
//   Cpg({
//       this.barcode,
//       this.redemptionTerms});
//
//   Cpg.fromJson(dynamic json) {
//     barcode = json['barcode'] != null ? Barcode.fromJson(json['barcode']) : null;
//     if (json['redemptionTerms'] != null) {
//       redemptionTerms = [];
//       json['redemptionTerms'].forEach((v) {
//         redemptionTerms?.add(dynamic.fromJson(v));
//       });
//     }
//   }
//
// }
// class Barcode {
//   dynamic? encoding;
//
//   Barcode({
//       this.encoding});
//
//   Barcode.fromJson(dynamic json) {
//     encoding = json['encoding'];
//   }
//
// }

class Tnc {
  String? link;
  String? content;

  Tnc({this.link, this.content});

  Tnc.fromJson(dynamic json) {
    link = json['link'];
    content = json['content'];
  }
}

class Images {
  String? thumbnail;
  String? mobile;
  String? base;
  String? small;

  Images({this.thumbnail, this.mobile, this.base, this.small});

  Images.fromJson(dynamic json) {
    thumbnail = json['thumbnail'];
    mobile = json['mobile'];
    base = json['base'];
    small = json['small'];
  }
}

// class MetaInformation {
//   Page? page;
//   Meta? meta;
//   Canonical? canonical;
//
//   MetaInformation({
//       this.page,
//       this.meta,
//       this.canonical});
//
//   MetaInformation.fromJson(dynamic json) {
//     page = json['page'] != null ? Page.fromJson(json['page']) : null;
//     meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
//     canonical = json['canonical'] != null ? Canonical.fromJson(json['canonical']) : null;
//   }
// }
// class Canonical {
//   dynamic? url;
//
//   Canonical({
//       this.url});
//
//   Canonical.fromJson(dynamic json) {
//     url = json['url'];
//   }
// }
// class Meta {
//   dynamic? title;
//   dynamic? keywords;
//   dynamic? description;
//
//   Meta({
//       this.title,
//       this.keywords,
//       this.description});
//
//   Meta.fromJson(dynamic json) {
//     title = json['title'];
//     keywords = json['keywords'];
//     description = json['description'];
//   }
// }
// class Page {
//   dynamic? title;
//
//   Page({
//       this.title});
//
//   Page.fromJson(dynamic json) {
//     title = json['title'];
//   }
// }

class Price {
  String? price;
  String? type;
  String? min;
  String? max;
  List<String>? denominations;
  Currency? currency;

  Price(
      {this.price,
      this.type,
      this.min,
      this.max,
      this.denominations,
      this.currency});

  Price.fromJson(dynamic json) {
    price = json['price'];
    type = json['type'];
    min = json['min'];
    max = json['max'];
    denominations = json['denominations'] != null
        ? json['denominations'].cast<String>()
        : [];
    currency =
        json['currency'] != null ? Currency.fromJson(json['currency']) : null;
  }
}

class Currency {
  String? code;
  String? symbol;
  String? numericCode;

  Currency({this.code, this.symbol, this.numericCode});

  Currency.fromJson(dynamic json) {
    code = json['code'];
    symbol = json['symbol'];
    numericCode = json['numericCode'];
  }
}


class Templates {
  int? id;
  String? imageFileUrl;
  String? status;
  String? createdAt;
  String? modifiedAt;

  Templates(
      {this.id,
        this.imageFileUrl,
        this.status,
        this.createdAt,
        this.modifiedAt});

  Templates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageFileUrl = json['image_file_url'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

}

