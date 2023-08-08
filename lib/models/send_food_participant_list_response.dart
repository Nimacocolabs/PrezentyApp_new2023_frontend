class SendFoodParticipantListResponse {
  SendFoodParticipantListResponse({
      this.list, 
      this.message, 
      this.success, 
      this.statusCode,});

  SendFoodParticipantListResponse.fromJson(dynamic json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(Participant.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
    statusCode = json['statusCode'];
  }
  List<Participant>? list;
  String? message;
  bool? success;
  int? statusCode;

}

class Participant {
  Participant({
      this.id, 
      this.eventId, 
      this.status, 
      this.createdAt, 
      this.modifiedAt, 
      this.name, 
      this.phone, 
      this.email, 
      this.address, 
      this.needFood, 
      this.isAttending, 
      this.orderId, 
      this.orderType, 
      this.orderMembersCount, 
      this.deliveryStatus,
    required this.count
  });

  Participant.fromJson(dynamic json) {
    id = json['id'];
    eventId = json['event_id'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    needFood = json['need_food'];
    isAttending = json['is_attending'];
    orderId = json['order_id'];
    orderType = json['order_type'];
    orderMembersCount = json['order_members_count'];
    deliveryStatus = json['delivery_status'];
    count = 1;
  }

  int count=1;
  String? id;
  String? eventId;
  String? status;
  String? createdAt;
  String? modifiedAt;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? needFood;
  String? isAttending;
  String? orderId;
  String? orderType;
  String? orderMembersCount;
  String? deliveryStatus;
  String createOrderStatus = 'NONE';

}