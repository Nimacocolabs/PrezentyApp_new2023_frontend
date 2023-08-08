class GetEventBasedGiftModel {
  GetEventBasedGiftModel({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  GetEventBasedGiftModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? GetEventBasedGiftData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  String? message;
  GetEventBasedGiftData? data;



}

class GetEventBasedGiftData {
  GetEventBasedGiftData({
      this.id, 
      this.title, 
      this.date, 
      this.time, 
      this.imageUrl, 
      this.musicFileUrl, 
      this.userId, 
      this.vaNumber, 
      this.eAmount, 
      this.vaBank, 
      this.vaUpi, 
      this.vaIfsc, 
      this.videoFile, 
      this.createdBy, 
      this.status, 
      this.inviteMessage, 
      this.venue, 
      this.createdAt, 
      this.modifiedAt,
      this.walletNumber,
      this.wallet,
      
      });

  GetEventBasedGiftData.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    imageUrl = json['image_url'];
    musicFileUrl = json['music_file_url'];
    userId = json['user_id'];
    vaNumber = json['va_number'];
    eAmount = json['e_amount'];
    vaBank = json['va_bank'];
    vaUpi = json['va_upi'];
    vaIfsc = json['va_ifsc'];
    videoFile = json['video_file'];
    createdBy = json['created_by'];
    status = json['status'];
    inviteMessage = json['invite_message'];
    venue = json['venue'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    walletNumber = json['wallet_number'];
    wallet = json['wallet'];
  }
  int? id;
  String? title;
  String? date;
  String? time;
  String? imageUrl;
  dynamic musicFileUrl;
  int? userId;
  dynamic vaNumber;
  String? eAmount;
  dynamic vaBank;
  dynamic vaUpi;
  dynamic vaIfsc;
  dynamic videoFile;
  String? createdBy;
  int? status;
  String? inviteMessage;
  String? venue;
  String? createdAt;
  String? modifiedAt;
  String? walletNumber;
  String? wallet;


}