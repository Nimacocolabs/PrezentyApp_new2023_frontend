class OrderListModel {
  String? musicFilesLocation;
  String? imageFilesLocation;
  int? statusCode;
  List<OrderItem>? orderItemsList;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  String? message;
  bool? success;

  OrderListModel(
      {this.musicFilesLocation,
        this.imageFilesLocation,
        this.statusCode,
        this.orderItemsList,
        this.page,
        this.perPage,
        this.hasNextPage,
        this.totalCount,
        this.message,
        this.success});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    musicFilesLocation = json['musicFilesLocation'];
    imageFilesLocation = json['imageFilesLocation'];
    statusCode = json['statusCode'];
    if (json['list'] != null) {
      orderItemsList = [];
      json['list'].forEach((v) {
        orderItemsList?.add(new OrderItem.fromJson(v));
      });
    }

    dynamic pagenumber = json['page'];
    print(pagenumber.runtimeType);
    if (pagenumber is int) {
      page = json['page'];
    } else {
      page = int.parse(json['page']);
    }

    dynamic perPg = json['perPage'];
    print(perPg.runtimeType);
    if (perPg is int) {
      perPage = json['perPage'];
    } else {
      perPage = int.parse(json['perPage']);
    }


    hasNextPage = json['hasNextPage'];

    dynamic totItemCount = json['totalCount'];
    print(totItemCount.runtimeType);
    if (totItemCount is int) {
      totalCount = json['totalCount'];
    } else {
      totalCount = int.parse(json['totalCount']);
    }


    message = json['message'];
    success = json['success'];
  }

}

class OrderItem {
  EventDetail? eventDetail;
  OrderDetail? orderDetail;

  OrderItem({required this.eventDetail, required this.orderDetail});

  OrderItem.fromJson(Map<String, dynamic> json) {
    eventDetail = (json['eventDetail'] != null
        ? new EventDetail.fromJson(json['eventDetail'])
        : null)!;
    orderDetail = json['orderDetail'] != null
        ? new OrderDetail.fromJson(json['orderDetail'])
        : null;
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

