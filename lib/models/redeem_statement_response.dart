class RedeemStatementResponse {
  RedeemStatementResponse({
      this.statusCode, 
      this.data, 
      this.message,
       this.success,
  });

  RedeemStatementResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RedeemStatementData.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }
  int? statusCode;
  List<RedeemStatementData>? data;
  String? message;
  bool? success;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['statusCode'] = statusCode;
  //   if (data != null) {
  //     map['data'] = data?.map((v) => v.toJson()).toList();
  //   }
  //   map['message'] = message;
  //   map['success'] = success;
  //   return map;
  // }

}

class RedeemStatementData {
  RedeemStatementData({
      // this.id,
      this.eventId, 
      // this.type,
      this.amount, 
      // this.userId,
      // this.state,
      this.createdAt, 
      // this.status,
      this.name,});

  RedeemStatementData.fromJson(dynamic json) {
    // id = json['id'];
    eventId = json['event_id'];
    // type = json['type'];
    amount = json['amount'];
    // userId = json['user_id'];
    // state = json['state'];
    createdAt = json['created_at'];
    // status = json['status'];
    name = json['name'];
  }
  // String? id;
  String? eventId;
  // String? type;
  String? amount;
  // String? userId;
  // String? state;
  String? createdAt;
  // String? status;
  String? name;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   // map['id'] = id;
  //   map['event_id'] = eventId;
  //   map['type'] = type;
  //   map['amount'] = amount;
  //   map['user_id'] = userId;
  //   map['state'] = state;
  //   map['created_at'] = createdAt;
  //   map['status'] = status;
  //   map['name'] = name;
  //   return map;
  // }

}