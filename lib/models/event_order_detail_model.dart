class EventOrderDetailModel {
  Order? order;
  String? brandImageLocation;
  String? message;
  bool? success;
  int? statusCode;

  EventOrderDetailModel(
      {this.order,
        this.brandImageLocation,
        this.message,
        this.success,
        this.statusCode});

  EventOrderDetailModel.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    brandImageLocation = json['brand_image_location'];
    message = json['message'];
    success = json['success'];
    statusCode = json['statusCode'];
  }

}

class Order {
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
  List<Participants>? participants;

  Order(
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
        this.foodVoucher,
        this.participants});

  Order.fromJson(Map<String, dynamic> json) {
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
    if (json['participants'] != null) {
      participants = [];
      json['participants'].forEach((v) {
        participants?.add(new Participants.fromJson(v));
      });
    }
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
  Voucher? voucher;

  FoodVoucher({this.id, this.eventId, this.voucherId, this.voucher});

  FoodVoucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    voucherId = json['voucher_id'];
    voucher =
    json['voucher'] != null ? new Voucher.fromJson(json['voucher']) : null;
  }

}

class Voucher {
  String?id;
  String? brandId;
  String? couponValue;
  Brand? brand;

  Voucher({this.id, this.brandId, this.couponValue, this.brand});

  Voucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brand_id'];
    couponValue = json['coupon_value'];
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
  }

}

class Brand {
  String? id;
  String? name;
  String? logo;

  Brand({this.id, this.name, this.logo});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

}

class Participants {
  String? id;
  String? eventId;
  String status='';
  String? createdAt;
  String? modifiedAt;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? isVeg;
  String? needFood;
  String? needGift;
  String? isAttending;
  String? isDelivered;
  String? orderId;
  String? orderType;
  String? orderMembersCount;
  String? deliveryStatus;
  String? imageUrl;

  Participants(
      {this.id,
      this.eventId,
      required this.status,
      this.createdAt,
      this.modifiedAt,
      this.name,
      this.phone,
      this.email,
      this.address,
      this.isVeg,
      this.needFood,
      this.needGift,
      this.isAttending,
        this.isDelivered,
      this.orderId,
      this.orderType,
      this.orderMembersCount,
      this.deliveryStatus,
      this.imageUrl});

  Participants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    status = json['status']??'';
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    isVeg = json['is_veg'];
    needFood = json['need_food'];
    needGift = json['need_gift'];
    isAttending = json['is_attending'];
    isDelivered = json['is_delivered'];
    orderId = json['order_id'];
    orderType = json['order_type'];
    orderMembersCount = json['order_members_count'];
    deliveryStatus = json['delivery_status'];
    imageUrl = json['image_url'] ?? "";
  }

}
