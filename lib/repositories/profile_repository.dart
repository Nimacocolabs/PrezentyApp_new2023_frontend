 import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/coin_transfer_history_model.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/fetch_physical_card_details_model.dart';
import 'package:event_app/models/get_current_date_and_time_model.dart';
import 'package:event_app/models/get_detailed_product_category_list_model.dart';
import 'package:event_app/models/get_home_slider_image_model.dart';
import 'package:event_app/models/get_product_category_list_model.dart';
import 'package:event_app/models/hi_card/check_hi_card_balance_model.dart';
import 'package:event_app/models/hi_card/gift_hi_card_model.dart';
import 'package:event_app/models/hi_card/hi_card_earning_history_model.dart';
import 'package:event_app/models/hi_card/hi_card_redemption_history_model.dart';
import 'package:event_app/models/hi_card/hi_card_balance_model.dart';
import 'package:event_app/models/homscreen_common_apis_model.dart';
import 'package:event_app/models/profile_update_response.dart';
import 'package:event_app/models/spin_list_response.dart';
import 'package:event_app/models/spin_user_input_model.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/get_physical_card_status_model.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';

import '../models/coin_statement_response.dart';
import '../models/referral_code_model.dart';
import '../models/spin_get_now_response.dart';
import '../models/spin_voucher_list_response.dart';
import '../models/virtual_account_balance_model.dart';
import '../util/user.dart';
int unreadCount= 0;
String TokenPrepaidCard="";
bool prepiad_user = false;
String? prepaidcardcheck="";
class ProfileRepository {
  late ApiProvider apiProvider;
  late ApiProviderPrepaidCards apiProviderPPCards;

  ProfileRepository() {
    apiProvider = new ApiProvider();
    apiProviderPPCards = new ApiProviderPrepaidCards();
  }

  Future<UserSignUpResponse> getProfileInfo() async {
    final response =
        await apiProvider.getJsonInstance().get('${Apis.getProfileInfo}');

    return UserSignUpResponse.fromJson(response.data);
  }

  Future<UpdateProfileResponse> updateProfileInfo(FormData body) async {
    final response = await apiProvider
        .getMultipartInstance()
        .post('${Apis.updateProfileInfo}', data: body);
    return UpdateProfileResponse.fromJson(response.data);
  }

  Future<CommonResponse> changePassword(FormData body) async {
    final response = await apiProvider
        .getJsonInstance()
        .post('${Apis.changePassword}', data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<VirtualAccountBalanceModel> getVirtualBalance(String userId) async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.getVirtualBalance}?userid=$userId');
    return VirtualAccountBalanceModel.fromJson(response.data);
  }

  Future<CoinStatementResponse> getCoinStatement(String userId) async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.coinStatementTable}?userid=$userId');
    return CoinStatementResponse.fromJson(response.data);
  }

  Future deleteAccountOtp(String accountId) async {
    final response = await apiProviderPPCards
        .getJsonInstance()
        .post(Apis.accountDeleteEmailOtp, data: {"account_id": '$accountId'});
    return response;
    // Map map = jsonDecode(response.data);
    //       if(map['statusCode'] == 200){
    //         print("1111111111111111111111");
    //  return DeleteAccountOtpModel.fromJson(response.data);
    //       }
    //       else if(map['statusCode'] == 500){
    //         print("mmmmmmmmmmmmmmmmmmmmm");
    //       return false;
    //       }
  }

  Future<CommonResponse?> confirmAccountDelete(String accountId) async {
    try {
      final response = await apiProviderPPCards
          .getJsonInstance()
          .post(Apis.accountDeleteConfirm, data: {"account_id": '$accountId'});
      Map map = jsonDecode(response.data);
      return CommonResponse.fromJson(map);
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CoinTransferHistoryModel> coinTransferHistory(String accountId) async {
    final response = await apiProviderPPCards
        .getJsonInstance()
        .post(Apis.transferCoinHistory, data: {"account_id": '$accountId'});
    return CoinTransferHistoryModel.fromJson(json.decode(response.data));
  }
  Future<CommonResponse> checkPrepaidUserOrNotToken(String userId) async {
    final response = await apiProviderPPCards
        .getJsonInstance()
        .get("${Apis.checkPrepaidUserOrNotToken}${userId}");
    print("response token->${response.data}");
    TokenPrepaidCard= response.data["token"];
  //  Map map = jsonDecode(response.data);
    print("response token->${TokenPrepaidCard}");
    return CommonResponse.fromJson(response.data);
  }
  Future<CommonResponse> checkPrepaidUserOrNot(String userId) async {
    final response = await apiProviderPPCards
        .getJsonInstancecard()
        .get("${Apis.checkPrepaidUserOrNot}${userId}",);
    prepiad_user = response.data["prepaid_user"];
    prepaidcardcheck = response.data["message"];
    //Map map = jsonDecode(response.data);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> transferCoinsToPrepaidCard(FormData body) async {
    final response = await apiProviderPPCards
        .getJsonInstance()
        .post('${Apis.transferCoinToPrepaidCard}', data: body);
    return CommonResponse.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> updateUserPanNumber(FormData body) async {
    final response = await apiProviderPPCards
        .getJsonInstance()
        .post('${Apis.updatePanNumber}', data: body);
    return CommonResponse.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> updateUserAadharNumber(FormData body) async {
    final response = await apiProviderPPCards
        .getJsonInstance()
        .post('${Apis.updateAadharNumber}', data: body);
    return CommonResponse.fromJson(json.decode(response.data));
  }

  Future<CommonResponse> verifyPanOrAadhar(
      FormData body, VerificationType type) async {
    final response = type == "PAN"
        ? await apiProviderPPCards
            .getJsonInstance()
            .post('${Apis.verifyPanAadhar}', data: body)
        : await apiProviderPPCards
            .getMultipartInstance()
            .post('${Apis.verifyPanAadhar}', data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<FetchPhysicalCardDetailsModel?> fetchPhysicalCardDetails(
      String accountId) async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.fetchPhysicalCardDetails,
          data: FormData.fromMap({'account_id': accountId}));
      // print("99999");
      // print(response.data);
      return FetchPhysicalCardDetailsModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
  }

  Future<ReferralCodeModel?> getReferalCode(String accountId) async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.updateReferalCode,
          data: FormData.fromMap({'account_id': accountId}));

      return ReferralCodeModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<SpinUserInputModel?> insertSpinUserAttempt(
      String emailId, String phoneNumber) async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.insertSpinUserAttempt,
          data: FormData.fromMap(
              {'phone_number': phoneNumber, "email": emailId}));
      // print("99999");
      // print(response.data);
      return SpinUserInputModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CommonResponse?> insertSpinItem(int instTableID, int spinId) async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.insertSpinItem,
          data: FormData.fromMap(
              {'ins_table_id': instTableID, "spin_id": spinId}));

      return CommonResponse.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<SpinGetNowResponse?> getUserSpinItem(int instTableID) async {
    try {
      Response response = await apiProviderPPCards
          .getMultipartInstance()
          .post(Apis.getUserSpinItem,
              data: FormData.fromMap({
                'ins_table_id': instTableID,
                'screen_from':
                    User.apiToken.isEmpty ? 'without_login' : 'with_login'
              }));
      return SpinGetNowResponse.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<SpinItemsListResponse?> getSpinItemsList() async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().get(
            Apis.getSpinWheelProductList,
          );

      return SpinItemsListResponse.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<SpinVoucherListResponse> getSpinVoucherList(String userId) async {
    final response = await apiProviderPPCards.getMultipartInstance().post(
        Apis.getSpinVoucherList,
        data: FormData.fromMap({'account_id': userId}));
    return SpinVoucherListResponse.fromJson(jsonDecode(response.data));
  }

  Future<GetCurrentDateAndTimeModel?> getCurrentDateTime() async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().get(
            Apis.getCurrentDateAndTime,
          );

      return GetCurrentDateAndTimeModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<GetProductCategoryListModel> getProductListCategory() async {
    Response response = await apiProviderPPCards
        .getJsonInstance()
        .get('${Apis.getProductCategoryList}');

    return GetProductCategoryListModel.fromJson(json.decode(response.data));
  }

  Future<GetDetailedProductCategoryListModel?> getDetailedCategoryList(
      int categoryId) async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.getDetailedProductCategoryList,
          data: FormData.fromMap({'category_id': categoryId}));

      return GetDetailedProductCategoryListModel.fromJson(
          jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<HiCardBalanceModel?> getHICardBalance(String accountId) async {
    try {
      final response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.getHICardBalance,
          data: FormData.fromMap({'account_id': accountId}));
      return HiCardBalanceModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CheckHiCardBalanceModel?> checkHiCardBalance(
      String cardNumber, String pin) async {
    try {
      final response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.checkHiCardBalance,
          data:
              FormData.fromMap({'card_number': cardNumber, 'pin_number': pin}));
      return CheckHiCardBalanceModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<HiCardRedemptionHistoryModel?> getHICardRedemptionHistory(
      String cardNumber, String pin,{String? fromDate,String? toDate}) async {
    try {
      final response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.getHICardRedemptionHistory,
          data:
              FormData.fromMap({
                'card_number': cardNumber,
                'pin_number': pin,
                'from_date':fromDate,
                 'to_date':toDate,
                }));

      return HiCardRedemptionHistoryModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<HiCardEarningHistoryModel?> getHICardEarningHistory(
      String cardNumber, String pin,{String? fromDate,String? toDate}) async {
    try {
      final response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.getHICardEarningHistory,
          data:
              FormData.fromMap({
                'card_number': cardNumber,
                 'pin_number': pin,
                 'from_date':fromDate,
                 'to_date':toDate,}));

      return HiCardEarningHistoryModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<GiftHiCardModel?> giftHICard(
    String accountId,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String message,
    String amount,
  ) async {
    try {
      final response =
          await apiProviderPPCards.getMultipartInstance().post(Apis.giftHICard,
              data: FormData.fromMap({
                'account_id': accountId,
                'first_name': firstName,
                'last_name': lastName,
                'email': email,
                'phone_number': phoneNumber,
                'message': message,
                'amount': amount,
              }));
      return GiftHiCardModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<GiftHiCardModel?> hiCardLoadMoney(
    String accountId,
    String hiCardId,
    String amount,
  ) async {
    try {
      final response = await apiProviderPPCards
          .getMultipartInstance()
          .post(Apis.hiCardLoadMoney,
              data: FormData.fromMap({
                'account_id': accountId,
                'hi_card_id': hiCardId,
                'amount': amount,
              }));
      return GiftHiCardModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CommonResponse?> transferTouchpointsToHicard(
    String accountId,
    String touchPoints,
    String amount,
  ) async {
    try {
      final response = await apiProviderPPCards
          .getMultipartInstance()
          .post(Apis.transferTouchpointsToHicard,
              data: FormData.fromMap({
                'account_id': accountId,
                'touch_point': touchPoints,
                'amount': amount,
              }));
      return CommonResponse.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<GiftHiCardModel?> senfGiftToUsers(
    String participantId,
    int eventId,
    String voucherType,
    String amount,
    String accountId,
  ) async {
    try {
      final response = await apiProviderPPCards
          .getMultipartInstance()
          .post(Apis.sendGiftToUser,
              data: FormData.fromMap({
                'participant_id': participantId,
                'event_id': eventId,
                'voucher_type': voucherType,
                'amount': amount,
                "account_id": accountId,
              }));
      return GiftHiCardModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CommonResponse?> checkHiCardValidity(
    String cardNumber,
    String pinNumber,
    String amount,
  ) async {
    try {
      final response = await apiProviderPPCards
          .getMultipartInstance()
          .post(Apis.checkHiCardValidity,
              data: FormData.fromMap({
                'card_number': cardNumber,
                'pin_number': pinNumber,
                'amount': amount,
              }));
      return CommonResponse.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<GetHomeSliderImageModel?> getHomeSliderImages() async {
    try {
      final response = await apiProviderPPCards
          .getMultipartInstance()
          .get('${Apis.homeSliderImages}');

      return GetHomeSliderImageModel.fromJson(json.decode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<GetPhysicalCardStatusModel?> getPhysicalCardStatus(
      String accountId) async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().post(
          Apis.getPhysicalCardStatus,
          data: FormData.fromMap({'account_id': accountId}));
     
      return GetPhysicalCardStatusModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
  }

   Future<HomscreenCommonApisModel?> homeScreenCommonApi(
      String accountId) async {
    try {
      Response response = await apiProviderPPCards.getMultipartInstance().post(Apis.homeScreenCommonApi, data: FormData.fromMap({'account_id': accountId}));
      print("Unreadcount-<${unreadCount}");
      return HomscreenCommonApisModel.fromJson(jsonDecode(response.data));
    } catch (e, s) {
      Completer().completeError(e, s);
    }
  }
  
}
