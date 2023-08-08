class OrderDetailModel {
  OrderDetail? orderDetail;
  EventDetail? eventDetail;
  int? giftCount;
  GiftDetail? giftDetail;
  int? vegCount;
  VegDetail? vegDetail;
  int? nonvegCount;
  NonVegDetail? nonVegDetail;
  String? message;
  int? statusCode;
  bool? success;
  String? imageFilesLocation;
  String? giftVoucherImageLocation;
  String? menuGiftsBaseUrl;

  OrderDetailModel(
      {this.orderDetail,
        this.eventDetail,
        this.giftCount,
        this.giftDetail,
        this.vegCount,
        this.vegDetail,
        this.nonvegCount,
        this.nonVegDetail,
        this.message,
        this.statusCode,
        this.success,this.imageFilesLocation,this.giftVoucherImageLocation,this.menuGiftsBaseUrl});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderDetail = json['orderDetail'] != null
        ? new OrderDetail.fromJson(json['orderDetail'])
        : null;
    eventDetail = json['eventDetail'] != null
        ? new EventDetail.fromJson(json['eventDetail'])
        : null;
    giftCount = json['giftCount'];
    giftDetail = json['giftDetail'] != null
        ? new GiftDetail.fromJson(json['giftDetail'])
        : null;
    vegCount = json['vegCount'];
    vegDetail = json['vegDetail'] != null
        ? new VegDetail.fromJson(json['vegDetail'])
        : null;
    nonvegCount = json['nonvegCount'];
    nonVegDetail = json['nonVegDetail'] != null
        ? new NonVegDetail.fromJson(json['nonVegDetail'])
        : null;
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    imageFilesLocation = json['eventImageFilesLocation'];
    giftVoucherImageLocation = json['giftVoucherImageLocation'];
    menuGiftsBaseUrl = json['baseUrl'];
  }

}

class OrderDetail {
  int? id;
  int? eventId;
  double? amount;
  int? menuGiftId;
  int? giftCount;
  int? menuVegId;
  int? vegCount;
  int? menuNonVegId;
  int? nonVegCount;
  int? status;
  String? createdAt;
  String? modifiedAt;
  String? orderStatus;

  OrderDetail(
      {this.id,
        this.eventId,
        this.amount,
        this.menuGiftId,
        this.giftCount,
        this.menuVegId,
        this.vegCount,
        this.menuNonVegId,
        this.nonVegCount,
        this.status,
        this.createdAt,
        this.modifiedAt,
        this.orderStatus});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];

    if (json['amount'] != null) {
      dynamic amt = json['amount'];
      if (amt is int) {
        amount = json['amount'].toDouble();
      } else {
        amount = json['amount'];
      }
    } else {
      amount = 0.0;
    }

    menuGiftId = json['menu_gift_id'];
    giftCount = json['gift_count'];
    menuVegId = json['menu_veg_id'];
    vegCount = json['veg_count'];
    menuNonVegId = json['menu_non_veg_id'];
    nonVegCount = json['non_veg_count'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    orderStatus = json['order_status'];
  }

}

class EventDetail {
  int? id;
  String? title;
  String? date;
  String? time;
  String? imageUrl;
  String? musicFileUrl;
  int? userId;
  int? status;
  String? createdAt;
  String? modifiedAt;

  EventDetail(
      {this.id,
        this.title,
        this.date,
        this.time,
        this.imageUrl,
        this.musicFileUrl,
        this.userId,
        this.status,
        this.createdAt,
        this.modifiedAt});

  EventDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    imageUrl = json['image_url'];
    musicFileUrl = json['music_file_url'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

}

class GiftDetail {
  int? id;
  String? title;
  double? price;
  double? rating;
  int? isGift;
  int? isVeg;
  int? isNonVeg;
  String? imageUrl;
  int? status;
  String? createdAt;
  String? modifiedAt;

  GiftDetail(
      {this.id,
        this.title,
        this.price,
        this.rating,
        this.isGift,
        this.isVeg,
        this.isNonVeg,
        this.imageUrl,
        this.status,
        this.createdAt,
        this.modifiedAt});

  GiftDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];

    if (json['price'] != null) {
      dynamic amt = json['price'];
      if (amt is int) {
        price = json['price'].toDouble();
      } else {
        price = json['price'];
      }
    } else {
      price = 0.0;
    }

    if (json['rating'] != null) {
      dynamic amt = json['rating'];
      if (amt is int) {
        rating = json['rating'].toDouble();
      } else {
        rating = json['rating'];
      }
    } else {
      rating = 0.0;
    }

    isGift = json['is_gift'];
    isVeg = json['is_veg'];
    isNonVeg = json['is_non_veg'];
    imageUrl = json['image_url'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

}

class VegDetail {
  GiftDetail? detail;
  List<Items>? items;

  VegDetail({required this.detail, required this.items});

  VegDetail.fromJson(Map<String, dynamic> json) {
    detail =
    json['detail'] != null ? new GiftDetail.fromJson(json['detail']) : null;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(new Items.fromJson(v));
      });
    }
  }

}

class NonVegDetail {
  GiftDetail? detail;
  List<Items>? items;

  NonVegDetail({required this.detail, required this.items});

  NonVegDetail.fromJson(Map<String, dynamic> json) {
    detail =
    json['detail'] != null ? new GiftDetail.fromJson(json['detail']) : null;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(new Items.fromJson(v));
      });
    }
  }

}

class Items {
  int? id;
  int? menuGiftId;
  String? title;
  double? price;
  int? status;
  String? createdAt;
  String? modifiedAt;

  Items(
      {this.id,
        this.menuGiftId,
        this.title,
        this.price,
        this.status,
        this.createdAt,
        this.modifiedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuGiftId = json['menu_gift_id'];
    title = json['title'];

    if (json['price'] != null) {
      dynamic amt = json['price'];
      if (amt is int) {
        price = json['price'].toDouble();
      } else {
        price = json['price'];
      }
    } else {
      price = 0.0;
    }

    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

}

