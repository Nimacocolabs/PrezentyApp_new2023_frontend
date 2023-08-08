import 'user_details.dart';

class UserSignUpResponse {
  String? baseUrl;
  int? statusCode;
  bool? success;
  String? message;
  UserDetails? userDetails;
  String? apiToken;
 

  UserSignUpResponse({
      this.baseUrl,
      this.statusCode,
      this.success,
      this.message,
      this.userDetails,
      this.apiToken,
      });

  UserSignUpResponse.fromJson(dynamic json) {
    baseUrl = json["baseUrl"];
    statusCode = json["statusCode"];
    success = json["success"];
    message = json["message"];
    userDetails = success! && json["userDetails"] != null ? UserDetails.fromJson(json["userDetails"]) : null;
    apiToken = json["apiToken"];
   
  }


}
