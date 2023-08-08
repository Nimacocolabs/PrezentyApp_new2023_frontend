import 'dart:convert';

class ValidateCardResponse {
  ValidateCardResponse({
    this.statusCode,
    this.success,
    this.data,
  });

  int? statusCode;
  bool? success;
  ValidateCardData? data;

  factory ValidateCardResponse.fromJson(Map<String, dynamic> json) =>
      ValidateCardResponse(
        statusCode: json["statusCode"],
        success: json["success"],
        data: ValidateCardData.fromJson(json["data"]),
      );
}

class ValidateCardData {
  ValidateCardData({
    this.verified,
  });

  String? verified;

  factory ValidateCardData.fromJson(Map<String, dynamic> json) =>
      ValidateCardData(
        verified: json["verified"],
      );
}
