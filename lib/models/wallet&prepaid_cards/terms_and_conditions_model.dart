class TermsAndConditionsModel {
  TermsAndConditionsModel({
      this.statusCode, 
      this.success, 
      this.data,});

  TermsAndConditionsModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? TermsAndConditionsData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  TermsAndConditionsData? data;



}

class TermsAndConditionsData {
  TermsAndConditionsData({
      this.id, 
      this.termsCondition,});

  TermsAndConditionsData.fromJson(dynamic json) {
    id = json['id'];
    termsCondition = json['terms_condition'];
  }
  int? id;
  String? termsCondition;

 

}