class HomscreenCommonApisModel {
  HomscreenCommonApisModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.sliderImages, 
      this.touchWalletDetails, 
      this.prepaidCards, 
      this.checkCardUserOrNot,
    this.notification_count,
      this.emailmobileverificationCheck,
  });

  HomscreenCommonApisModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['slider_images'] != null) {
      sliderImages = [];
      json['slider_images'].forEach((v) {
        sliderImages?.add(SliderImages.fromJson(v));
      });
    }
    touchWalletDetails = json['touch_wallet_details'] != null ? TouchWalletDetails.fromJson(json['touch_wallet_details']) : null;
    if (json['prepaid_cards'] != null) {
      prepaidCards = [];
      json['prepaid_cards'].forEach((v) {
        prepaidCards?.add(PrepaidCards.fromJson(v));
      });
    }
    checkCardUserOrNot = json['check_card_user_or_not'];
    emailmobileverificationCheck = json['email-mobile-verification_check'] != null ? EmailMobileVerificationCheck.fromJson(json['email-mobile-verification_check']) : null;
  }
  int? statusCode;
  bool? success;
  String? message;
  List<SliderImages>? sliderImages;
  TouchWalletDetails? touchWalletDetails;
  List<PrepaidCards>? prepaidCards;
  String? checkCardUserOrNot;
  int? notification_count;
  EmailMobileVerificationCheck? emailmobileverificationCheck;

}

class EmailMobileVerificationCheck {
  EmailMobileVerificationCheck({
      this.mobileVerify, 
      this.emailVerify, 
      this.idVerify, 
      this.panNumber, 
      this.aadarNumber,});

  EmailMobileVerificationCheck.fromJson(dynamic json) {
    mobileVerify = json['mobile_verify'];
    emailVerify = json['email_verify'];
    idVerify = json['id_verify'];
    panNumber = json['pan_number'];
    aadarNumber = json['aadar_number'];
  }
  String? mobileVerify;
  String? emailVerify;
  String? idVerify;
  String? panNumber;
  String? aadarNumber;


}

class PrepaidCards {
  PrepaidCards({
      this.id, 
      this.title, 
      this.slug, 
      this.shortDescription, 
      this.longDescription, 
      this.amount, 
      this.registrationPoints, 
      this.refferalPoint, 
      this.unReferedPoint, 
      this.referedPersonPoint, 
      this.amountRequestPhysical, 
      this.image, 
      this.imageUrl, 
      this.bgImg, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  PrepaidCards.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
    amount = json['amount'];
    registrationPoints = json['registration_points'];
    refferalPoint = json['refferal_point'];
    unReferedPoint = json['un_refered_point'];
    referedPersonPoint = json['refered_person_point'];
    amountRequestPhysical = json['amount_request_physical'];
    image = json['image'];
    imageUrl = json['image_url'];
    bgImg = json['bg_img'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? title;
  String? slug;
  String? shortDescription;
  String? longDescription;
  int? amount;
  String? registrationPoints;
  int? refferalPoint;
  int? unReferedPoint;
  int? referedPersonPoint;
  String? amountRequestPhysical;
  String? image;
  String? imageUrl;
  String? bgImg;
  String? status;
  String? createdAt;
  String? updatedAt;


}

class TouchWalletDetails {
  TouchWalletDetails({
      this.touchPoints, 
      this.walletBalance, 
      this.cardName, 
      this.unitTouchpoints, 
      this.iButtonWallet, 
      this.iButtonRewards,});

  TouchWalletDetails.fromJson(dynamic json) {
    touchPoints = json['touch_points'];
    walletBalance = json['wallet_balance'];
    cardName = json['card_name'];
    unitTouchpoints = json['unit_touchpoints'];
    iButtonWallet = json['i_button_wallet'];
    iButtonRewards = json['i_button_rewards'];
  }
  dynamic touchPoints;
  String? walletBalance;
  String? cardName;
  int? unitTouchpoints;
  String? iButtonWallet;
  String? iButtonRewards;



}

class SliderImages {
  SliderImages({
      this.id, 
      this.image, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  SliderImages.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;


}