class ExistingPayeeModel {
  ExistingPayeeModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  ExistingPayeeModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ExistingPayeeData.fromJson(v));
      });
    }
  }
  int? statusCode;
  bool? success;
  String? message;
  List<ExistingPayeeData>? data;



}

class ExistingPayeeData {
  ExistingPayeeData({
      this.id, 
      this.userId, 
      this.beneficiaryName, 
      this.walletNumber, 
      this.favorite, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  ExistingPayeeData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    beneficiaryName = json['beneficiary_name'];
    walletNumber = json['wallet_number'];
    favorite = json['favorite'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? userId;
  String? beneficiaryName;
  String? walletNumber;
  String? favorite;
  String? status;
  String? createdAt;
  String? updatedAt;



}