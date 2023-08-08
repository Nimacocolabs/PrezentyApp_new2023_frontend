class CreateEventResponse {
  Detail? detail;
  String? message;
  int? statusCode;
  bool? success;

  CreateEventResponse({
      this.detail, 
      this.message, 
      this.statusCode, 
      this.success});

  CreateEventResponse.fromJson(dynamic json) {
   // print('''${json['detail']}''');
    detail = json['detail'] != null || json['detail'].toString() != 'null' ? Detail.fromJson(json['detail']) : null;
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
  }
}

class Detail {
  String? title;
  String? date;
  String? time;
  int? userId;
  int? id;
  String? imageUrl;

  Detail({
      this.title, 
      this.date, 
      this.time, 
      this.userId, 
      this.id, 
      this.imageUrl});

  Detail.fromJson(dynamic json) {
    title = json['title'];
    date = json['date'];
    time = json['time'];
    userId = json['user_id'];
    id = json['id'];
    imageUrl = json['image_url'];
  }

}