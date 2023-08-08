class HomeEventsResponse {
  String? musicFilesLocation;
  String? imageFilesLocation;
  String? videoFileUrl;
  int? statusCode;
  List<EventItem> eventList =[];
  List<EventItem> inviteList=[];
  List<EventItem>? list; // fav, my events
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  String? message;
  bool? success;

  HomeEventsResponse({
      this.musicFilesLocation, 
      this.videoFileUrl,
      this.imageFilesLocation,
      this.statusCode,
      this.eventList= const [],
      this.inviteList= const [],
    this.list,
    this.page,
      this.perPage, 
      this.hasNextPage, 
      this.totalCount, 
      this.message, 
      this.success});

  HomeEventsResponse.fromJson(dynamic json) {
    musicFilesLocation = json["musicFilesLocation"];
    imageFilesLocation = json["imageFilesLocation"];
    videoFileUrl =  json["baseUrlVideo"];
    statusCode = json["statusCode"];
    eventList = [];
    if (json["eventList"] != null) {
      json["eventList"].forEach((v) {
        eventList.add(EventItem.fromJson(v));
      });
    }
    inviteList = [];
    if (json["inviteList"] != null) {
      json["inviteList"].forEach((v) {
        inviteList.add(EventItem.fromJson(v));
      });
    }
    list = [];
    if (json['list'] != null) {
      json['list'].forEach((v) {
        if(v!=null) list!.add(new EventItem.fromJson(v));
      });
    }
    page = json["page"];
    perPage = json["perPage"];
    hasNextPage = json["hasNextPage"];
    totalCount = json["totalCount"];
    message = json["message"];
    success = json["success"];
  }

}

class EventItem {
  int? id;
  String? title;
  String? date;
  String? time;
  String? imageUrl;
  String? musicFileUrl;
  String? videoFile;
  int? userId;
  int? status;
  String? createdAt;
  String? modifiedAt;
  bool? isFavourite;

  EventItem({
      this.id, 
      this.title, 
      this.date, 
      this.time, 
      this.imageUrl, 
      this.musicFileUrl, 
      this.videoFile,
      this.userId,
      this.status, 
      this.createdAt, 
      this.modifiedAt});

  EventItem.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    date = json["date"];
    time = json["time"];
    imageUrl = json["image_url"];
    videoFile = json["video_file"];
    musicFileUrl = json["music_file_url"];
    userId = json["user_id"];
    status = json["status"];
    createdAt = json["created_at"];
    modifiedAt = json["modified_at"];
    isFavourite = json["is_favourite"] ?? false;
  }

}