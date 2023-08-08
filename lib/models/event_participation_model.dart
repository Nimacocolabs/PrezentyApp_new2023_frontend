class EventParticipationModal {
  int? statusCode;
  List<PartcipantInfo>? partcipantList;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  String? message;
  bool? success;

  EventParticipationModal(
      {this.statusCode,
      this.partcipantList,
      this.page,
      this.perPage,
      this.hasNextPage,
      this.totalCount,
      this.message,
      this.success});

  EventParticipationModal.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['list'] != null) {
      partcipantList = [];
      json['list'].forEach((v) {
        partcipantList?.add(new PartcipantInfo.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totalCount = json['totalCount'];
    message = json['message'];
    success = json['success'];
  }

}

class PartcipantInfo {
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
  bool isSelected = false;

  PartcipantInfo(
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

  PartcipantInfo.fromJson(Map<String, dynamic> json) {
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
    isSelected = false;
  }

}
