// To parse this JSON data, do
//
//     final stateCode = stateCodeFromJson(jsonString);

import 'dart:convert';

StateCodeResponse stateCodeFromJson(String str) =>
    StateCodeResponse.fromJson(json.decode(str));

class StateCodeResponse {
  StateCodeResponse({
    this.data,
    this.success,
    this.statusCode,
    this.message,
  });

  List<States>? data;
  bool? success;
  int? statusCode;
  String? message;

  factory StateCodeResponse.fromJson(Map<String, dynamic> json) =>
      StateCodeResponse(
        data: List<States>.from(json["data"].map((x) => States.fromJson(x))),
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
      );
}

class States {
  States({
    this.stateId,
    this.stateTitle,
    this.status,
  });

  int? stateId;
  String? stateTitle;
  String? status;

  factory States.fromJson(Map<String, dynamic> json) => States(
        stateId: json["state_id"],
        stateTitle: json["state_title"],
        status: json["status"],
      );
}
