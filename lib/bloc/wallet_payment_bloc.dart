import 'dart:async';
import 'package:event_app/models/qr_code_model.dart';
import 'package:event_app/models/payment_create_upi_link_response.dart';
import 'package:event_app/models/payment_init_transfer_response.dart';
import 'package:event_app/models/payment_status_response.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/repositories/payment_repository.dart';
import 'package:event_app/repositories/wallet_payment_repository.dart';
import 'package:event_app/screens/payment/payment_v2_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:get/get.dart';


class WalletPaymentBloc {

 WalletPaymentUpiResponse? walletPaymentUpiResponse;
  WalletPaymentRepository? _repository;
  WalletPaymentBloc() {
    _repository = WalletPaymentRepository();

  }

  Future<String> getPaymentUpiLink(String accountid,String amount ) async {
    try {
    
      QrCodeModel response = await _repository!.getPaymentUpiLink(accountid,amount);
      if(response.success??false){
        walletPaymentUpiResponse = response.data;
        return '';
      }else{
        return response.message??'Unable to create upi link';
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      return ApiErrorMessage.getNetworkError(e);
    }
  }

  Future<bool> getPaymentStatus(String accountid,String walletBalance) async {
    try {
      PaymentStatusResponse response = await _repository!.getPaymentStatus(accountid,walletPaymentUpiResponse?.insTableId ?? 0,walletBalance);

      if(response.success??false){
        return true;
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
    return false;
  }

}
