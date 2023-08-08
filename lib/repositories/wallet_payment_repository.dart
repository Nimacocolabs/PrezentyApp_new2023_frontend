import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:event_app/models/qr_code_model.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/models/payment_create_upi_link_response.dart';
import 'package:event_app/models/payment_init_transfer_response.dart';
import 'package:event_app/models/payment_status_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';

class WalletPaymentRepository {
  ApiProviderPrepaidCards apiProvider = ApiProviderPrepaidCards();

  WalletPaymentRepository() {
    apiProvider = ApiProviderPrepaidCards();
  }

   Future<QrCodeModel> getPaymentUpiLink(String accountId ,String amount) async {
    final response = await apiProvider
        .getJsonInstance()
        .post( Apis.qrcodeWalletPay,data: {'account_id':'$accountId','amount':'$amount'});
    return QrCodeModel.fromJson(json.decode(response.data));
  }
  


  Future<PaymentStatusResponse> getPaymentStatus(String accountId ,int insTableId,String walletBalance) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post( Apis.paymentStatus,data: {'account_id':'$accountId','ins_table_id':'$insTableId',"wallet_balance":walletBalance});
    return PaymentStatusResponse.fromJson(json.decode(response.data));
  }


}
