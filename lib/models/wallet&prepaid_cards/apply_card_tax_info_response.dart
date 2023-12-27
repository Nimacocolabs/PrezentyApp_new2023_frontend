class ApplyCardTaxInfoResponse {
  ApplyCardTaxInfoResponse({
      this.statusCode, 
      this.success, 
      this.data,});

  ApplyCardTaxInfoResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? ApplyCardTaxInfoData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  ApplyCardTaxInfoData? data;


}
class ApplyCardTaxInfoData {
  int? cardId;
  String? userId;
  String? amount;
  int? gst;
  String? payableAmount;
  String? discountPrice;
  int? insTableId;

  ApplyCardTaxInfoData(
      {this.cardId,
        this.userId,
        this.amount,
        this.gst,
        this.payableAmount,
        this.discountPrice,
        this.insTableId});

  ApplyCardTaxInfoData.fromJson(Map<String, dynamic> json) {
    cardId = json['card_id'];
    userId = json['user_id'];
    amount = json['amount'];
    gst = json['gst'];
    payableAmount = json['payable_amount'].toString();
    discountPrice = json['discount_price'];
    insTableId = json['ins_table_id'];
  }

}
