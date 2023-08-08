class TouchPointWalletBalanceResponse {
  TouchPointWalletBalanceResponse({
      this.statusCode, 
      this.success, 
      this.message, 
      this.data,});

  TouchPointWalletBalanceResponse.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? TouchPointWalletBalanceData.fromJson(json['data']) : null;
  }
  int? statusCode;
  bool? success;
  String? message;
  TouchPointWalletBalanceData? data;
}

class TouchPointWalletBalanceData {
  TouchPointWalletBalanceData({
      this.touchPoints, 
      this.walletBalance, 
      this.unitTouchpoints,
      this.cardName,
      this.walletInfoContent,
      this.hiRewardsInfoContent,
      });

  TouchPointWalletBalanceData.fromJson(dynamic json) {
    touchPoints = json['touch_points'];
    walletBalance = json['wallet_balance'];
    unitTouchpoints = json['unit_touchpoints'];
    cardName = json['card_name'];
    walletInfoContent = json['i_button_wallet'];
    hiRewardsInfoContent = json['i_button_rewards'];
  }
  dynamic touchPoints;
  dynamic walletBalance;
  dynamic unitTouchpoints;
  String? cardName;
  String? walletInfoContent;
  String? hiRewardsInfoContent;
}