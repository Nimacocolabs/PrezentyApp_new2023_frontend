import 'dart:convert';
import 'package:event_app/models/my_voucher_response.dart';
import 'package:event_app/models/redeemed_voucher_list_response.dart';
import 'package:event_app/models/send_food_order_list_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/apis.dart';
import 'package:flutter/foundation.dart';

import '../models/receive_statement_response.dart';
import '../models/redeem_statement_response.dart';

class VoucherReportRepository {
  late ApiProvider apiProvider;

  VoucherReportRepository() {
    apiProvider = new ApiProvider();
  }

  Future<ReportOrderListResponse> getRedeemOrders(int eventId) async {
    final response = await apiProvider
        .getJsonInstance()
        .get("${Apis.getRedeemOrders}?event_id=$eventId");
    return ReportOrderListResponse.fromJson(response.data);
  }

  Future<ReportOrderListResponse> getReportOrders(
      bool isRedeemOrders, int eventId) async {
    final response = await apiProvider.getJsonInstance().get(
        "${isRedeemOrders ? Apis.getRedeemOrders : Apis.getSendFoodOrders}?event_id=$eventId");
    return ReportOrderListResponse.fromJson(response.data);
  }

  Future<MyVoucherListResponse> getMyVoucherOrders(
      bool isSentVouchers, String userId) async {
    final response = await apiProvider.getJsonInstance().get(
        '${isSentVouchers ? Apis.getMyVoucherOrdersBought : Apis.getMyVoucherOrdersReceived}?user_id=$userId');
    return MyVoucherListResponse.fromJson(response.data);
  }

  Future<RedeemedVoucherListResponse> getRedeemedVoucherList(
      String userId) async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.getRedeemedVoucherList}?user_id=$userId');
    return RedeemedVoucherListResponse.fromJson(response.data);
  }

  Future<RedeemStatementResponse> getRedeemStatement(
      int eventId) async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.redeemStatementTable}?event_id=$eventId');
    return RedeemStatementResponse.fromJson(response.data);
  }

  Future<ReceiveStatementResponse> getReceiveStatement(
      int eventId) async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.receiveStatementTable}?event_id=$eventId');
    return ReceiveStatementResponse.fromJson(response.data);
  }
}
