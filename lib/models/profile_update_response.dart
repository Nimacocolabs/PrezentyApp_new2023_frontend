import 'user_details.dart';

class UpdateProfileResponse {
  int? statusCode;
  bool? success;
  String? message;
  UserDetails? userDetails;

  UpdateProfileResponse(
      {this.statusCode, this.success, this.message, this.userDetails});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

}
