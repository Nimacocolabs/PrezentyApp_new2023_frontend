class BlockedUsersResponse {
  List<UsersList>? usersList;
  String? message;
  int? statusCode;
  bool? success;

  BlockedUsersResponse(
      {this.usersList, this.message, this.statusCode, this.success});

  BlockedUsersResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      usersList = [];
      json['list'].forEach((v) {
        usersList?.add(new UsersList.fromJson(v));
      });
    }
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
  }

}

class UsersList {
  String? id;
  String? eventId;
  String? status;
  String? blockedUserEmail;
  String? blockedByUserEmail;
  Participant? participant;

  UsersList(
      {this.id,
      this.eventId,
      this.status,
      this.blockedUserEmail,
      this.blockedByUserEmail,
      this.participant});

  UsersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    status = json['status'];
    blockedUserEmail = json['blocked_user_email'];
    blockedByUserEmail = json['blocked_by_user_email'];
    participant = json['participant'] != null
        ? new Participant.fromJson(json['participant'])
        : null;
  }

}

class Participant {
  String? id;
  String? eventId;
  String? status;
  String? createdAt;
  String? modifiedAt;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? membersCount;
  String? isVeg;
  String? needFood;
  String? needGift;
  String? isAttending;
  String? orderId;
  String? orderType;
  String? orderMembersCount;
  String? deliveryStatus;

  Participant(
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
      this.isAttending,
      this.orderId,
      this.orderType,
      this.orderMembersCount,
      this.deliveryStatus});

  Participant.fromJson(Map<String, dynamic> json) {
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
    orderId = json['order_id'];
    orderType = json['order_type'];
    orderMembersCount = json['order_members_count'];
    deliveryStatus = json['delivery_status'];
  }
}
