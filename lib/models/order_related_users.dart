class OrderRelatedUsers {
  String? message;
  bool? success;
  int? statusCode;
  List<UsersList>? usersList;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;

  OrderRelatedUsers(
      {this.message, this.success, this.statusCode, this.usersList, this.page,
        this.perPage,
        this.hasNextPage,
        this.totalCount});

  OrderRelatedUsers.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    statusCode = json['statusCode'];
    if (json['usersList'] != null) {
      usersList = [];
      json['usersList'].forEach((v) {
        usersList?.add(new UsersList.fromJson(v));
      });
    }


    dynamic pagenumber = json['page'];
    print(pagenumber.runtimeType);
    if (pagenumber is int) {
      page = json['page'];
    } else {
      page = int.parse(json['page']);
    }

    dynamic perPg = json['per_page'];
    print(perPg.runtimeType);
    if (perPg is int) {
      perPage = json['per_page'];
    } else {
      perPage = int.parse(json['per_page']);
    }

    hasNextPage = json['hasNextPage'] ?? false;

    dynamic totItemCount = json['totalCount'];
    print(totItemCount.runtimeType);
    if (totItemCount is int) {
      totalCount = json['totalCount'];
    } else {
      totalCount = int.parse(json['totalCount']);
    }

  }

}

class UsersList {
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

  UsersList(
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

  UsersList.fromJson(Map<String, dynamic> json) {
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
