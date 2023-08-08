class FetchUserDetailsModel {
  FetchUserDetailsModel({
    this.message,
    this.statusCode,
    this.success,
    this.data,
  });

  FetchUserDetailsModel.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? fetchUserData.fromJson(json['data']) : null;
  }
  String? message;
  int? statusCode;
  bool? success;
  fetchUserData? data;
}

class fetchUserData {
  fetchUserData(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.phoneNumber,
      this.passwordHash,
      this.authKey,
      this.role,
      this.status,
      this.createdAt,
      this.modifiedAt,
      this.address,
      this.imageUrl,
      this.countryCode,
      this.idCopy,
      this.passwordResetToken,
      this.salesPerson,
      this.isSocialSignUp,
      this.userMpin,
      this.emailVerified,
      this.mobileVerified,
      this.panNumber,
      this.aadarNumber,
      this.idVerified,
      this.aadarVerified,
      this.pinCode,
      this.city,
      this.stateCode,
      this.statename,
      this.cardname,
      this.prepaidPanNumber,
      this.vaNumber,
      this.vaUpi,
      this.vaIfsc,
      this.walletNumber,
      });

  fetchUserData.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    passwordHash = json['password_hash'];
    authKey = json['auth_key'];
    role = json['role'];
    status = json['status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    address = json['address'];
    imageUrl = json['image_url'];
    countryCode = json['country_code'];
    idCopy = json['id_copy'];
    passwordResetToken = json['password_reset_token'];
    salesPerson = json['sales_person'];
    isSocialSignUp = json['is_social_sign_up'];
    userMpin = json['user_mpin'];
    emailVerified = json["email_verified"];
    mobileVerified = json["mobile_verified"];
    panNumber = json["pan_number"];
    aadarNumber = json["aadar_number"];
    idVerified = json["ID_verified"];
    aadarVerified = json["aadar_verified"];
    pinCode = json['pin_code'];
    city = json['city'];
    stateCode = json['state_code'];
    statename = json['statename'];
    cardname = json['cardname'];
    prepaidPanNumber = json['prepaid_pan_number'];
    vaNumber = json["va_number"];
    vaUpi = json["va_upi"];
    vaIfsc = json["va_ifsc"];
    walletNumber = json['wallet_number'];
    
  }
  int? id;
  String? username;
  String? name;
  String? email;
  String? phoneNumber;
  String? passwordHash;
  dynamic authKey;
  String? role;
  int? status;
  String? createdAt;
  String? modifiedAt;
  String? address;
  String? imageUrl;
  int? countryCode;
  String? idCopy;
  dynamic passwordResetToken;
  String? salesPerson;
  int? isSocialSignUp;
  String? userMpin;
  String? pinCode;
  String? city;
  int? stateCode;
  String? statename;
  String? cardname;
  String? emailVerified;
  String? mobileVerified;
  dynamic panNumber;
  dynamic aadarNumber;
  String? idVerified;
  String? aadarVerified;
  String? prepaidPanNumber;
  String? vaNumber;
  String? vaUpi;
  String? vaIfsc;
  String?  walletNumber;
}
