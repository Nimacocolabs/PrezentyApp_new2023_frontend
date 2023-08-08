import 'participant_response.dart';

class EventDetailsResponse {
  bool? success;
  String? musicFilesLocation;
  String? imageFilesLocation;
  String? baseUrlVideo;
  int? statusCode;
  String? message;
  bool? isParticipated;
  int? participantId;
  Detail? detail;
  List<ParticipantListItem> participantList=[];

  EventDetailsResponse({
      this.success, 
      this.musicFilesLocation, 
      this.baseUrlVideo,
      this.imageFilesLocation,
      this.statusCode, 
      this.message,
    this.isParticipated,
    this.detail,
    this.participantId, });

  EventDetailsResponse.fromJson(dynamic json) {
    success = json["success"];
    baseUrlVideo = json["baseUrlVideo"];
    musicFilesLocation = json["musicFilesLocation"];
    imageFilesLocation = json["imageFilesLocation"];
    statusCode = json["statusCode"];
    isParticipated = json['isParticipated'];
    participantId = json['participantId'];
    message = json["message"];
    detail = json["detail"] != null ? Detail.fromJson(json["detail"]) : null;
    if(detail==null){
      success = false;
    }
  }
}

class Detail {
  int? id;
  String? title;
  String? date;
  String? time;
  String? createdBy;
  String? imageUrl;
  String? videoFile;
  String? musicFileUrl;
  int? userId;
  int? status;
  String? createdAt;
  String? modifiedAt;
  String? vaNumber;

  Detail({
      this.id, 
      this.title, 
      this.date, 
      this.time, 
      this.createdBy,
      this.imageUrl,
      this.videoFile,
      this.musicFileUrl,
      this.userId, 
      this.status, 
      this.createdAt, 
      this.vaNumber,
      this.modifiedAt});

  Detail.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    date = json["date"];
    time = json["time"];
    createdBy = json["created_by"];
    videoFile = json["video_file"];
    imageUrl = json["image_url"];
    musicFileUrl = json["music_file_url"];
    userId = json["user_id"];
    status = json["status"];
    createdAt = json["created_at"];
    modifiedAt = json["modified_at"];
    vaNumber = json["va_number"];
  }
}
