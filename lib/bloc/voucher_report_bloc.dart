import 'dart:async';
import 'package:event_app/models/my_voucher_response.dart';
import 'package:event_app/models/send_food_order_list_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/voucher_report_repository.dart';

import '../models/receive_statement_response.dart';
import '../models/redeem_statement_response.dart';
import '../models/redeemed_voucher_list_response.dart';

class VoucherReportBloc {
  VoucherReportRepository _repository = VoucherReportRepository();

  late StreamController<ApiResponse<dynamic>>_sendFoodOrderListController;
  StreamSink<ApiResponse<dynamic>> get _sendFoodOrderListSink => _sendFoodOrderListController.sink;
  Stream<ApiResponse<dynamic>> get sendFoodOrderListStream => _sendFoodOrderListController.stream;

   late StreamController<ApiResponse<dynamic>>_myVoucherOrderListController;
  StreamSink<ApiResponse<dynamic>> get _myVoucherOrderListSink => _myVoucherOrderListController.sink;
  Stream<ApiResponse<dynamic>> get myVoucherOrderListStream => _myVoucherOrderListController.stream;

  late StreamController<ApiResponse<dynamic>>_redeemedVoucherListController;
  StreamSink<ApiResponse<dynamic>> get _redeemedVoucherListSink => _redeemedVoucherListController.sink;
  Stream<ApiResponse<dynamic>> get redeemedVoucherListStream => _redeemedVoucherListController.stream;

  late StreamController<ApiResponse<dynamic>>_redeemStatementListController;
  StreamSink<ApiResponse<dynamic>> get _redeemStatementListSink => _redeemStatementListController.sink;
  Stream<ApiResponse<dynamic>> get redeemStatementListStream => _redeemStatementListController.stream;

  late StreamController<ApiResponse<dynamic>>_receiveStatementListController;
  StreamSink<ApiResponse<dynamic>> get _receiveStatementListSink => _receiveStatementListController.sink;
  Stream<ApiResponse<dynamic>> get receiveStatementListStream => _receiveStatementListController.stream;

  VoucherReportBloc() {
    _sendFoodOrderListController = StreamController<ApiResponse<dynamic>>.broadcast();
    _myVoucherOrderListController = StreamController<ApiResponse<dynamic>>.broadcast();
    _redeemedVoucherListController = StreamController<ApiResponse<dynamic>>.broadcast();
    _redeemStatementListController = StreamController<ApiResponse<dynamic>>.broadcast();
    _receiveStatementListController = StreamController<ApiResponse<dynamic>>.broadcast();
  }

  getReportOrders(int eventId,{required bool isRedeemOrders}) async {
    try {
      _sendFoodOrderListSink.add(ApiResponse.loading('Fetching'));

      ReportOrderListResponse response = await _repository.getReportOrders(isRedeemOrders,eventId);
      if(response.success??false){
        _sendFoodOrderListSink.add(ApiResponse.completed(response));
      }else{
        _sendFoodOrderListSink.add(ApiResponse.error(response.message??'Something went wrong'));
      }
    } catch (e,s) {
      Completer().completeError(e,s);
      _sendFoodOrderListSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  getMyVoucherOrders(String userId,{required bool isSentVouchers}) async {
    try {
      _myVoucherOrderListSink.add(ApiResponse.loading('Fetching'));

      MyVoucherListResponse response = await _repository.getMyVoucherOrders(isSentVouchers,userId);
      if(response.success??false){
        _myVoucherOrderListSink.add(ApiResponse.completed(response));
      }else{
        _myVoucherOrderListSink.add(ApiResponse.error(response.message??'Something went wrong'));
      }
    } catch (e,s) {
      Completer().completeError(e,s);
      _myVoucherOrderListSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  getRedeemedVoucherList(String userId) async {
    try {
      _redeemedVoucherListSink.add(ApiResponse.loading('Fetching'));

      RedeemedVoucherListResponse response = await _repository.getRedeemedVoucherList(userId);
      if(response.success??false){
        _redeemedVoucherListSink.add(ApiResponse.completed(response));
      }else{
        _redeemedVoucherListSink.add(ApiResponse.error(response.message??'Something went wrong'));
      }
    } catch (e,s) {
      Completer().completeError(e,s);
      _redeemedVoucherListSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  getRedeemStatement(int eventId) async {
    try {
      _redeemStatementListSink.add(ApiResponse.loading('Fetching'));

      RedeemStatementResponse response = await _repository.getRedeemStatement(eventId);
      if(response.success??false){
        _redeemStatementListSink.add(ApiResponse.completed(response));
      }else{
        _redeemStatementListSink.add(ApiResponse.error(response.message??'Something went wrong'));
      }
    } catch (e,s) {
      Completer().completeError(e,s);
      _redeemStatementListSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }
  getReceiveStatement(int eventId) async {
    try {
      _receiveStatementListSink.add(ApiResponse.loading('Fetching'));

      ReceiveStatementResponse response = await _repository.getReceiveStatement(eventId);
      if(response.success??false){
        _receiveStatementListSink.add(ApiResponse.completed(response));
      }else{
        _receiveStatementListSink.add(ApiResponse.error(response.message??'Something went wrong'));
      }
    } catch (e,s) {
      Completer().completeError(e,s);
      _receiveStatementListSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  dispose() {
    _sendFoodOrderListSink.close();
    _sendFoodOrderListController.close();
    _myVoucherOrderListSink.close();
    _myVoucherOrderListController.close();
    _redeemedVoucherListSink.close();
    _redeemStatementListController.close();
    _receiveStatementListController.close();
  }
}
