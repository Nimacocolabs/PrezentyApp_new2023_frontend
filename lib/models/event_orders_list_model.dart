
class EventOrdersListModel {
  List<OrdersList>? ordersList;
   String? brandImageLocation;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  String? message;
  bool? success;
  int? statusCode;

  EventOrdersListModel(
      {this.ordersList,
      this.brandImageLocation,
      this.page,
      this.perPage,
      this.hasNextPage,
      this.totalCount,
      this.message,
      this.success,
      this.statusCode});

  EventOrdersListModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      ordersList = [];
      json['list'].forEach((v) {
        ordersList?.add(new OrdersList.fromJson(v));
      });
    }

    brandImageLocation = json['brand_image_location'];
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totalCount = json['totalCount'];
    message = json['message'];
    success = json['success'];
    statusCode = json['statusCode'];
  }

}

class OrdersList {
  String? id;
  String? eventId;
  String? type;
  String? amount;
  String? service;
  String? gst;
  String? cess;
  String? totalAmount;
  String? selectedItem;
  String? createdAt;
  String? modifiedAt;
  String? paymentStatus;
  Event? event;
  FoodVoucher? foodVoucher;

  OrdersList(
      {this.id,
      this.eventId,
      this.type,
      this.amount,
      this.service,
      this.gst,
      this.cess,
      this.totalAmount,
      this.selectedItem,
      this.createdAt,
      this.modifiedAt,
      this.paymentStatus,
      this.event,
      this.foodVoucher});

  OrdersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    type = json['type'];
    amount = json['amount'];
    service = json['service'];
    gst = json['gst'];
    cess = json['cess'];
    totalAmount = json['total_amount'];
    selectedItem = json['selected_item'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    paymentStatus = json['payment_status'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    foodVoucher = json['foodVoucher'] != null
        ? new FoodVoucher.fromJson(json['foodVoucher'])
        : null;
  }

}

class Event {
  String? id;
  String? title;
  String? date;
  String? time;
  String? imageUrl;
  String? userId;
  String? status;
  String? createdAt;
  String? modifiedAt;

  Event(
      {this.id,
      this.title,
      this.date,
      this.time,
      this.imageUrl,
      this.userId,
      this.status,
      this.createdAt,
      this.modifiedAt});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    imageUrl = json['image_url'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }
}

class FoodVoucher {
  String? id;
  String? eventId;
  String? voucherId;

  FoodVoucher({this.id, this.eventId, this.voucherId});

  FoodVoucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    voucherId = json['voucher_id'];
  }

}


