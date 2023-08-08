//{"message":"No physical card available to set pin","statusCode":500,"success":false}

import 'dart:convert';

CheckPhysicalCardExistsResponse checkPhysicalCardExistsResponseFromJson(
        String str) =>
    CheckPhysicalCardExistsResponse.fromJson(json.decode(str));

class CheckPhysicalCardExistsResponse {
  CheckPhysicalCardExistsResponse({
    this.statusCode,
    this.message,
    this.success,
  });

  int? statusCode;

  String? message;
  bool? success;

  CheckPhysicalCardExistsResponse.fromJson(dynamic json) {
    statusCode = json["statusCode"];
    message = json["message"];
    success = json["success"];
  }
}
