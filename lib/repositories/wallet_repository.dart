import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/models/qr_code_model.dart';
import 'package:event_app/models/touchpoint_wallet_balance_response.dart';
import 'package:event_app/models/check_scratchcard_valid_or_not_model.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/validate_card.dart';
import 'package:event_app/models/wallet&prepaid_cards/existing_payee_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/fetch_user_details_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/get_load_money_content.dart';
import 'package:event_app/models/wallet&prepaid_cards/load_money_transaction_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoints_earning_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoints_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoint_redemption_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/available_card_list_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/card_offers_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/check_physical_card_exists_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/coupon_listing_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/fetch_cvv_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/forget_mpin_send_otp_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_verify_otp.dart';
import 'package:event_app/models/wallet&prepaid_cards/auth_mpin_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/request_physical_card_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/set_card_pin_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/state_data_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/terms_and_conditions_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/upgrade_coupon_tax_info_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/user_permanent_address_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_creation_and_payment_status.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_details_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_statement_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';

import '../models/block_card_response.dart';
import '../models/offer_response.dart';

import '../models/wallet&prepaid_cards/apply_card_tax_info_response.dart';
import '../models/wallet&prepaid_cards/get_merchants_list_model.dart';



class WalletRepository {
  late ApiProviderPrepaidCards apiProvider;

  var _dio = Dio();

  WalletRepository() {
    apiProvider = new ApiProviderPrepaidCards();
  }

  Future<GetAllAvailableCardListResponse> getAllAvailableCardList(
      {String? CardId = null}) async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.getAllAvailableCardList}');
    return GetAllAvailableCardListResponse.fromJson(response.data);
  }

  Future<GetCardOffersResponse> GetCardOffers(int? cardId) async {
    final response = await apiProvider
        .getJsonInstance()
        .post('${Apis.getCardOffers}', data: {"card_id": cardId});
    return GetCardOffersResponse.fromJson(response.data);
  }

  //?card_id=1

  Future<StateCodeResponse> getStateList() async {
    final response = await apiProvider.getJsonInstance().get(
          '${Apis.getStateCode}',
        );
    return StateCodeResponse.fromJson(response.data);
  }

//______________________________________________________________________________

  Future<CommonResponse> setWalletPin(String accountId, String mPin) async {
    Response response =
        await apiProvider.getJsonInstance().post(Apis.setWalletPin,
            data: FormData.fromMap({
              'account_id': accountId,
              'new_mpin': mPin,
            }));

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  Future<AuthMPinResponse> authWalletPin(String accountId, String mPin) async {
    Response response =
        await apiProvider.getJsonInstance().post(Apis.authWallet,
            data: FormData.fromMap({
              'account_id': accountId,
              'user_mpin': mPin,
            }));
    print(response.data);
    return AuthMPinResponse.fromJson(jsonDecode(response.data));
  }

  Future<ForgetMPinSendOtpResponse> forgetWalletPinSendOtp(
      String accountId) async {
    Response response = await apiProvider.getJsonInstance().post(
        Apis.forgetWalletPinSendOtp,
        data: FormData.fromMap({'account_id': accountId}));
    return ForgetMPinSendOtpResponse.fromJson((response.data));
  }

  Future<CommonResponse> resetWalletPinUpdateWalletPin(
      String accountId, String mPin,
      {int? otpReferenceId = null,
      String? oldMPin = null,
      int? status,
      String? otp = null}) async {
    Response response =
        await apiProvider.getMultipartInstance().post(Apis.resetWalletPin,
            data: FormData.fromMap({
              'account_id': accountId,
              'status': status,
              'reference_id': otpReferenceId,
              'old_mpin': oldMPin,
              'new_mpin': mPin,
              'otp': otp,
            }));

    return CommonResponse.fromJson(response.data);
  }

//______________________________________________________________________________

  Future<WalletCreationAndPaymentStatus> walletCreationAndPaymentStatus(
      String userId, String cardId) async {
    Response response = await apiProvider.getJsonInstance().post(
        Apis.walletCreationAndPaymentStatus,
        data: {"account_id": userId, "card_id": cardId});
    return WalletCreationAndPaymentStatus.fromJson(jsonDecode(response.data));
  }

  Future<RegisterWalletResponse> registerWallet(String body) async {
    Response response = await apiProvider
        .getJsonInstancecard()
        .post(Apis.registerWallet, data: body);
    return RegisterWalletResponse.fromJson(jsonDecode(response.data));
  }

  Future<RegisterWalletVerifyOtp> verifyWalletRegistrationOtp(Map body) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post(Apis.verifyWalletRegistrationOtp, data: body);
    return RegisterWalletVerifyOtp.fromJson(jsonDecode(response.data));
  }

  Future<RegisterWalletResponse> registerWalletResendOtp(
      String? userId, String? kycReferenceId) async {
    final response = await apiProvider.getJsonInstance().post(
        Apis.registerWallet,
        data: {"account_id": userId, "min_kyc_reference_id": kycReferenceId});
    return RegisterWalletResponse.fromJson(jsonDecode(response.data));
  }

  Future<WalletDetailsResponse> getWalletDetails(String? userId) async {
    final response = await apiProvider
        .getJsonInstancecard()
        .get(Apis.getWalletDetails,);
    return WalletDetailsResponse.fromJson(response.data);
  }

  Future<SetCardPinResponse> setCardPin() async {
    final response = await apiProvider.getJsonInstancecard().get(Apis.setCardPin);
    return SetCardPinResponse.fromJson(response.data);
  }

  Future<BlockCardResponse> blockCard(String? body) async {
    final response = await apiProvider
        .getJsonInstancecard()
        .post(Apis.blockCardNow, data: body);
    return BlockCardResponse.fromJson(response.data);
  }

  Future<BlockCardResponse> replaceCard(String? body) async {
    final response = await apiProvider
        .getJsonInstancecard()
        .post(Apis.replaceCardNow, data: body);
    return BlockCardResponse.fromJson(response.data);
  }

  Future<WalletStatementResponse> getStatementList(
      {String? entityId,
      String? fromDate,
      String? toDate,
      int? pageNumber}) async {
    final response = await apiProvider
        .getJsonInstancecard()
        .post(Apis.getWalletStatementList, data: {
      "entityId": entityId,
      "pageNumber": pageNumber,
      "pageSize":5,
      "fromDate": fromDate,
      "toDate": toDate,
    });
    return WalletStatementResponse.fromJson(response.data);
  }

  Future<FetchCardCvvResponse> getCardCVV(
      String? userId, String? kitNumber) async {
    final response = await apiProvider.getJsonInstance().post(Apis.getCVV,
        data: {"account_id": userId, "kit_number": kitNumber});
    return FetchCardCvvResponse.fromJson(jsonDecode(response.data));
  }

  Future<CheckPhysicalCardExistsResponse> checkPhysicalCardExists(
      String? userId, String? cardNumber) async {
    print("Data--->${userId} && ${cardNumber}");
    final response = await apiProvider.getJsonInstance().post(
        Apis.checkPhysicalCardExists,
        data: {"account_id": userId, "card_number": cardNumber});
    print("Response--->${response}");
    return CheckPhysicalCardExistsResponse.fromJson(jsonDecode(response.data));
  }

  Future<RequestPhysicalCardResponse> requestPhysicalCard(
      String? userId, String? kitNumber, String? cardNumber, String? status,
      {String? address,
      String? pinCode,
      String? city,
      String? stateCode}) async {
    final response = await apiProvider
        .getJsonInstance()
        .post(Apis.requestPhysicalCard, data: {
      "account_id": userId,
      "kit_number": kitNumber,
      "card_number": cardNumber,
      "status": status,
      "address": address,
      "pin_code": pinCode,
      "city": city,
      "state_code": stateCode,
    });

    return RequestPhysicalCardResponse.fromJson(jsonDecode(response.data));
  }

  Future<OffersResponse> getOffers() async {
    final response = await apiProvider.getJsonInstance().get('${Apis.offers}');
    return OffersResponse.fromJson(response.data);
  }

  Future<GetAllAvailableCardListResponse> getCardUpgradePlans(
      String accountId, int cardId) async {
    final response = await apiProvider.getJsonInstance().post(
        '${Apis.getCardUpgradePlans}',
        data: {'account_id': '$accountId', 'card_id': '$cardId'});
    return GetAllAvailableCardListResponse.fromJson(json.decode(response.data));
  }

  Future<GetAllAvailableCardListResponse> getEnableUpgradeButton(
      String accountId, int cardId) async {
    final response = await apiProvider.getJsonInstance().post(
        Apis.getEnableUpgradeButton,
        data: {'account_id': '$accountId', 'card_id': '$cardId'});
    return GetAllAvailableCardListResponse.fromJson(json.decode(response.data));
  }

  Future<ApplyCardTaxInfoResponse> getApplyCardTaxInfo(
      Map<String, dynamic> body) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post(Apis.getApplyCardTaxInfo, data: body);
    print("api Apply card=-.${Apis.getApplyCardTaxInfo}");
    return ApplyCardTaxInfoResponse.fromJson(jsonDecode(response.data));
  }

  Future<bool> checkEnableRequestPhysicalCard(Map<String, String> body) async {
    final response = await apiProvider
        .getJsonInstancecard()
        .post(Apis.checkEnableRequestPhysicalCard, data: body);

    Map map = (response.data);
    return (map['statusCode'] == 200);
  }

  Future<bool> getMPinStatus(String accountId) async {
    final response = await apiProvider
        .getJsonInstance()
        .post(Apis.getMPinStatus, data: {'account_id': accountId});

    Map map = jsonDecode(response.data);
    return (map['statusCode'] == 200);
  }

  Future<CouponListingModel> getCouponListing(String cardId) async {
    final response = await apiProvider
        .getJsonInstance()
        .post('${Apis.couponListing}', data: {"card_id": cardId});
    return CouponListingModel.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> validate(String cardId, String code) async {
    final response = await apiProvider.getJsonInstance().post(
        '${Apis.couponValidate}',
        data: {"card_id": cardId, "coupon_code": code});
    return CommonResponse.fromJson(json.decode(response.data));
  }

  Future<UpgradeCouponTaxInfo> getupgardeCouponTaxInfo(
      String cardId, String accountId) async {
    Response response = await apiProvider.getJsonInstance().post(
        Apis.upgradeCouponTaxInfo,
        data: {"card_id": cardId, "account_id": accountId});
    return UpgradeCouponTaxInfo.fromJson(jsonDecode(response.data));
  }

  Future<CommonResponse> transactionStatusCheck(
      Map<String, dynamic> body, String type) async {
    String cardType;
    if (type == "apply_card") {
      cardType = Apis.checkTransactionStatusApplyCard;
    } else {
      cardType = Apis.checkTransactionStatusUpgradeCard;
    }
    Response response = await apiProvider
        .getMultipartInstance()
        .post(cardType, data: FormData.fromMap(body));
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> walletNavigation(String accountId) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post(Apis.navigateToWallet, data: {'account_id': accountId});

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  Future<TouchPointsModel> getTouchPoints(String accountId) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post(Apis.touchPoints, data: {'account_id': accountId});
    return TouchPointsModel.fromJson(jsonDecode(response.data));
  }

  Future<TouchPointsEarningHistoryModel> getTPEarningHistory(
      String accountId) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post(Apis.tpEarningHistory, data: {'account_id': accountId});
    return TouchPointsEarningHistoryModel.fromJson(jsonDecode(response.data));
  }

  Future<TouchPointsRedemptionHistoryModel> getTPRedemptionHistory(
      String accountId) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post(Apis.tpRedemptionHistory, data: {'account_id': accountId});
    return TouchPointsRedemptionHistoryModel.fromJson(
        jsonDecode(response.data));
  }

  Future<TouchPointWalletBalanceData?> getTouchPointWalletBalance(
      String accountId) async {
    try {
      Response response = await apiProvider.getMultipartInstance().post(
          Apis.getTouchPointWalletBalance,
          data: FormData.fromMap({'account_id': accountId}));
      return TouchPointWalletBalanceResponse.fromJson(
              response.data)
          .data;
    } catch (e, s) {
      // print("123456");
      // print(e);
      Completer().completeError(e, s);
    }
  }

  Future<UserPermanentAddressData?> getUserPermanentAddress(
      String accountId) async {
    try {
      Response response = await apiProvider.getMultipartInstance().post(
          Apis.userPermenantAddress,
          data: FormData.fromMap({'account_id': accountId}));
      print("99999");
      print(response.data);
      return UserPermanentAddressModel.fromJson(jsonDecode(response.data)).data;
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<TermsAndConditionsData?> termsAndConditions() async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.getTermsAndConditions}');
    return TermsAndConditionsModel.fromJson(json.decode(response.data)).data;
  }

  Future<FetchUserDetailsModel> fetchUserDetails(String accountId) async {
    Response response = await apiProvider
        .getJsonInstance()
        .post(Apis.userDetailsFetch, data: {'account_id': accountId});
    return FetchUserDetailsModel.fromJson(jsonDecode(response.data));
  }

  Future<ApplyCardTaxInfoResponse> getPhysicalCardRequestAmount(
      String accountId) async {
    Response response = await apiProvider.getJsonInstancecard().get(
        Apis.getPhysicalCardRequestAmount,);

    return ApplyCardTaxInfoResponse.fromJson(response.data);
  }

  Future<ValidateCardData?> validatePrepaidCardNumber(
      String accountId, String cardNumber) async {
    Response response = await apiProvider.getJsonInstance().post(
        Apis.validatePrepaidCardNumber,
        data: {'account_id': accountId, 'card_number': cardNumber});

    return ValidateCardResponse.fromJson(jsonDecode(response.data)).data;
  }

  Future<CheckScratchcardValidOrNotModel> getScratchCodeValidOrNot(
      String accountId, String cardId, String code,
      {String? referralCode}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post(Apis.getScratchCardValidOrNot,
            data: FormData.fromMap({
              'account_id': accountId,
              "card_id": cardId,
              "coupon_code": code,
              'referral_code': referralCode
            }));

    return CheckScratchcardValidOrNotModel.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> getCustomerCardType(String accountId) async {
    final response = await apiProvider
        .getJsonInstance()
        .post('${Apis.checkCustomerCardType}', data: {
      'account_id': accountId,
    });
    return CommonResponse.fromJson(json.decode(response.data));
  }

  Future<GetMerchantsListModel> getMerchantsList() async {
    Response response =
        await apiProvider.getJsonInstance().get('${Apis.getMerchantsList}');

    return GetMerchantsListModel.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> validateWalletNumber({String? accountId,String? walletNumber,String? type,String? eventID,String? amount}) async {
    Response response =
        await apiProvider.getMultipartInstance().post(Apis.validateWalletNumber,
            data: FormData.fromMap({
              'account_id':accountId,
              'wallet_number': walletNumber,
              'type':type,
              'event_id':eventID,
              'amount':amount,
            }));

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  // Future<QrCodeModel> walletUPIPayment(
  //     {String? accountId,
  //     String? type,
  //     String? amount,
  //     String? walletNumber}) async {
  //   Response response =
  //       await apiProvider.getMultipartInstance().post(Apis.walletUPIPayment,
  //           data: FormData.fromMap({
  //             'account_id': accountId,
  //             'type': type,
  //             'amount': amount,
  //             'wallet_number': walletNumber,
  //           }));

  //   return QrCodeModel.fromJson(jsonDecode(response.data));
  // }

  Future<QrCodeModel> testWallet(
      {String? accountId,
      String? type,
      String? amount,
      String? walletNumber,
      String? eventId}) async {
    Response response =
        await apiProvider.getMultipartInstance().post(Apis.walletUPIPayment,
            data: FormData.fromMap({
              'account_id': accountId,
              'type': type,
              'amount': amount,
              'wallet_number': walletNumber,
              'event_id':eventId,
            }));


    return QrCodeModel.fromJson(jsonDecode(response.data));
  }

  Future<CommonResponse> checkWalletPayeeExistOrNot(
      {String? accountId, String? walletNumber}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post(Apis.checkWalletPayeeExistOrNot,
            data: FormData.fromMap({
              'account_id': accountId,
              'wallet_number': walletNumber,
            }));

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  Future<CommonResponse> addWalletBeneficiary(
      {String? accountId,
      String? walletNumber,
      String? beneficiaryName}) async {
    Response response =
        await apiProvider.getMultipartInstance().post(Apis.addWalletBeneficiary,
            data: FormData.fromMap({
              'account_id': accountId,
              'wallet_number': walletNumber,
              'beneficiary_name': beneficiaryName,
            }));

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  Future<ExistingPayeeModel> getExistingPayees({String? accountId}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post('${Apis.getExistingPayee}',
            data: FormData.fromMap({
              'account_id': accountId,
            }));

    return ExistingPayeeModel.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> addBeneficiaryToFavourite({String? id}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post(Apis.addBeneficiaryToFavourite,
            data: FormData.fromMap({
              'id': id,
            }));

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  Future<CommonResponse> removeBeneficiaryToFavourite({String? id}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post(Apis.removeBeneficiaryToFavourite,
            data: FormData.fromMap({
              'id': id,
            }));

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  Future<CommonResponse> deleteBeneficiary({String? id}) async {
    Response response =
        await apiProvider.getMultipartInstance().post(Apis.deleteBeneficiary,
            data: FormData.fromMap({
              'id': id,
            }));

    return CommonResponse.fromJson(jsonDecode(response.data));
  }

  Future<ExistingPayeeModel> getFavouritePayeesList({String? accountId}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post('${Apis.favouritePayeesList}',
            data: FormData.fromMap({
              'account_id': accountId,
            }));

    return ExistingPayeeModel.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> getVATransactionSuccessOrNot(
      {String? accountId, String? insTableId}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post('${Apis.getVATransactionSuccessOrNot}',
            data: FormData.fromMap({
              'account_id': accountId,
              'ins_table_id': insTableId,
            }));

    return CommonResponse.fromJson(json.decode(response.data));
  }

  Future<LoadMoneyTransactionHistoryModel> loadMoneyTransactionHistory(
      {String? accountId,String? type}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post('${Apis.loadMoneyTransactionHistory}',
            data: FormData.fromMap({
              'account_id': accountId,
              'type':type,
            }));

    return LoadMoneyTransactionHistoryModel.fromJson(
        json.decode(response.data));
  }

  Future<GetLoadMoneyContent> getLoadMoneyContent() async {
    final response =
        await apiProvider.getJsonInstance().get('${Apis.loadMoneyContent}');
    return GetLoadMoneyContent.fromJson(json.decode(response.data));
  }
    Future<CommonResponse> checkVAStatementStatus(
      {String? accountId, String? insTableId}) async {
    Response response = await apiProvider
        .getMultipartInstance()
        .post('${Apis.checkVAStatementStatus}',
            data: FormData.fromMap({
              'account_id': accountId,
              'ins_table_id': insTableId,
            }));

    return CommonResponse.fromJson(json.decode(response.data));
  }
}
