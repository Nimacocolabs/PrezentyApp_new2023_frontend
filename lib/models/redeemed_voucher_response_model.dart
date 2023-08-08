// To parse this JSON data, do
//
//     final redeemedVouchersResponse = redeemedVouchersResponseFromJson(jsonString);

import 'dart:convert';

RedeemedVouchersResponse redeemedVouchersResponseFromJson(String str) =>
    RedeemedVouchersResponse.fromJson(json.decode(str));

class RedeemedVouchersResponse {
  RedeemedVouchersResponse({
    // this.id,
    // this.sku,
    // this.name,
    this.description,
    // this.price,
    // this.kycEnabled,
    // this.additionalForm,
    // this.metaInformation,
    // this.type,
    // this.schedulingEnabled,
    // this.currency,
    // this.images,
    this.tnc,
    // this.categories,
    // this.themes,
    // this.handlingCharges,
    // this.reloadCardNumber,
    // this.expiry,
    // this.formatExpiry,
    // this.discounts,
    // this.relatedProducts,
    // this.storeLocatorUrl,
    // this.brandName,
    // this.etaMessage,
    // this.createdAt,
    // this.updatedAt,
    // this.cpg,
  });

  // String id;
  // String sku;
  // String name;
  String? description;

  // Price price;
  // String kycEnabled;
  // dynamic additionalForm;
  // MetaInformation metaInformation;
  // String type;
  // bool schedulingEnabled;
  // String currency;
  // Images images;
  Tnc? tnc;

  // List<String> categories;
  // List<dynamic> themes;
  // List<dynamic> handlingCharges;
  // bool reloadCardNumber;
  // String expiry;
  // dynamic formatExpiry;
  // List<dynamic> discounts;
  // List<dynamic> relatedProducts;
  // dynamic storeLocatorUrl;
  // String brandName;
  // String etaMessage;
  // DateTime createdAt;
  // DateTime updatedAt;
  // Cpg cpg;

  RedeemedVouchersResponse.fromJson(Map<String, dynamic> json) {
    // id:
    // json["id"]
    // ,
    // sku: json["sku"],
    // name: json["name"],
    description = json["description"]??'';
    // price: Price.fromJson(json["price"]),
    // kycEnabled: json["kycEnabled"],
    // additionalForm: json["additionalForm"],
    // metaInformation: MetaInformation.fromJson(json["metaInformation"]),
    // type: json["type"],
    // schedulingEnabled: json["schedulingEnabled"],
    // currency: json["currency"],
    // images: Images.fromJson(json["images"]),
    tnc = Tnc.fromJson(json["tnc"]);
    // categories: List<String>.from(json["categories"].map((x) => x)),
    // themes: List<dynamic>.from(json["themes"].map((x) => x)),
    // handlingCharges: List<dynamic>.from(json["handlingCharges"].map((x) => x)),
    // reloadCardNumber: json["reloadCardNumber"],
    // expiry: json["expiry"],
    // formatExpiry: json["formatExpiry"],
    // discounts: List<dynamic>.from(json["discounts"].map((x) => x)),
    // relatedProducts: List<dynamic>.from(json["relatedProducts"].map((x) => x)),
    // storeLocatorUrl: json["storeLocatorUrl"],
    // brandName: json["brandName"],
    // etaMessage: json["etaMessage"],
    // createdAt: DateTime.parse(json["createdAt"]),
    // updatedAt: DateTime.parse(json["updatedAt"]),
    // cpg: Cpg.fromJson(json["cpg"
    // ]
    // )
    // ,
  }

// class Cpg {
//   Cpg({
//     this.barcode,
//     this.redemptionTerms,
//   });
//
//   Barcode barcode;
//   List<dynamic> redemptionTerms;
//
//   factory Cpg.fromJson(Map<String, dynamic> json) => Cpg(
//     barcode: Barcode.fromJson(json["barcode"]),
//     redemptionTerms: List<dynamic>.from(json["redemptionTerms"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "barcode": barcode.toJson(),
//     "redemptionTerms": List<dynamic>.from(redemptionTerms.map((x) => x)),
//   };
// }
//
// class Barcode {
//   Barcode({
//     this.encoding,
//   });
//
//   dynamic encoding;
//
//   factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
//     encoding: json["encoding"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "encoding": encoding,
//   };
// }
//
// class Images {
//   Images({
//     this.thumbnail,
//     this.mobile,
//     this.base,
//     this.small,
//   });
//
//   String thumbnail;
//   String mobile;
//   String base;
//   String small;
//
//   factory Images.fromJson(Map<String, dynamic> json) => Images(
//     thumbnail: json["thumbnail"],
//     mobile: json["mobile"],
//     base: json["base"],
//     small: json["small"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "thumbnail": thumbnail,
//     "mobile": mobile,
//     "base": base,
//     "small": small,
//   };
// }
//
// class MetaInformation {
//   MetaInformation({
//     this.page,
//     this.meta,
//     this.canonical,
//   });
//
//   Page page;
//   Meta meta;
//   Canonical canonical;
//
//   factory MetaInformation.fromJson(Map<String, dynamic> json) => MetaInformation(
//     page: Page.fromJson(json["page"]),
//     meta: Meta.fromJson(json["meta"]),
//     canonical: Canonical.fromJson(json["canonical"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "page": page.toJson(),
//     "meta": meta.toJson(),
//     "canonical": canonical.toJson(),
//   };
// }
//
// class Canonical {
//   Canonical({
//     this.url,
//   });
//
//   dynamic url;
//
//   factory Canonical.fromJson(Map<String, dynamic> json) => Canonical(
//     url: json["url"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "url": url,
//   };
// }
//
// class Meta {
//   Meta({
//     this.title,
//     this.keywords,
//     this.description,
//   });
//
//   dynamic title;
//   dynamic keywords;
//   dynamic description;
//
//   factory Meta.fromJson(Map<String, dynamic> json) => Meta(
//     title: json["title"],
//     keywords: json["keywords"],
//     description: json["description"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "title": title,
//     "keywords": keywords,
//     "description": description,
//   };
// }
//
// class Page {
//   Page({
//     this.title,
//   });
//
//   dynamic title;
//
//   factory Page.fromJson(Map<String, dynamic> json) => Page(
//     title: json["title"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "title": title,
//   };
// }
//
// class Price {
//   Price({
//     this.price,
//     this.type,
//     this.min,
//     this.max,
//     this.denominations,
//     this.currency,
//   });
//
//   String price;
//   String type;
//   String min;
//   String max;
//   List<dynamic> denominations;
//   Currency currency;
//
//   factory Price.fromJson(Map<String, dynamic> json) => Price(
//     price: json["price"],
//     type: json["type"],
//     min: json["min"],
//     max: json["max"],
//     denominations: List<dynamic>.from(json["denominations"].map((x) => x)),
//     currency: Currency.fromJson(json["currency"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "price": price,
//     "type": type,
//     "min": min,
//     "max": max,
//     "denominations": List<dynamic>.from(denominations.map((x) => x)),
//     "currency": currency.toJson(),
//   };
// }
//
// class Currency {
//   Currency({
//     this.code,
//     this.symbol,
//     this.numericCode,
//   });
//
//   String code;
//   String symbol;
//   String numericCode;
//
//   factory Currency.fromJson(Map<String, dynamic> json) => Currency(
//     code: json["code"],
//     symbol: json["symbol"],
//     numericCode: json["numericCode"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "code": code,
//     "symbol": symbol,
//     "numericCode": numericCode,
//   };
// }
}

class Tnc {
  Tnc({
    this.link,
    this.content,
  });

  String? link;
  String? content;

  Tnc.fromJson(Map<String, dynamic> json) {
    link = json["link"];
    content = json["content"];
  }

  Map<String, dynamic> toJson() => {
        "link": link,
        "content": content,
      };
}
