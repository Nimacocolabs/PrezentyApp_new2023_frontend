class UserDetails {
  int? id;
  String? name;
  String? email;
  String? virtualAccount;
  int? countryCode;
  String? phoneNumber;
  String? address;
  String? role;
  String? imageUrl;
  String? idCopy;
  bool? isSocialSignUp;
  bool? hasPassword;
  bool? hasMPin;
  String? userVerified;
  int? hiCardId;
  String? hiCardNo;
  int? hiCardPin;
  dynamic hiCardBalance;
  UserDetails({
    this.id,
    this.name,
    this.email,
    this.virtualAccount,
    this.countryCode,
    this.phoneNumber,
    this.address,
    this.role,
    this.imageUrl,
    this.idCopy,
    this.hasPassword,
    this.hasMPin,
    this.userVerified,
    this.hiCardId,
    this.hiCardNo,
    this.hiCardPin,
    this.hiCardBalance,
    
  }
  );

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    virtualAccount = json['virtualAccount'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    role = json['role'];
    imageUrl = json['image_url'] ?? "";
    idCopy = json['id_copy'] ?? "";
    isSocialSignUp = (json['is_social_sign_up'] ?? 0) == 1;
    hasPassword = json['has_password'];
    //hasMPin = json['user_mpin'] != null ?true:false;
    hasMPin = json['user_mpin'] ?? false;
    userVerified = json['user_verified'];
    hiCardId = json['hi_card_id'];
    hiCardNo = json['card_number'];
    hiCardPin = json['pin_number'];
    hiCardBalance = json['balance_hicard'];
  }

}
