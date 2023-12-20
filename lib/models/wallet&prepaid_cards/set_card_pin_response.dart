import 'dart:convert';

SetCardPinResponse setCardPinResponseFromJson(String str) =>
    SetCardPinResponse.fromJson(json.decode(str));


class SetCardPinResponse {
  bool? success;
  int? statusCode;
  String? message;
  String? widgetUrl;

  SetCardPinResponse(
      {this.success, this.statusCode, this.message, this.widgetUrl});

  SetCardPinResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    widgetUrl = json['widgetUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['widgetUrl'] = this.widgetUrl;
    return data;
  }
}

// class SetCardPinResponse {
//   SetCardPinResponse({
//     this.statusCode,
//     // this.responseCode,
//     this.message,
//     this.success,
//     this.data,
//   });
//
//   int? statusCode;
//
//   // String? responseCode;
//   String? message;
//   bool? success;
//   Data? data;
//
//   SetCardPinResponse.fromJson(dynamic json) {
//     statusCode = json["statusCode"];
//     //responseCode = json["responseCode"];
//     message = json["message"];
//     success = json["success"];
//     data = json["data"] != null
//         ? Data.fromJson(
//             json["data"],
//           )
//         : null;
//   }
// }
//
// class Data {
//   String? transactionStatus;
//   String? transactionDescription;
//   String? url;
//
//   Data({this.transactionStatus, this.transactionDescription, this.url});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     transactionStatus = json['transactionStatus'];
//     transactionDescription = json['transactionDescription'];
//     url = json['url'];
//   }
// }

