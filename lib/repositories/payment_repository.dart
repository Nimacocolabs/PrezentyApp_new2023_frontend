import 'dart:async';
import 'package:dio/dio.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/models/payment_create_upi_link_response.dart';
import 'package:event_app/models/payment_init_transfer_response.dart';
import 'package:event_app/models/payment_status_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/apis.dart';

class PaymentRepository {
  ApiProvider apiClient = ApiProvider();

  PaymentRepository() {
    apiClient = ApiProvider();
  }

  Future<PaymentCreateUpiLinkResponse> getPaymentUpiLink(
      Map<String, dynamic> body) async {
    Response response = await apiClient
        .getJsonInstance()
        .post(Apis.getPaymentUpiLink, data: body);
    return PaymentCreateUpiLinkResponse.fromJson(response.data);
  }

  Future<PaymentStatusResponse> getPaymentStatus(int id) async {
    Response response = await apiClient
        .getJsonInstance()
        .get('${Apis.getPaymentStatus}?id=$id');
    return PaymentStatusResponse.fromJson(response.data);
  }

  Future<PaymentInitTransferResponse> redeemInitTransfer(
      Map<String, dynamic> body) async {
    Response response = await apiClient
        .getJsonInstance()
        .post('${Apis.redeemInitTransfer}', data: body);
    return PaymentInitTransferResponse.fromJson(response.data);
  }

  Future<PaymentStatusResponse> getTransferStatus(int id) async {
    Response response = await apiClient
        .getJsonInstance()
        .get('${Apis.getTransferStatus}?id=$id');
    return PaymentStatusResponse.fromJson(response.data);
  }

  Future<PaymentTaxResponse> getTaxInfo(
      bool isBuyNotRedeem,
      String amount,
      String actualAmount,
      String productId,
      String userId,
      String quantity,
      String denomination) async {
    Map<String, dynamic> body = {
      'amount': amount,
      'actual_amount': actualAmount,
      'product_id': productId,
      'user_id': userId,
      'quantity': quantity,
      'denomination': denomination
    };
    Response response = await apiClient.getJsonInstance().post(
        isBuyNotRedeem ? Apis.getBuyTaxInfo : Apis.getRedeemTaxInfo,
        data: body);
    return PaymentTaxResponse.fromJson(response.data);
  }
}
