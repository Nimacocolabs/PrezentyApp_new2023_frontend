import 'dart:async';
import 'package:event_app/models/payment_create_upi_link_response.dart';
import 'package:event_app/models/payment_init_transfer_response.dart';
import 'package:event_app/models/payment_status_response.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/repositories/payment_repository.dart';
import 'package:event_app/screens/payment/payment_v2_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:get/get.dart';

enum PaymentType { GIFT, FOOD, REDEEM }

class PaymentBloc {
  PaymentRepository? _repository;
  PaymentCreateUpiLinkResponse? paymentCreateUpiLinkResponse;
  PaymentInitTransferResponse? transferResponse;

  PaymentBloc() {
    _repository = PaymentRepository();
  }

  Future<String> getPaymentUpiLink(PaymentData paymentData) async {
    try {    
      Map<String, dynamic> body = {
        "reference_id":
            "${paymentData.eventId}-${paymentData.paymentType!.name}-${DateTime.now().millisecondsSinceEpoch}",
        "payee_account": "${paymentData.account}",
        "amount": "${paymentData.amount}",
        "purpose_message": "${paymentData.purpose}",
        "event_id": "${paymentData.eventId}",
        "voucher_type": "${paymentData.paymentType!.name}",
        "state": "${paymentData.state}"
      };

      if (paymentData.paymentType == PaymentType.GIFT) {
        // body = {
        //   "reference_id": "${paymentData.eventId}-${paymentData.paymentType!.name}-${DateTime.now().millisecondsSinceEpoch}",
        //   "payee_account": "${paymentData.account}
        //   "amount": "${paymentData.amount}",
        //   "purpose_message": "${paymentData.purpose}",
        //   "event_id": "${paymentData.eventId}",
        //   "voucher_type": "${paymentData.paymentType!.name}",
        //   "participant_id": "${paymentData.participantId}"
        // };
        body["participant_id"] = "${paymentData.participantId}";
      } else if (paymentData.paymentType == PaymentType.FOOD) {
        // body = {
        //   "reference_id": "${paymentData.eventId}-${paymentData.paymentType!.name}-${DateTime
        //       .now()
        //       .millisecondsSinceEpoch}",
        //   "payee_account": "${paymentData.account}",
        //   "amount": "${paymentData.amount}",
        //   "purpose_message": "${paymentData.purpose}",
        //   "event_id": "${paymentData.eventId}",
        //   "voucher_type": "${paymentData.paymentType!.name}",
        //   "user_id": "${paymentData.userId}"
        // };
        body["user_id"] = "${paymentData.userId}";
      } else {
        return 'Invalid payment data';
      }
      PaymentCreateUpiLinkResponse response =
          await _repository!.getPaymentUpiLink(body);
      if (response.success ?? false) {
        paymentCreateUpiLinkResponse = response;
        return '';
      } else {
        return response.detail!.message ?? 'Unable to create upi link';
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      return ApiErrorMessage.getNetworkError(e);
    }
  }

  Future<bool> getPaymentStatus() async {
    try {
      PaymentStatusResponse response = await _repository!
          .getPaymentStatus(paymentCreateUpiLinkResponse!.detail!.id!);

      if (response.success ?? false) {
        return true;
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
    return false;
  }

  Future<bool> redeemInitTransfer(
      int eventId, String amount, String purpose) async {
    try {
      AppDialogs.loading();
      PaymentInitTransferResponse response = await _repository!
          .redeemInitTransfer(
              {"id": "$eventId", "amount": "$amount", "message": "$purpose"});
      Get.back();
      if (response.success ?? false) {
        transferResponse = response;
        return true;
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return false;
  }

  Future<bool> getTransferStatus() async {
    try {
      PaymentStatusResponse response =
          await _repository!.getTransferStatus(transferResponse!.id!);

      if (response.success ?? false) {
        return true;
      }
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return false;
  }

  Future<PaymentTaxResponse?> getTaxInfo(
      bool isBuyNotRedeem,
      String amount,
      String actualAmount,
      String productId,
      String userId,
      String quantity,
      String denomination) async {
    try {
      AppDialogs.loading();
      PaymentTaxResponse response = await _repository!.getTaxInfo(
        isBuyNotRedeem,
        amount,
        actualAmount,
        productId,
        userId,
        quantity,
        denomination,
      );
      Get.back();

      if (response.success ?? false) {
        return response;
      } else {
        toastMessage(response.message ?? 'Something went wrong');
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
}
