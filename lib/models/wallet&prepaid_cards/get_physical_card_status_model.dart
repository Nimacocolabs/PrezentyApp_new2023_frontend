class GetPhysicalCardStatusModel {
  GetPhysicalCardStatusModel({
      this.message, 
      this.statusCode, 
      this.success, 
     // this.data, 
      this.apply, 
      this.cardstatus,});

  GetPhysicalCardStatusModel.fromJson(dynamic json) {
    message = json['message'];
    statusCode = json['statusCode'];
    success = json['success'];
    // if (json['data'] != null) {
    //   data = [];
    //   json['data'].forEach((v) {
    //     data?.add(Dynamic.fromJson(v));
    //   });
    // }
    apply = json['apply'];
    cardstatus = json['Cardstatus'];
  }
  String? message;
  int? statusCode;
  bool? success;
  //List<dynamic>? data;
  String? apply;
  String? cardstatus;


}