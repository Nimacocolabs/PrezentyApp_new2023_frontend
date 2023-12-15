import 'dart:async';
import 'package:dio/dio.dart';
import 'package:event_app/models/get_home_slider_image_model.dart';
import 'package:event_app/models/hi_card/check_hi_card_balance_model.dart';
import 'package:event_app/models/hi_card/gift_hi_card_model.dart';
import 'package:event_app/models/hi_card/hi_card_balance_model.dart';
import 'package:event_app/models/hi_card/hi_card_earning_history_model.dart';
import 'package:event_app/models/homscreen_common_apis_model.dart';
import 'package:event_app/models/user_details.dart';
import 'package:event_app/models/coin_transfer_history_model.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/fetch_physical_card_details_model.dart';
import 'package:event_app/models/get_current_date_and_time_model.dart';
import 'package:event_app/models/profile_update_response.dart';
import 'package:event_app/models/spin_list_response.dart';
import 'package:event_app/models/spin_user_input_model.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/get_physical_card_status_model.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/profile_repository.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_buy_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:get/get.dart' as getx;

import '../models/coin_statement_response.dart';
import '../models/get_detailed_product_category_list_model.dart';
import '../models/get_product_category_list_model.dart';
import '../models/hi_card/hi_card_redemption_history_model.dart';
import '../models/referral_code_model.dart';
import '../models/spin_get_now_response.dart';
import '../models/spin_voucher_list_response.dart';
import '../models/virtual_account_balance_model.dart';
import '../models/woohoo/woohoo_product_detail_response.dart';
import '../screens/woohoo/woohoo_voucher_list_screen.dart';
import 'woohoo/woohoo_product_bloc.dart';

class ProfileBloc {
  late ProfileRepository _repository;

  /////////////////////
  late StreamController<ApiResponse<UserSignUpResponse>> _profileController;

  StreamSink<ApiResponse<UserSignUpResponse>>? get profileSink =>
      _profileController.sink;

  Stream<ApiResponse<UserSignUpResponse>> get profileStream =>
      _profileController.stream;

///////////////////////////////
  ///
  late StreamController<ApiResponse<CoinStatementResponse>>
      _coinStatementController;

  StreamSink<ApiResponse<CoinStatementResponse>> get coinStatementSink =>
      _coinStatementController.sink;

  Stream<ApiResponse<CoinStatementResponse>> get coinStatementStream =>
      _coinStatementController.stream;

  /////////////////////////

  late StreamController<ApiResponse<CoinTransferHistoryModel>>
      _coinTransferHistoryController;

  StreamSink<ApiResponse<CoinTransferHistoryModel>>
      get coinTransferHistorySink => _coinTransferHistoryController.sink;

  Stream<ApiResponse<CoinTransferHistoryModel>> get coinTransferHistoryStream =>
      _coinTransferHistoryController.stream;

///////////////////////////////////
  late StreamController<ApiResponse<ReferralCodeModel>> _referalCodeController;

  StreamSink<ApiResponse<ReferralCodeModel>> get referalCodeSink =>
      _referalCodeController.sink;

  Stream<ApiResponse<ReferralCodeModel>> get referalCodeStream =>
      _referalCodeController.stream;

  ///////////////////////////////
  //
  // late StreamController<ApiResponse<SpinUserInputModel>>
  //     _spinGiftsWonController;
  //
  // StreamSink<ApiResponse<SpinUserInputModel>> get spinGiftsWonSink =>
  //     _spinGiftsWonController.sink;
  //
  // Stream<ApiResponse<SpinUserInputModel>> get spinGiftsWonStream =>
  //     _spinGiftsWonController.stream;

  late StreamController<ApiResponse<SpinVoucherListResponse>>
      _spinVoucherController;
  StreamSink<ApiResponse<SpinVoucherListResponse>> get spinVoucherSink =>
      _spinVoucherController.sink;
  Stream<ApiResponse<SpinVoucherListResponse>> get spinVoucherStream =>
      _spinVoucherController.stream;

///////////////////////////////

  late StreamController<ApiResponse<GetProductCategoryListModel>>
      _productsCategoryController;
  StreamSink<ApiResponse<GetProductCategoryListModel>>
      get productsCategorySink => _productsCategoryController.sink;
  Stream<ApiResponse<GetProductCategoryListModel>> get productsCategoryStream =>
      _productsCategoryController.stream;

///////////////////////////////

  late StreamController<ApiResponse<GetDetailedProductCategoryListModel>>
      _detailedProductsCategoryController;
  StreamSink<ApiResponse<GetDetailedProductCategoryListModel>>
      get detailedProductsCategorySink =>
          _detailedProductsCategoryController.sink;
  Stream<ApiResponse<GetDetailedProductCategoryListModel>>
      get detailedProductsCategoryStream =>
          _detailedProductsCategoryController.stream;

///////////////////////////////
  late StreamController<ApiResponse<HiCardRedemptionHistoryModel>>
      _hiCardRedemptionHistoryController;
  StreamSink<ApiResponse<HiCardRedemptionHistoryModel>>
      get hiCardRedemptionHistorySink =>
          _hiCardRedemptionHistoryController.sink;
  Stream<ApiResponse<HiCardRedemptionHistoryModel>>
      get hiCardRedemptionHistoryStream =>
          _hiCardRedemptionHistoryController.stream;

///////////////////////////////

  late StreamController<ApiResponse<HiCardEarningHistoryModel>>
      _hiCardEarningHistoryController;
  StreamSink<ApiResponse<HiCardEarningHistoryModel>>
      get hiCardEarningHistorySink => _hiCardEarningHistoryController.sink;
  Stream<ApiResponse<HiCardEarningHistoryModel>>
      get hiCardEarningHistoryStream => _hiCardEarningHistoryController.stream;

///////////////////////////////

  late StreamController<ApiResponse<CheckHiCardBalanceModel>>
      _hiCardDetailsController;
  StreamSink<ApiResponse<CheckHiCardBalanceModel>> get hiCardDetailsSink =>
      _hiCardDetailsController.sink;
  Stream<ApiResponse<CheckHiCardBalanceModel>> get hiCardDetailsStream =>
      _hiCardDetailsController.stream;

///////////////////////////////

  late StreamController<ApiResponse<GetHomeSliderImageModel>>
      _homeSliderImagesController;
  StreamSink<ApiResponse<GetHomeSliderImageModel>> get homeSliderImagesSink =>
      _homeSliderImagesController.sink;
  Stream<ApiResponse<GetHomeSliderImageModel>> get homeSliderImagesStream =>
      _homeSliderImagesController.stream;

///////////////////////////////

  ProfileBloc() {
    _profileController = StreamController<ApiResponse<UserSignUpResponse>>();
    ////////////////////////////
    _coinStatementController =
        StreamController<ApiResponse<CoinStatementResponse>>();
    /////////////////////////////////
    _coinTransferHistoryController =
        StreamController<ApiResponse<CoinTransferHistoryModel>>();
    /////////////////////////////////////
    _referalCodeController = StreamController<ApiResponse<ReferralCodeModel>>();
    //////////////////////////
    _spinVoucherController =
        StreamController<ApiResponse<SpinVoucherListResponse>>();
    //////////////////////////////

    _productsCategoryController =
        StreamController<ApiResponse<GetProductCategoryListModel>>();
    //////////////////////////////

    _detailedProductsCategoryController =
        StreamController<ApiResponse<GetDetailedProductCategoryListModel>>();
    //////////////////////////////
    _hiCardRedemptionHistoryController =
        StreamController<ApiResponse<HiCardRedemptionHistoryModel>>();
    //////////////////////////////
    _hiCardEarningHistoryController =
        StreamController<ApiResponse<HiCardEarningHistoryModel>>();
    //////////////////////////////
    _hiCardDetailsController =
        StreamController<ApiResponse<CheckHiCardBalanceModel>>();
    //////////////////////////////

    _homeSliderImagesController =
        StreamController<ApiResponse<GetHomeSliderImageModel>>();
    //////////////////////////////
    _repository = ProfileRepository();
  }

  Future<UpdateProfileResponse> updateProfileInfo(FormData body) async {
    try {
      UpdateProfileResponse response =
          await _repository.updateProfileInfo(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  getProfileInfo() async {
    profileSink!.add(ApiResponse.loading('Fetching profile'));
    try {
      AppDialogs.loading();
      UserSignUpResponse profileResponse = await _repository.getProfileInfo();
      if (profileResponse.success == true) {
        if (profileResponse.userDetails != null) {
          try {
            if (SharedPrefs.getBool(SharedPrefs.spAutoLogin)) {
              await SharedPrefs.logIn(true, profileResponse);
            } else {
              var img = profileResponse.baseUrl! +
                  profileResponse.userDetails!.imageUrl!;
              User.set(
                User.apiToken,
                profileResponse.userDetails!.id.toString(),
                profileResponse.userDetails!.name ?? '',
                profileResponse.userDetails!.email ?? '',
                profileResponse.userDetails!.role ?? '',
                img,
                profileResponse.userDetails!.phoneNumber ?? '',
                profileResponse.userDetails!.address ?? '',
                profileResponse.userDetails!.hiCardId.toString(),
                profileResponse.userDetails!.hiCardNo ?? '',
                profileResponse.userDetails!.hiCardPin.toString(),
                profileResponse.userDetails!.hiCardBalance.toString(),
                // profileResponse.userDetails!.hasMPin ?? false,
              );
            }
          } catch (e) {
            print("error1 ${e.toString()}");
          }
        }
        profileSink!.add(ApiResponse.completed(profileResponse));
      } else {
        profileSink!.add(ApiResponse.error(
            profileResponse.message ?? "Something went wrong"));
      }
    } catch (error) {
      profileSink!
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<bool?> isUserHasPhoneNumber() async {
    try {
      UserSignUpResponse profileResponse = await _repository.getProfileInfo();

      if (profileResponse.success ?? false) {
        return (profileResponse.userDetails?.phoneNumber ?? '').isNotEmpty;
      }
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<UserDetails?> checkUserInfo() async {
    try {
      UserSignUpResponse profileResponse = await _repository.getProfileInfo();

      if (profileResponse.success ?? false) {
        return profileResponse.userDetails;
      }
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CommonResponse> changePassword(FormData body) async {
    try {
      CommonResponse response = await _repository.changePassword(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<String> getVirtualBalance(String userID) async {
    try {
      VirtualAccountBalanceModel response =
          await _repository.getVirtualBalance(userID);
      return response.virtualAccountBalance!;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future getCoinStatement(String userID) async {
    try {
      coinStatementSink.add(ApiResponse.loading("Fetching"));
      CoinStatementResponse response =
          await _repository.getCoinStatement(userID);
      // if(response.success??false){
      coinStatementSink.add(ApiResponse.completed(response));
      // }else{
      //   coinStatementSink.add(ApiResponse.error(response.message??'Something went wrong'));
      // }
    } catch (e, s) {
      Completer().completeError(e, s);
      coinStatementSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future deleteAccountOtp(String accountId) async {
    try {
      final response = await _repository.deleteAccountOtp(accountId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<bool?> confirmAccountDelete(String accountId) async {
    try {
      CommonResponse? response =
          await _repository.confirmAccountDelete(accountId);
      return response?.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
      //  throw e;
    }
  }

  Future coinTransferHistory(String accountId) async {
    try {
      coinTransferHistorySink.add(ApiResponse.loading("Fetching"));
      CoinTransferHistoryModel response =
          await _repository.coinTransferHistory(accountId);
      if (response.success ?? false) {
        coinTransferHistorySink.add(ApiResponse.completed(response));
      } else {
        coinTransferHistorySink
            .add(ApiResponse.error('No transcation history to show'));
        ;
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      coinTransferHistorySink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<bool> confirmWalletUser(String accountId) async {
    try {
      CommonResponse? response =
          await _repository.checkPrepaidUserOrNot(accountId);
      return response.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
      return false;
    }
  }
  Future<bool> tokenforPrepaidcard(String accountId) async {
    try {
      CommonResponse? response =
      await _repository.checkPrepaidUserOrNotToken(accountId);
      return response.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
      return false;
    }
  }
  Future<CommonResponse> transferCoinsToPrepaidCard(FormData body) async {
    try {
      CommonResponse response =
          await _repository.transferCoinsToPrepaidCard(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<CommonResponse> updateUserPanNumber(FormData body) async {
    try {
      CommonResponse response = await _repository.updateUserPanNumber(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  updateUserAadharNumber(FormData body) async {
    try {
      CommonResponse response = await _repository.updateUserAadharNumber(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  verifyPanOrAadhar(FormData body, VerificationType type) async {
    try {
      CommonResponse response = await _repository.verifyPanOrAadhar(body, type);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<FetchPhysicalCardDetailsModel?> fetchPhysicalCardDetails(
      String accountId) async {
    try {
      AppDialogs.loading();
      final response = await _repository.fetchPhysicalCardDetails(accountId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<ReferralCodeModel?> getReferralCode(String accountId) async {
    try {
      AppDialogs.loading();
      referalCodeSink.add(ApiResponse.loading("Fetching"));
      ReferralCodeModel? response = await _repository.getReferalCode(accountId);

      if (response?.success ?? false) {
        referalCodeSink.add(ApiResponse.completed(response));
      } else {
        referalCodeSink.add(ApiResponse.error('Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      referalCodeSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<SpinUserInputModel?> insertSpinUserAttempt(
      String emailId, String contactNumber) async {
    try {
      AppDialogs.loading();
      final response =
          await _repository.insertSpinUserAttempt(emailId, contactNumber);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<bool> insertSpinItem(int instTableID, int spinId) async {
    try {
      AppDialogs.loading();
      CommonResponse? response =
          await _repository.insertSpinItem(instTableID, spinId);

      return response?.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return false;
  }

  Future<bool> getUserSpinItem(int instTableID, String type) async {
    try {
      AppDialogs.loading();
      SpinGetNowResponse? response =
          await _repository.getUserSpinItem(instTableID);
      print(response.toString());
      if (type == 'voucher' && User.apiToken.isNotEmpty) {
        WoohooProductDetailResponse? productDetail = await WoohooProductBloc()
            .getProductDetails(response?.data?.productId ?? 0);

        getx.Get.off(() => WoohooVoucherBuyScreen(
            woohooProductDetail: productDetail!.data!,
            redeemData: RedeemData.spinRedeemVoucher(
                instTableID,
                response?.data?.productId ?? 0,
                int.tryParse(response?.data?.denomiationAmount ?? '0') ?? 0,
                int.tryParse(response?.data?.discountPrice ?? '0') ?? 0,
                productDetail.image ?? '',
                productDetail.data!),
            productId: response?.data?.productId ?? 0,
            image: productDetail.image,
            offers: double.tryParse(productDetail.offers ?? '0') ?? 0,
            templates: productDetail.templates!,
            templateBaseUrl: productDetail.basePathTemplatesImages ?? ''));
      } else {
        toastMessage(response?.message ?? '', isShort: false);
        getx.Get.close(2);
      }
      return response?.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return false;
  }

  Future<SpinItemsListResponse?> getSpinItemsList() async {
    try {
      AppDialogs.loading();
      final response = await _repository.getSpinItemsList();
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future getSpinVoucherList(String userID) async {
    try {
      spinVoucherSink.add(ApiResponse.loading("Fetching"));
      SpinVoucherListResponse response =
          await _repository.getSpinVoucherList(userID);
      if (response.success ?? false) {
        spinVoucherSink.add(ApiResponse.completed(response));
      } else {
        coinStatementSink
            .add(ApiResponse.error(response.message ?? 'Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      spinVoucherSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<DateTime> getCurrentDateTime() async {
    try {
      AppDialogs.loading();
      GetCurrentDateAndTimeModel? response =
          await _repository.getCurrentDateTime();
      DateTime currentDateTime = DateHelper.getDateTime(response?.data ?? "");
      return currentDateTime;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return DateTime.now();
  }

  Future getProductListCategory() async {
    try {
      AppDialogs.loading();
      productsCategorySink.add(ApiResponse.loading('Fetching'));

      GetProductCategoryListModel response =
          await _repository.getProductListCategory();

      if (response.success ?? false) {
        productsCategorySink.add(ApiResponse.completed(response));
      } else {
        toastMessage('Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      productsCategorySink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future getDetailedCategoryList({int? categoryId}) async {
    try {
      AppDialogs.loading();
      detailedProductsCategorySink.add(ApiResponse.loading('Fetching'));

      GetDetailedProductCategoryListModel? response =
          await _repository.getDetailedCategoryList(categoryId!);

      if (response!.success ?? false) {
        detailedProductsCategorySink.add(ApiResponse.completed(response));
      } else {
        toastMessage('Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      detailedProductsCategorySink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<HiCardBalanceModel?> getHICardBalance(String accountId) async {
    try {
      AppDialogs.loading();
      final response = await _repository.getHICardBalance(accountId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future checkHiCardDetails(String cardNumber, String pin) async {
    try {
      AppDialogs.loading();
      hiCardDetailsSink.add(ApiResponse.loading('Fetching'));

      CheckHiCardBalanceModel? response =
          await _repository.checkHiCardBalance(cardNumber, pin);

      if (response!.success ?? false) {
        hiCardDetailsSink.add(ApiResponse.completed(response));
      } else {
        toastMessage('Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      hiCardDetailsSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<CheckHiCardBalanceModel?> checkHiCardBalance(
      String cardNumber, String pin) async {
    try {
      AppDialogs.loading();
      final response = await _repository.checkHiCardBalance(cardNumber, pin);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future getHICardRedemptionHistory(String cardNumber, String pin,{String? fromDate,String? toDate}) async {
    try {
      AppDialogs.loading();
      hiCardRedemptionHistorySink.add(ApiResponse.loading('Fetching'));

      HiCardRedemptionHistoryModel? response =
          await _repository.getHICardRedemptionHistory(cardNumber, pin,fromDate: fromDate,toDate:toDate);

      if (response!.success ?? false) {
        hiCardRedemptionHistorySink.add(ApiResponse.completed(response));
      } else {
        toastMessage('Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      hiCardRedemptionHistorySink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future getHICardEarningHistory(String cardNumber, String pin,{String? fromDate,String? toDate}) async {
    try {
      AppDialogs.loading();
      hiCardEarningHistorySink.add(ApiResponse.loading('Fetching'));

      HiCardEarningHistoryModel? response =
          await _repository.getHICardEarningHistory(cardNumber, pin,fromDate: fromDate,toDate:toDate );

      if (response!.success ?? false) {
        hiCardEarningHistorySink.add(ApiResponse.completed(response));
      } else {
        toastMessage('Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      hiCardEarningHistorySink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<GiftHiCardModel?> giftHICard(
      {String? accountId,
      String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? message,
      String? amount}) async {
    try {
      AppDialogs.loading();
      final response = await _repository.giftHICard(accountId!, firstName!,
          lastName!, email!, phoneNumber!, message!, amount!);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<GiftHiCardModel?> hiCardLoadMoney(
      {String? accountId, String? hiCardId, String? amount}) async {
    try {
      AppDialogs.loading();
      final response =
          await _repository.hiCardLoadMoney(accountId!, hiCardId!, amount!);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<CommonResponse?> transferTouchpointsToHicard(
      {String? accountId, String? touchPoints, String? amount}) async {
    try {
      AppDialogs.loading();
      final response = await _repository.transferTouchpointsToHicard(
          accountId!, touchPoints!, amount!);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<GiftHiCardModel?> senfGiftToUsers({
    String? participantId,
    int? eventId,
    String? voucherType,
    String? amount,
    String? accountId,
  }) async {
    try {
      AppDialogs.loading();
      final response = await _repository.senfGiftToUsers(
          participantId!, eventId!, voucherType!, amount!, accountId!);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<CommonResponse?> checkHiCardValidity({
    String? cardNumber,
    String? pinNumber,
    String? amount,
  }) async {
    try {
      AppDialogs.loading();
      final response = await _repository.checkHiCardValidity(
          cardNumber!, pinNumber!, amount!);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future getHomeSliderImages() async {
    try {
      AppDialogs.loading();
      homeSliderImagesSink.add(ApiResponse.loading('Fetching'));

      GetHomeSliderImageModel? response =
          await _repository.getHomeSliderImages();

      if (response!.success ?? false) {
        homeSliderImagesSink.add(ApiResponse.completed(response));
      } else {
        toastMessage('Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      homeSliderImagesSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      AppDialogs.closeDialog();
    }
    
  }
 Future<GetPhysicalCardStatusModel?> getPhysicalCardStatus(
      String accountId) async {
    try {
      AppDialogs.loading();
      final response = await _repository.getPhysicalCardStatus(accountId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

 Future<HomscreenCommonApisModel?> homeScreenCommonApi(
      String accountId) async {
    try {
      AppDialogs.loading();
      final response = await _repository.homeScreenCommonApi(accountId);

      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  dispose() {
    profileSink?.close();
    referalCodeSink.close();
    spinVoucherSink.close();
    _profileController.close();
    _coinStatementController.close();
    _coinTransferHistoryController.close();
    _referalCodeController.close();
    _spinVoucherController.close();
    _productsCategoryController.close();
    _detailedProductsCategoryController.close();
    // _spinGiftsWonController.close();
    _hiCardRedemptionHistoryController.close();
    _hiCardEarningHistoryController.close();
    _hiCardDetailsController.close();
    _homeSliderImagesController.close();
  }
}

enum VerificationType { PAN, Aadhar }
