class PickMusicResponse {
  String? baseUrl;
  int? statusCode;
  List<ListItem>? list;
  int? page;
  int? perPage;
  bool? hasNextPage;
  int? totalCount;
  String? message;
  bool? success;

  PickMusicResponse({
      this.baseUrl, 
      this.statusCode, 
      this.list, 
      this.page, 
      this.perPage, 
      this.hasNextPage, 
      this.totalCount, 
      this.message, 
      this.success});

  PickMusicResponse.fromJson(dynamic json) {
    baseUrl = json["baseUrl"];
    statusCode = json["statusCode"];
    if (json["list"] != null) {
      list = [];
      json["list"].forEach((v) {
        list?.add(ListItem.fromJson(v));
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

class ListItem {
  int? id;
  String? musicFileUrl;
  int? status;
  String? createdAt;
  String? modifiedAt;

  ListItem({
      this.id, 
      this.musicFileUrl, 
      this.status, 
      this.createdAt, 
      this.modifiedAt});

  ListItem.fromJson(dynamic json) {
    id = json["id"];
    musicFileUrl = json["music_file_url"];
    status = json["status"];
    createdAt = json["created_at"];
    modifiedAt = json["modified_at"];
  }
}