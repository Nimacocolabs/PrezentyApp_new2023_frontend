class UserPermanentAddressModel {
  UserPermanentAddressModel({
      this.statusCode, 
      this.success, 
      this.data,});

  UserPermanentAddressModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? UserPermanentAddressData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  UserPermanentAddressData? data;



}

class UserPermanentAddressData {
  UserPermanentAddressData({
      this.id, 
      this.userId, 
      this.firstName, 
      this.lastName, 
      this.dateOfBirth, 
      this.gender, 
      this.panNumber, 
      this.aadhaarNumber, 
      this.addressType, 
      this.addressCard, 
      this.pinCode, 
      this.city, 
      this.stateCode, 
      this.status, 
      this.createdAt, 
      this.updatedAt,
      this.stateName,
      });

  UserPermanentAddressData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    panNumber = json['pan_number'];
    aadhaarNumber = json['aadhaar_number'];
    addressType = json['address_type'];
    addressCard = json['address_card'];
    pinCode = json['pin_code'];
    city = json['city'];
    stateCode = json['state_code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stateName = json['state_name'];
  }
  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? panNumber;
  String? aadhaarNumber;
  String? addressType;
  String? addressCard;
  String? pinCode;
  String? city;
  int? stateCode;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? stateName;




}