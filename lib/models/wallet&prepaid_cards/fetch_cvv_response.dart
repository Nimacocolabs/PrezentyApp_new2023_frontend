import 'dart:convert';

FetchCardCvvResponse fetchCVVResponseFromJson(String str) =>
    FetchCardCvvResponse.fromJson(json.decode(str));

class FetchCardCvvResponse {
  FetchCardCvvResponse({
    this.statusCode,
    // this.responseCode,
    this.message,
    this.success,
    this.data,
  });

  int? statusCode;

  // String? responseCode;
  String? message;
  bool? success;
  Data? data;

  FetchCardCvvResponse.fromJson(dynamic json) {
    statusCode = json["statusCode"];
    //responseCode = json["responseCode"];
    message = json["message"];
    success = json["success"];
    data = json["data"] != null
        ? Data.fromJson(
            json["data"],
          )
        : null;
  }
}

class Data {
  String? transactionStatus;
  String? transactionDescription;
  String? url;

  Data({this.transactionStatus, this.transactionDescription, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    transactionStatus = json['transactionStatus'];
    transactionDescription = json['transactionDescription'];
    url = json['url'];
  }

// class Data {
//   Data({
//     this.link,
//   });
//
//   String? link;
//
//   Data.fromJson(Map<String, dynamic> json) {
//     link = json["link"];
} //   }
