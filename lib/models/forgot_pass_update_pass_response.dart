class ForgotPassUpdatePassResponse {
  List<Result>? result;
  int? statusCode;
  String? message;

  ForgotPassUpdatePassResponse({
      this.result, 
      this.statusCode, 
      this.message});

  ForgotPassUpdatePassResponse.fromJson(dynamic json) {
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

}

class Result {
  int? accountId;

  Result({
      this.accountId});

  Result.fromJson(dynamic json) {
    accountId = json['account_id'];
  }

}