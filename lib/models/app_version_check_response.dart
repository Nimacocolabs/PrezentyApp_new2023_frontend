class AppVersionCheckResponse {
  AppVersionCheckResponse({
      this.statusCode, 
      this.success, 
      this.data,});

  AppVersionCheckResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['success'] = success;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.id, 
      this.appVersion, 
      this.isLivePlayStore, 
      this.isLiveAppStore, 
      this.buildNumber, 
      this.createdAt, 
      this.updatedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    appVersion = json['app_version'];
    isLivePlayStore = json['is_live_play_store'];
    isLiveAppStore = json['is_live_app_store'];
    buildNumber = json['build_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? appVersion;
  int? isLivePlayStore;
  int? isLiveAppStore;
  int? buildNumber;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['app_version'] = appVersion;
    map['is_live_play_store'] = isLivePlayStore;
    map['is_live_app_store'] = isLiveAppStore;
    map['build_number'] = buildNumber;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}