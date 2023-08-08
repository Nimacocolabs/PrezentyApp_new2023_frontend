class ForgotPassSendOtpResponse {
  bool? success=false;
  List<Result>? result;
  int? statusCode;
  String? message;

  ForgotPassSendOtpResponse({
    this.success ,
      this.result, 
      this.statusCode, 
      this.message});

  ForgotPassSendOtpResponse.fromJson(dynamic json) {
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
    success=(result??[]).isNotEmpty;
    statusCode = json["statusCode"];
    message = json["message"];
  }

}

class Result {
  int? otp;

  Result({
      this.otp});

  Result.fromJson(dynamic json) {
    otp = json["otp"];
  }

}