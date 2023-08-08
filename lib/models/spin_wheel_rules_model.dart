class SpinWheelRulesModel {
  SpinWheelRulesModel({
      this.statusCode, 
      this.success, 
      this.data,});

  SpinWheelRulesModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? SpinWheelRulesData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  SpinWheelRulesData? data;



}

class SpinWheelRulesData {
  SpinWheelRulesData({
      this.id, 
      this.conditions,});

  SpinWheelRulesData.fromJson(dynamic json) {
    id = json['id'];
    conditions = json['conditions'];
  }
  int? id;
  String? conditions;


}