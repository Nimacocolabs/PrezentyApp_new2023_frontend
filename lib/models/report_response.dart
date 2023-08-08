class ReportsResponse {
  String? message;
  int? statusCode;
  bool? success;
  List<ListItem>? list;

  ReportsResponse({this.message, this.statusCode, this.success, this.list});

  ReportsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new ListItem.fromJson(v));
      });
    }
  }

}

class ListItem {
  String? title;
  int? count;
  int? price;
  String? color;

  ListItem({this.title, this.count, this.price, this.color});

  ListItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    count = json['count'];
    price = json['price'];
    color = json['color'];
  }

}