class ForgotPassVerifyOtpResponse {
  Result? result;
  int? statusCode;
  String? message;

  ForgotPassVerifyOtpResponse({
      this.result, 
      this.statusCode, 
      this.message});

  ForgotPassVerifyOtpResponse.fromJson(dynamic json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

}

class Result {
  String? passwordResetToken;
  int? accountId;
  int? otpVerified;

  Result({
      this.passwordResetToken, 
      this.accountId, 
      this.otpVerified});

  Result.fromJson(dynamic json) {
    passwordResetToken = json['password_reset_token'];
    accountId = json['account_id'];
    otpVerified = json['otp_verified'];
  }

}