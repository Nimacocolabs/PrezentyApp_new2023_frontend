class VoucherUserModel {
  bool? success;
  String? message;
  String? musicFilesLocation;
  String? imageFilesLocation;
  String? giftVoucherBaseUrl;
  int? statusCode;
  List<VoucherParticipantItem>? item;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  EventDetail? eventDetail;

  VoucherUserModel(
      {this.success,
        this.message,
        this.musicFilesLocation,
        this.imageFilesLocation,
        this.giftVoucherBaseUrl,
        this.statusCode,
        this.item,
        this.page,
        this.perPage,
        this.hasNextPage,
        this.totalCount,
        this.eventDetail});

  VoucherUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    musicFilesLocation = json['musicFilesLocation'];
    imageFilesLocation = json['imageFilesLocation'];
    giftVoucherBaseUrl = json['giftVoucherBaseUrl'];
    statusCode = json['statusCode'];
    if (json['list'] != null) {
      item = [];
      json['list'].forEach((v) {
        item?.add(new VoucherParticipantItem.fromJson(v));
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

    eventDetail = json['eventDetail'] != null
        ? new EventDetail.fromJson(json['eventDetail'])
        : null;
  }


}

class VoucherParticipantItem {
  int? id;
  String? participantName;
  double? amount;
  String? date;

  VoucherParticipantItem({this.id, this.participantName, this.amount, this.date});

  VoucherParticipantItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participantName = json['participantName'];

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

    date = json['date'];
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

