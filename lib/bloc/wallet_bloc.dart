import 'dart:async';
import 'dart:convert';

import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/qr_code_model.dart';
import 'package:event_app/models/touchpoint_wallet_balance_response.dart';
import 'package:event_app/models/check_scratchcard_valid_or_not_model.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/models/validate_card.dart';
import 'package:event_app/models/wallet&prepaid_cards/fetch_user_details_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/get_load_money_content.dart';
import 'package:event_app/models/wallet&prepaid_cards/load_money_transaction_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoints_earning_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoints_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoint_redemption_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/apply_card_tax_info_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/auth_mpin_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/available_card_list_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/card_offers_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/check_physical_card_exists_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/coupon_listing_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/fetch_cvv_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/forget_mpin_send_otp_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_verify_otp.dart';
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
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/wallet_repository.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:get/get.dart';

import '../models/block_card_response.dart';
import '../models/offer_response.dart';
import '../models/wallet&prepaid_cards/existing_payee_model.dart';
import '../models/wallet&prepaid_cards/get_merchants_list_model.dart';
import '../network/api_provider.dart';
import '../network/apis.dart';
import '../widgets/app_dialogs.dart';

class WalletBloc {
  WalletRepository? _walletRepository;
  WalletPaymentUpiResponse? walletPaymentUpiResponse;

  WalletBloc({this.listener}) {
    if (_walletRepository == null) _walletRepository = WalletRepository();
    _statementController =
        StreamController<ApiResponse<WalletStatementResponse>>();
    _getStateListController =
        StreamController<ApiResponse<StateCodeResponse>>.broadcast();
    _getAvailableCardListController =
        StreamController<ApiResponse<dynamic>>.broadcast();
    _getCardOfferListController =
        StreamController<ApiResponse<GetCardOffersResponse>>();
    _getWalletDetailsController =
        StreamController<ApiResponse<WalletDetailsResponse>>();
    _OfferListController =
        StreamController<ApiResponse<OffersResponse>>.broadcast();
    _CouponListController = StreamController<ApiResponse<CouponListingModel>>();
    _TouchPointsController = StreamController<ApiResponse<TouchPointsModel>>();
    _TouchPointsEarningHistoryController =
        StreamController<ApiResponse<TouchPointsEarningHistoryModel>>();
    _TouchPointsRedemptionHistoryController =
        StreamController<ApiResponse<TouchPointsRedemptionHistoryModel>>();
    _GetMerchantsListController =
        StreamController<ApiResponse<GetMerchantsListModel>>();
    _getExistingPayeeController =
        StreamController<ApiResponse<ExistingPayeeModel>>();
    _getFavouritePayeesListController =
        StreamController<ApiResponse<ExistingPayeeModel>>();
        _loadMoneyTransactionHistoryController =
        StreamController<ApiResponse<LoadMoneyTransactionHistoryModel>>();
  }

  bool isLoading = false;
  bool hasNextPage = true;
  int pageNumber = 0;
  int perPage = 20;
  WalletDetails? walletDetailsData;

  LoadMoreListener? listener;

  late StreamController<ApiResponse<WalletStatementResponse>>
      _statementController;

  StreamSink<ApiResponse<WalletStatementResponse>>? get stamementSink =>
      _statementController.sink;

  Stream<ApiResponse<WalletStatementResponse>> get statementStream =>
      _statementController.stream;

  List<Transactions> statementList = [];

//------------------------------------------------------------------------------
  late StreamController<ApiResponse<StateCodeResponse>> _getStateListController;

  StreamSink<ApiResponse<StateCodeResponse>> get _getStateListSink =>
      _getStateListController.sink;

  Stream<ApiResponse<StateCodeResponse>> get getStateListStream =>
      _getStateListController.stream;

//------------------------------------------------------------------------------
  late StreamController<ApiResponse<dynamic>> _getAvailableCardListController;

  StreamSink<ApiResponse<dynamic>> get _getAvailableCardListSink =>
      _getAvailableCardListController.sink;

  Stream<ApiResponse<dynamic>> get getAvailableCardListStream =>
      _getAvailableCardListController.stream;

//------------------------------------------------------------------------------
  late StreamController<ApiResponse<GetCardOffersResponse>>
      _getCardOfferListController;

  StreamSink<ApiResponse<GetCardOffersResponse>> get _getCardOfferListSink =>
      _getCardOfferListController.sink;

  Stream<ApiResponse<GetCardOffersResponse>> get getCardOfferListStream =>
      _getCardOfferListController.stream;

//------------------------------------------------------------------------------
  late StreamController<ApiResponse<WalletDetailsResponse>>
      _getWalletDetailsController;

  StreamSink<ApiResponse<WalletDetailsResponse>> get _getWalletDetailsSink =>
      _getWalletDetailsController.sink;

  Stream<ApiResponse<WalletDetailsResponse>> get getWalletDetailsStream =>
      _getWalletDetailsController.stream;

//------------------------------------------------------------------------------

  late StreamController<ApiResponse<OffersResponse>> _OfferListController;

  StreamSink<ApiResponse<OffersResponse>> get OfferListSink =>
      _OfferListController.sink;

  Stream<ApiResponse<OffersResponse>> get OfferListStream =>
      _OfferListController.stream;

  //------------------------------------------------------------------------------

  late StreamController<ApiResponse<CouponListingModel>> _CouponListController;

  StreamSink<ApiResponse<CouponListingModel>> get _CouponListSink =>
      _CouponListController.sink;

  Stream<ApiResponse<CouponListingModel>> get CouponListStream =>
      _CouponListController.stream;

//------------------------------------------------------------------------------

  late StreamController<ApiResponse<TouchPointsModel>> _TouchPointsController;

  StreamSink<ApiResponse<TouchPointsModel>> get _TouchPointSink =>
      _TouchPointsController.sink;

  Stream<ApiResponse<TouchPointsModel>> get TouchPointStream =>
      _TouchPointsController.stream;

//------------------------------------------------------------------------------
  late StreamController<ApiResponse<TouchPointsEarningHistoryModel>>
      _TouchPointsEarningHistoryController;

  StreamSink<ApiResponse<TouchPointsEarningHistoryModel>>
      get _TouchPointEarningHistorySink =>
          _TouchPointsEarningHistoryController.sink;

  Stream<ApiResponse<TouchPointsEarningHistoryModel>>
      get TouchPointEarningHistoryStream =>
          _TouchPointsEarningHistoryController.stream;

//------------------------------------------------------------------------------

  late StreamController<ApiResponse<TouchPointsRedemptionHistoryModel>>
      _TouchPointsRedemptionHistoryController;

  StreamSink<ApiResponse<TouchPointsRedemptionHistoryModel>>
      get _TouchPointRedemptionHistorySink =>
          _TouchPointsRedemptionHistoryController.sink;

  Stream<ApiResponse<TouchPointsRedemptionHistoryModel>>
      get TouchPointRedemptionHistoryStream =>
          _TouchPointsRedemptionHistoryController.stream;

//------------------------------------------------------------------------------

  late StreamController<ApiResponse<GetMerchantsListModel>>
      _GetMerchantsListController;

  StreamSink<ApiResponse<GetMerchantsListModel>> get _GetMerchantsListSink =>
      _GetMerchantsListController.sink;

  Stream<ApiResponse<GetMerchantsListModel>> get GetMerchantsListStream =>
      _GetMerchantsListController.stream;

//------------------------------------------------------------------------------

  late StreamController<ApiResponse<ExistingPayeeModel>>
      _getExistingPayeeController;

  StreamSink<ApiResponse<ExistingPayeeModel>> get _getExistingPayeeSink =>
      _getExistingPayeeController.sink;

  Stream<ApiResponse<ExistingPayeeModel>> get getExistingPayeeStream =>
      _getExistingPayeeController.stream;

//------------------------------------------------------------------------------

  late StreamController<ApiResponse<ExistingPayeeModel>>
      _getFavouritePayeesListController;

  StreamSink<ApiResponse<ExistingPayeeModel>> get _getFavouritePayeesListSink =>
      _getFavouritePayeesListController.sink;

  Stream<ApiResponse<ExistingPayeeModel>> get getFavouritePayeesListStream =>
      _getFavouritePayeesListController.stream;

//------------------------------------------------------------------------------

   late StreamController<ApiResponse<LoadMoneyTransactionHistoryModel>>
      _loadMoneyTransactionHistoryController;

  StreamSink<ApiResponse<LoadMoneyTransactionHistoryModel>> get _loadMoneyTransactionHistorySink =>
      _loadMoneyTransactionHistoryController.sink;

  Stream<ApiResponse<LoadMoneyTransactionHistoryModel>> get loadMoneyTransactionHistoryStream =>
      _loadMoneyTransactionHistoryController.stream;

//------------------------------------------------------------------------------

  getCardOfferList(int cardId) async {
    try {
      _getCardOfferListSink.add(ApiResponse.loading('Fetching'));

      GetCardOffersResponse response =
          await _walletRepository!.GetCardOffers(cardId);
      if (response.success ?? false) {
        _getCardOfferListSink.add(ApiResponse.completed(response));
      } else {
        _getCardOfferListSink
            .add(ApiResponse.error(response.message ?? 'Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getCardOfferListSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  getAvailableCardList() async {
    _getAvailableCardListSink.add(ApiResponse.loading('Fetching'));
    try {
      AppDialogs.loading();

      GetAllAvailableCardListResponse response =
          await _walletRepository!.getAllAvailableCardList();
      if (response.success ?? false) {
        _getAvailableCardListSink.add(ApiResponse.completed(response));
      } else {
        _getAvailableCardListSink
            .add(ApiResponse.error(response.message ?? 'Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getAvailableCardListSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    } finally {
      Get.back();
    }
  }

  Future<StateCodeResponse?> getStateList() async {
    try {
      _getStateListSink.add(ApiResponse.loading('Fetching'));

      StateCodeResponse response = await _walletRepository!.getStateList();
      if (response.success ?? false) {
        _getStateListSink.add(ApiResponse.completed(response));
        return response;
      } else {
        _getStateListSink
            .add(ApiResponse.error(response.message ?? 'Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getStateListSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
    return null;
  }

  getOffers() async {
    try {
      OfferListSink.add(ApiResponse.loading('Fetching'));

      OffersResponse response = await _walletRepository!.getOffers();
      if (response.success ?? false) {
        OfferListSink.add(ApiResponse.completed(response));
      } else {
        OfferListSink.add(
            ApiResponse.error(response.message ?? 'Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      OfferListSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<CommonResponse> setWalletPin(String accountId, String mPin) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.setWalletPin(accountId, mPin);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<bool> checkEnableRequestPhysicalCard(
      String entityId, String kitNo) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.checkEnableRequestPhysicalCard(
          {"entity_id": entityId, "kit_no": kitNo});
    } catch (e, s) {
      Completer().completeError(e, s);
      return false;
    } finally {
      Get.back();
    }
  }

  Future<AuthMPinResponse> authWalletPin(String accountId, String mPin) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.authWalletPin(accountId, mPin);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<ForgetMPinSendOtpResponse> forgetWalletPinSendOtp(
      String accountId) async {
    try {
      return await _walletRepository!.forgetWalletPinSendOtp(accountId);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<CommonResponse> resetWalletPinUpdateWalletPin(
      String accountId, String mPin,
      {int? otpReferenceId = null,
      String? oldMPin = null,
      int? status,
      String? otp = null}) async {
    try {
      return await _walletRepository!.resetWalletPinUpdateWalletPin(
          accountId, mPin,
          status: status,
          otpReferenceId: otpReferenceId,
          otp: otp,
          oldMPin: oldMPin);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  //____________________________________________________________________________

  Future<WalletCreationAndPaymentStatus> walletCreationAndPaymentStatus(
      String userId, String cardId) async {
    try {
      WalletCreationAndPaymentStatus response = await _walletRepository!
          .walletCreationAndPaymentStatus(userId, cardId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<RegisterWalletResponse> registerWallet(Map<String, dynamic> body) async {
    try {
      RegisterWalletResponse response =
          await _walletRepository!.registerWallet(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<RegisterWalletResponse> registerWalletResentOtp(
      String? userId, String? kycReferenceId) async {
    try {
      RegisterWalletResponse response = await _walletRepository!
          .registerWalletResendOtp(userId, kycReferenceId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<RegisterWalletVerifyOtp> registerWalletVerifyOtp(Map body) async {
    try {
      RegisterWalletVerifyOtp response =
          await _walletRepository!.verifyWalletRegistrationOtp(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<RegisterWalletResponse> registerWalletResendOtp(
      String? userId, String? kycReferenceId) async {
    try {
      RegisterWalletResponse response = await _walletRepository!
          .registerWalletResendOtp(userId, kycReferenceId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<WalletDetails?> getWalletDetails(String? userId) async {
    try {
      _getWalletDetailsSink.add(ApiResponse.loading('Fetching'));
      walletDetailsData = null;
      WalletDetailsResponse response =
          await _walletRepository!.getWalletDetails(userId);

      if (response.success ?? false) {
        walletDetailsData = response.walletDetails;
        if (response.walletDetails!.cardDetails!.status == "LOCKED") {
          Get.back();
          AppDialogs.message(
              'Your wallet is currently inactive. If you wish to activate your wallet please contact the customer care.');
          return null;
        }
        _getWalletDetailsSink.add(ApiResponse.completed(response));
      } else {
        if (response.statusCode == 500) {
          Get.back();
          AppDialogs.message(response.message ?? 'Something went wrong');
        } else {
          _getWalletDetailsSink.add(
              ApiResponse.error(response.message ?? 'Something went wrong'));
        }
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getWalletDetailsSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
    return walletDetailsData;
  }

  Future getCardUpgradePlans(String accountId, int cardId) async {
    try {
      _getAvailableCardListSink.add(ApiResponse.loading('Fetching'));

      GetAllAvailableCardListResponse response =
          await _walletRepository!.getCardUpgradePlans(accountId, cardId);
      if (response.success ?? false) {
        _getAvailableCardListSink.add(ApiResponse.completed(response));
      } else {
        _getAvailableCardListSink
            .add(ApiResponse.error('Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getAvailableCardListSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<bool> getEnableUpgradeButton(String accountId, int cardId) async {
    try {
      GetAllAvailableCardListResponse response =
          await _walletRepository!.getEnableUpgradeButton(accountId, cardId);

      return response.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return false;
  }

  Future<SetCardPinResponse> setCardPin() async {
    try {
      //AppDialogs.loading();
      SetCardPinResponse response =
          await _walletRepository!.setCardPin();
      toastMessage(response.message);
      print("Response-->${response.widgetUrl}");
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<BlockCardResponse> blockCard(String body) async {
    try {
      BlockCardResponse response = await _walletRepository!.blockCard(body);
      toastMessage(response.message);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<BlockCardResponse> replaceCard(String body) async {
    try {
      BlockCardResponse response = await _walletRepository!.replaceCard(body);
      toastMessage(response.message);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  getStatementList(bool isPagination,
      {String? entityId, String? fromDate, String? toDate}) async {
    if (isLoading) return;

    isLoading = true;
    if (isPagination) {
      pageNumber++;
      listener!.refresh(true);
    } else {
      statementList = [];
      pageNumber = 0;
      stamementSink!.add(ApiResponse.loading('Fetching items'));
    }
    try {
      WalletStatementResponse response =
          await _walletRepository!.getStatementList(
            entityId: entityId,
        fromDate: fromDate,
        toDate: toDate,
        pageNumber: pageNumber,
      );

      if (response.pagination?.totalPages == 0) {
        hasNextPage = false;
        toastMessage('No more transactions');
      }
      // hasNextPage = response.hasNextPage!;
      // pageNumber = response.page!;
      // if (isPagination) {
      //   if (itemsList.length == 0) {
      //     itemsList = response.list!;
      //   } else {
      //     itemsList.addAll(response.list!);
      //   }
      // } else {
      statementList.addAll(response.transactions ?? []);
      // }
      stamementSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        listener!.refresh(false);
      }
    } catch (error, s) {
      Completer().completeError(error, s);
      if (isPagination) {
        listener!.refresh(false);
      } else {
        stamementSink!.add(ApiResponse.error(
            ("From and To dates can not be separated by more than 90 days.")));
      }
    } finally {
      isLoading = false;
    }
  }

  Future<FetchCardCvvResponse> getCardCVV(
      String? userId, String? kitNumber) async {
    AppDialogs.loading();
    FetchCardCvvResponse response =
        await _walletRepository!.getCardCVV(userId, kitNumber);
    toastMessage(response.message);
    AppDialogs.closeDialog();
    return response;
  }

  Future<CheckPhysicalCardExistsResponse> checkPhysicalCardExists(
      String? userId, String? cardNumber) async {
    try {
      CheckPhysicalCardExistsResponse response =
          await _walletRepository!.checkPhysicalCardExists(userId, cardNumber);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<RequestPhysicalCardResponse> requestPhysicalCard(
      String? userId, String? kitNumber, String? cardNumber, String? status,
      {String? address,
      String? pinCode,
      String? city,
      String? stateCode}) async {
    try {
      RequestPhysicalCardResponse response =
          await _walletRepository!.requestPhysicalCard(
        userId,
        kitNumber,
        cardNumber,
        status,
        address: address,
        pinCode: pinCode,
        city: city,
        stateCode: stateCode,
      );
      toastMessage(response.message);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<ApplyCardTaxInfoResponse?> getApplyCardTaxInfo(
      Map<String, dynamic> body) async {
    try {
      AppDialogs.loading();
      ApplyCardTaxInfoResponse response =
          await _walletRepository!.getApplyCardTaxInfo(body);

      Get.back();

      if (response.success ?? false) {
        return response;
      } else {
        toastMessage('Something went wrong');
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

  Future<bool?> getMPinStatus(String accountId) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.getMPinStatus(accountId);
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

  getCouponListing(String cardId) async {
    try {
      _CouponListSink.add(ApiResponse.loading('Fetching'));

      CouponListingModel response =
          await _walletRepository!.getCouponListing(cardId);
      if (response.success ?? false) {
        _CouponListSink.add(ApiResponse.completed(response));
      } else {
        _CouponListSink.add(ApiResponse.error('No coupons available now '));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _CouponListSink.add(
          ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<bool> validate(String cardId, String code) async {
    try {
      AppDialogs.loading();
      CommonResponse response = await _walletRepository!.validate(cardId, code);
      return response.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return false;
  }

  Future<UpgradeCouponTaxInfo?> getupgardeCouponTaxInfo(
      int? cardId, String accountId) async {
    try {
      AppDialogs.loading();
      UpgradeCouponTaxInfo response = await _walletRepository!
          .getupgardeCouponTaxInfo(cardId.toString(), accountId.toString());
      Get.back();

      if (response.success ?? false) {
        return response;
      } else {
        toastMessage('Something went wrong');
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

  Future<bool> transactionStatusCheck(
      Map<String, dynamic> body, String type) async {
    //type = apply_card,upgrade_card.
    try {
      AppDialogs.loading();
      CommonResponse response =
          await _walletRepository!.transactionStatusCheck(body, type);
      Get.back();
      if (!(response.success ?? false)) {
        toastMessage(response.message);
      }
      return response.success ?? false;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      // throw e;
    }
    return false;
  }

  Future<CommonResponse> walletNavigation(String accountId) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.walletNavigation(accountId);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  getTouchPoints(String accountId) async {
    try {
      _TouchPointSink.add(ApiResponse.loading('Fetching'));

      TouchPointsModel response =
          (await _walletRepository!.getTouchPoints(accountId));
      if (response.success ?? false) {
        _TouchPointSink.add(ApiResponse.completed(response));
      } else {
        _TouchPointSink.add(ApiResponse.error('No touchpoints available  '));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _TouchPointSink.add(ApiResponse.error('-'));
    }
  }

  getTPEarningHistory(String accountId) async {
    try {
      _TouchPointEarningHistorySink.add(ApiResponse.loading('Fetching'));

      TouchPointsEarningHistoryModel response =
          await _walletRepository!.getTPEarningHistory(accountId);
      if (response.success ?? false) {
        _TouchPointEarningHistorySink.add(ApiResponse.completed(response));
      } else {
        _TouchPointEarningHistorySink.add(ApiResponse.error('No content'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _TouchPointEarningHistorySink.add(
          ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  getTPRedemptionHistory(String accountId) async {
    try {
      _TouchPointRedemptionHistorySink.add(ApiResponse.loading('Fetching'));

      TouchPointsRedemptionHistoryModel response =
          await _walletRepository!.getTPRedemptionHistory(accountId);
      if (response.success ?? false) {
        _TouchPointRedemptionHistorySink.add(ApiResponse.completed(response));
      } else {
        _TouchPointRedemptionHistorySink.add(ApiResponse.error('No content'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _TouchPointRedemptionHistorySink.add(
          ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<TouchPointWalletBalanceData?> getTouchPointWalletBalance(
      String accountId) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.getTouchPointWalletBalance(accountId);
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

  Future<UserPermanentAddressData?> getUserPermanentAddress(
      String accountId) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.getUserPermanentAddress(accountId);
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

  Future<TermsAndConditionsData?> termsAndConditions() async {
    try {
      AppDialogs.loading();
      TermsAndConditionsData? response =
          await _walletRepository!.termsAndConditions();
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

  Future<fetchUserData?> fetchUserKYCDetails(String accountId) async {
    try {
      AppDialogs.loading();
      fetchUserData? response =
          (await _walletRepository!.fetchUserDetails(accountId)).data;
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<ApplyCardTaxInfoData?> getPhysicalCardRequestAmount(
      String accountId) async {
    try {
      AppDialogs.loading();
      ApplyCardTaxInfoData? response =
          (await _walletRepository!.getPhysicalCardRequestAmount(accountId))
              .data;
      print(response);
      return response;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<ValidateCardData?> validatePrepaidCardNumber(
      String userId, String cardNumber) async {
    try {
      AppDialogs.loading();
      ValidateCardData? response = await _walletRepository!
          .validatePrepaidCardNumber(userId, cardNumber);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<CheckScratchcardValidOrNotModel?> getScratchCodeValidOrNot(
      String accountId, String cardId, String code,
      {String? referralCode}) async {
    try {
      AppDialogs.loading();
      CheckScratchcardValidOrNotModel? response = await _walletRepository!
          .getScratchCodeValidOrNot(accountId, cardId, code,
              referralCode: referralCode);
      Get.back();

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
  }

  Future<CommonResponse> getCustomerCardType(String accountId) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.getCustomerCardType(accountId);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future getMerchantsList() async {
    try {
      _GetMerchantsListSink.add(ApiResponse.loading('Fetching'));

      GetMerchantsListModel response =
          await _walletRepository!.getMerchantsList();

      if (response.success ?? false) {
        _GetMerchantsListSink.add(ApiResponse.completed(response));
      } else {
        toastMessage('Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _GetMerchantsListSink.add(
          ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<CommonResponse> validateWalletNumber({
    String? accountId,String? walletNumber,String? type,String? eventID,String? amount}) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!
          .validateWalletNumber(
            accountId:accountId,
            walletNumber: walletNumber,
            type: type,
            eventID: eventID,
            amount:amount,
            );
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  // Future<String?> walletUPIPayment(
  //     {String? accountId,
  //     String? type,
  //     String? amount,
  //     String? walletNumber}) async {
  //   try {
  //     AppDialogs.loading();
  //  QrCodeModel? response =    await _walletRepository!.walletUPIPayment(
  //         accountId: accountId,
  //         type: type,
  //         amount: amount,
  //         walletNumber: walletNumber);
  //           if(response.success??false){
  //       walletPaymentUpiResponse = response.data;
  //       return '';
  //     }else{
  //       return response.message??'Unable to create upi link';
  //     }
  //   } catch (e, s) {
  //     Completer().completeError(e, s);
  //     throw e;
  //   } finally {
  //     Get.back();
  //   }
  // }

  Future<QrCodeModel> testWallet(
      {String? accountId,
      String? type,
      String? amount,
      String? walletNumber,
      String? eventId}) async {
    try {
      AppDialogs.loading();
      
      QrCodeModel response =  await _walletRepository!.testWallet(
          accountId: accountId,
          type: type,
          amount: amount,
          walletNumber: walletNumber,
          eventId:eventId);
          
          return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<CommonResponse> checkWalletPayeeExistOrNot(
      {String? accountId, String? walletNumber}) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.checkWalletPayeeExistOrNot(
          accountId: accountId, walletNumber: walletNumber);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<CommonResponse> addWalletBeneficiary(
      {String? accountId,
      String? walletNumber,
      String? beneficiaryName}) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.addWalletBeneficiary(
          accountId: accountId,
          walletNumber: walletNumber,
          beneficiaryName: beneficiaryName);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future getExistingPayees({String? accountId}) async {
    try {
      _getExistingPayeeSink.add(ApiResponse.loading('Fetching'));

      ExistingPayeeModel response =
          await _walletRepository!.getExistingPayees(accountId: accountId);

      if (response.success ?? false) {
        _getExistingPayeeSink.add(ApiResponse.completed(response));
      } else {
        _getExistingPayeeSink.add(ApiResponse.error('${response.message}'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getExistingPayeeSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<CommonResponse> addBeneficiaryToFavourite({String? id}) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.addBeneficiaryToFavourite(id: id);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<CommonResponse> removeBeneficiaryToFavourite({String? id}) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.removeBeneficiaryToFavourite(id: id);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<CommonResponse> deleteBeneficiary({String? id}) async {
    try {
      AppDialogs.loading();
      return await _walletRepository!.deleteBeneficiary(id: id);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future getFavouritePayeesList({String? accountId}) async {
    try {
      _getFavouritePayeesListSink.add(ApiResponse.loading('Fetching'));

      ExistingPayeeModel response =
          await _walletRepository!.getFavouritePayeesList(accountId: accountId);

      if (response.success ?? false) {
        _getFavouritePayeesListSink.add(ApiResponse.completed(response));
      } else {
        _getFavouritePayeesListSink
            .add(ApiResponse.error('${response.message}'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _getFavouritePayeesListSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<CommonResponse> walletLoadTransactionStatusCheck(
      {String? accountId, String? insTableId}) async {
    try {
       //AppDialogs.loading();
      return await _walletRepository!.getVATransactionSuccessOrNot(
          accountId: accountId, insTableId: insTableId);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      // Get.back();
    }
  }

  
  Future loadMoneyTransactionHistory({String? accountId,String? type}) async {
    try {
      _loadMoneyTransactionHistorySink.add(ApiResponse.loading('Fetching'));

      LoadMoneyTransactionHistoryModel response =
          await _walletRepository!.loadMoneyTransactionHistory(accountId: accountId,type: type);

      if (response.success ?? false) {
        _loadMoneyTransactionHistorySink.add(ApiResponse.completed(response));
      } else {
        _loadMoneyTransactionHistorySink
            .add(ApiResponse.error('${response.message}'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      _loadMoneyTransactionHistorySink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<GetLoadMoneyContent?> getLoadMoneyContent() async {
    try {
      AppDialogs.loading();
      GetLoadMoneyContent? response =
          await _walletRepository!.getLoadMoneyContent();
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

   Future<CommonResponse> checkVAStatementStatus(
      {String? accountId, String? insTableId}) async {
    try {
       //AppDialogs.loading();
      CommonResponse response =  await _walletRepository!.checkVAStatementStatus(
          accountId: accountId, insTableId: insTableId);
          print("bloc response = ${response}");
          return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      // Get.back();
    }
  }

  dispose() {
    stamementSink?.close();
    _statementController.close();

    _getStateListSink.close();
    _getStateListController.close();

    _getAvailableCardListController.close();
    _getAvailableCardListSink.close();

    _getCardOfferListController.close();
    _getCardOfferListSink.close();

    _getWalletDetailsSink.close();
    _getWalletDetailsController.close();

    _OfferListController.close();
    _CouponListController.close();

    _TouchPointsController.close();
    _TouchPointsEarningHistoryController.close();

    _TouchPointsRedemptionHistoryController.close();
    _GetMerchantsListController.close();

    _getExistingPayeeController.close();
    _getFavouritePayeesListController.close();


    _loadMoneyTransactionHistoryController.close();
  }

  Future<bool> checkEventVaCreated(String userId) async {
    try {
      AppDialogs.loading();
      final response = await ApiProvider()
          .getJsonInstance()
          .get('${Apis.checkEventVaCreated}?userid=$userId');
      CommonResponse _res = CommonResponse.fromJson(response.data);

      return _res.success ?? false;
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    } finally {
      AppDialogs.closeDialog();
    }
    return false;
  }
}
