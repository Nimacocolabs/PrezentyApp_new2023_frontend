
class CoinStatementResponse{
  int? statusCode;
  List<CoinStatementModel>? statementModel;


  CoinStatementResponse({
    this.statusCode,
    this.statementModel,
  });
  CoinStatementResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      statementModel = [];
      json['data'].forEach((v) {
        statementModel!.add(new CoinStatementModel.fromJson(v));
      });
    }
  }
}

class CoinStatementModel{
  String? coinTransferred;
  int? id;
  String? receivedAmt;
  String? redeemAmt;
  int? balanceEvent;

  CoinStatementModel({
    this.coinTransferred,
    this.id,
    this.receivedAmt,
    this.redeemAmt,
    this.balanceEvent,
});

  CoinStatementModel.fromJson(Map<String, dynamic> json) {
    coinTransferred=json["cointransfer"];
    id=json["id"];
    receivedAmt=json["receivedAmt"];
    redeemAmt=json["redeemAmt"];
    balanceEvent=json["balanceEvent"];
  }
}