import 'dart:convert';

RequestPhysicalCardResponse requestPhysicalCardResponseFromJson(String str) =>
    RequestPhysicalCardResponse.fromJson(json.decode(str));

class RequestPhysicalCardResponse {
  RequestPhysicalCardResponse({
    this.statusCode,
  //  this.responseCode,
    this.message,
    this.success,
    //  this.data,
  });

  int? statusCode;
  //String? responseCode;
  String? message;
  bool? success;

  // Data? data;

  RequestPhysicalCardResponse.fromJson(dynamic json) {
    statusCode = json["statusCode"];
   // responseCode = json["responseCode"];
    message = json["message"];
    success = json["success"];
    // data = Data.fromJson(
    //   json["data"],
    // );
  }
}

// class Data {
//   Data({
//
//   });
//
//
//
//   Data.fromJson(Map<String, dynamic> json) {
//
//   }
// }
