class MyWishesResponse {
  String? baseUrl;
  int? statusCode;
  List<MyWishListItem>? list;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  String? message;
  bool? success;

  MyWishesResponse(
      {this.baseUrl,
      this.statusCode,
      this.list,
      this.page,
      this.perPage,
      this.hasNextPage,
      this.totalCount,
      this.message,
      this.success});

  MyWishesResponse.fromJson(Map<String, dynamic> json) {
    baseUrl = json['baseUrl'];
    statusCode = json['statusCode'];
    if (json["list"] != null) {
      list = [];
      json["list"].forEach((v) {
        list?.add(MyWishListItem.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totalCount = json['totalCount'];
    message = json['message'];
    success = json['success'];
  }

}

class MyWishListItem {
  int? id;
  String? videoUrl;
  String? caption;
  String? date;
  String? name;
  String? time;
  String? email;

  MyWishListItem({this.id, this.videoUrl, this.caption, this.date, this.name,this.time,this.email});

  MyWishListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoUrl = json['video_url'];
    caption = json['caption'];
    date = json['date'];
    name = json['name'];
    time = json['time'];
    email = json['email'];
  }

}