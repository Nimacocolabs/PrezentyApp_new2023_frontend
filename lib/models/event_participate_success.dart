class EventParticipateSuccess {
  String? message;
  int? statusCode;
  bool? success;
  Detail? detail;

  EventParticipateSuccess(
      {this.message, this.statusCode, this.success, this.detail});

  EventParticipateSuccess.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    detail =
    json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

}

class Detail {
  int? id;
  int? eventId;
  int? status;
  String? createdAt;
  String? modifiedAt;
  String? name;
  String? phone;
  String? email;
  String? address;
  int? membersCount;
  int? isVeg;
  int? needFood;
  int? needGift;
  int? isAttending;

  Detail(
      {this.id,
        this.eventId,
        this.status,
        this.createdAt,
        this.modifiedAt,
        this.name,
        this.phone,
        this.email,
        this.address,
        this.membersCount,
        this.isVeg,
        this.needFood,
        this.needGift,
        this.isAttending});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    membersCount = json['members_count'];
    isVeg = json['is_veg'];
    needFood = json['need_food'];
    needGift = json['need_gift'];
    isAttending = json['is_attending'];
  }

}

