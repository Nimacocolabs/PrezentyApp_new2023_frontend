class VoucherDetailModel {
  bool? success;
  String? message;
  String? musicFilesLocation;
  String? imageFilesLocation;
  String? barcodeLocation;
  String? giftVoucherBaseUrl;
  int? statusCode;
  Result? result;
  EventDetail? eventDetail;
  List<TransactionHistory>? transactionHistory;

  VoucherDetailModel(
      {this.success,
        this.message,
        this.musicFilesLocation,
        this.imageFilesLocation,
        this.barcodeLocation,
        this.giftVoucherBaseUrl,
        this.statusCode,
        this.result,
        this.eventDetail,
        this.transactionHistory});

  VoucherDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    musicFilesLocation = json['musicFilesLocation'];
    imageFilesLocation = json['imageFilesLocation'];
    barcodeLocation = json['barcodeLocation'];
    giftVoucherBaseUrl = json['giftVoucherBaseUrl'];
    statusCode = json['statusCode'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    eventDetail = json['eventDetail'] != null
        ? new EventDetail.fromJson(json['eventDetail'])
        : null;
    if (json['transactionHistory'] != null) {
      transactionHistory = [];
      json['transactionHistory'].forEach((v) {
        transactionHistory?.add(new TransactionHistory.fromJson(v));
      });
    }
  }

}

class Result {
  int? id;
  String? giftVoucherImageUrl;
  String? giftVoucherTitle;
  String? giftVoucherDescription;
  String? barcode;
  String? cardNumber;
  double? totalAmount;
  double? activeAmount;
  double? inactiveAmount;
  bool? isActive;
  double? availableAmount;

  Result(
      {this.id,
        this.giftVoucherImageUrl,
        this.giftVoucherTitle,
        this.giftVoucherDescription,
        this.barcode,
        this.cardNumber,
        this.totalAmount,
        this.isActive,
        this.inactiveAmount,
        this.activeAmount,
        this.availableAmount});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    giftVoucherImageUrl = json['giftVoucherImageUrl'];
    giftVoucherTitle = json['giftVoucherTitle'];
    giftVoucherDescription = json['giftVoucherDescription'];
    barcode = json['barcode'];
    try {
      cardNumber = (json['cardNumber']??'0').toString();
    } catch (e) {
      cardNumber = '';
    }

    if (json['totalAmount'] != null) {
      dynamic totAmt = json['totalAmount'];
      if (totAmt is int) {
        totalAmount = json['totalAmount'].toDouble();
      } else {
        totalAmount = json['totalAmount'];
      }
    } else {
      totalAmount = 0.0;
    }

    if (json['inActiveAmount'] != null) {
      dynamic amt = json['inActiveAmount'];
      if (amt is int) {
        inactiveAmount = json['inActiveAmount'].toDouble();
      } else {
        inactiveAmount = json['inActiveAmount'];
      }
    } else {
      inactiveAmount = 0.0;
    }
    if (json['activeAmount'] != null) {
      dynamic amt = json['activeAmount'];
      if (amt is int) {
        activeAmount = json['activeAmount'].toDouble();
      } else {
        activeAmount = json['activeAmount'];
      }
    } else {
      activeAmount = 0.0;
    }

    isActive = json['isActive'];

    if (json['availableAmount'] != null) {
      dynamic avlAmt = json['availableAmount'];
      if (avlAmt is int) {
        availableAmount = json['availableAmount'].toDouble();
      } else {
        availableAmount = json['availableAmount'];
      }
    } else {
      availableAmount = 0.0;
    }

  }

}

class EventDetail {
  int? id;
  String? title;
  String? date;
  String? time;
  String? imageUrl;
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
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

}

class TransactionHistory {
  String? key;
  List<Value>? value;

  TransactionHistory({this.key, this.value});

  TransactionHistory.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    if (json['value'] != null) {
      value = [];
      json['value'].forEach((v) {
        value?.add(new Value.fromJson(v));
      });
    }
  }

}

class Value {
  int? id;
  int? eventGiftVoucherId;
  int? userId;
  int? eventId;
  double? amount;
  String? date;
  int? status;
  String? createdAt;
  String? modifiedAt;

  Value(
      {this.id,
        this.eventGiftVoucherId,
        this.userId,
        this.eventId,
        this.amount,
        this.date,
        this.status,
        this.createdAt,
        this.modifiedAt});

  Value.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventGiftVoucherId = json['event_gift_voucher_id'];
    userId = json['user_id'];
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

    date = json['date'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

}

