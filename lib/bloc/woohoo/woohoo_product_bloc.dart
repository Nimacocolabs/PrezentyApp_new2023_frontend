import 'dart:async';

import 'package:dio/dio.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/redeem_order_response.dart';
import 'package:event_app/models/woohoo/card_balance_response.dart';
import 'package:event_app/models/woohoo/deals_for_you_products_model.dart';
import 'package:event_app/models/woohoo/offers_product_list_model.dart';
import 'package:event_app/models/woohoo/order_status_response.dart';
import 'package:event_app/models/woohoo/transaction_history_response.dart';
import 'package:event_app/models/woohoo/woohoo_categories_response.dart';
import 'package:event_app/models/woohoo/woohoo_create_order_response.dart';
import 'package:event_app/models/woohoo/woohoo_product_detail_response.dart';
import 'package:event_app/models/woohoo/woohoo_product_list_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/woohoo/woohoo_repository.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/woohoo/check_voucher_code_valid_or_notmodel.dart';
import '../../models/woohoo/get_food_and_movie_products_model.dart';
import '../../models/woohoo/get_how_it_works_model.dart';

class WoohooProductBloc {
  WoohooRepository? _repository;
  late StreamController<ApiResponse<WoohooProductListResponse>>
      _itemsController;
  late StreamController<ApiResponse<WoohooProductDetailResponse>>
      _detailsController;

  late StreamController<ApiResponse<OffersProductListModel>>
     _offerProductsListController;

    late StreamController<ApiResponse<GetHowItWorksModel>>
     _howItWorksController;   

     late StreamController<ApiResponse<DealsForYouProductsModel>>
      _dealsProductsController;

         late StreamController<ApiResponse<GetFoodAndMovieProductsModel>>
      _foodAndMovieProductsController;

         late StreamController<ApiResponse<DealsForYouProductsModel>>
      _backToCampusProductController;

////////////////////////////////////

  StreamSink<ApiResponse<WoohooProductListResponse>> get itemsSink =>
      _itemsController.sink;

  Stream<ApiResponse<WoohooProductListResponse>> get itemsStream =>
      _itemsController.stream;

/////////////////////////////////////////////////////

  StreamSink<ApiResponse<WoohooProductDetailResponse>> get detailsSink =>
      _detailsController.sink;

  Stream<ApiResponse<WoohooProductDetailResponse>> get detailsStream =>
      _detailsController.stream;

/////////////////////////////////////////////////////////
        StreamSink<ApiResponse<OffersProductListModel>> get offerProductsListSink =>
      _offerProductsListController.sink;

  Stream<ApiResponse<OffersProductListModel>> get offerProductsListStream =>
      _offerProductsListController.stream;
//////////////////////////////////////////////////
 
        StreamSink<ApiResponse<GetHowItWorksModel>> get howItWorksSink =>
      _howItWorksController.sink;

  Stream<ApiResponse<GetHowItWorksModel>> get howItWorksStream =>
      _howItWorksController.stream;
//////////////////////////////////////////////////
 
   StreamSink<ApiResponse<DealsForYouProductsModel>> get dealsProductsSink =>
      _dealsProductsController.sink;

  Stream<ApiResponse<DealsForYouProductsModel>> get dealsProductsStream =>
      _dealsProductsController.stream;

/////////////////////////////////////////////////////
 
    StreamSink<ApiResponse<GetFoodAndMovieProductsModel>> get foodAndMovieProductsSink =>
      _foodAndMovieProductsController.sink;

  Stream<ApiResponse<GetFoodAndMovieProductsModel>> get foodAndMovieProductsStream =>
      _foodAndMovieProductsController.stream;

/////////////////////////////////////////////////////
  
  
     StreamSink<ApiResponse<DealsForYouProductsModel>> get backToCampusProductsSink =>
      _backToCampusProductController.sink;

  Stream<ApiResponse<DealsForYouProductsModel>> get backToCampusProductStream =>
      _backToCampusProductController.stream;

/////////////////////////////////////////////////////
WoohooProductBloc() {
    _repository = WoohooRepository();
    _itemsController =
        StreamController<ApiResponse<WoohooProductListResponse>>();
    _detailsController =
        StreamController<ApiResponse<WoohooProductDetailResponse>>();

    _offerProductsListController = 

  StreamController<ApiResponse<OffersProductListModel>>();

   _howItWorksController = 

  StreamController<ApiResponse<GetHowItWorksModel>>();

  _dealsProductsController =
        StreamController<ApiResponse<DealsForYouProductsModel>>();

          _foodAndMovieProductsController =
        StreamController<ApiResponse<GetFoodAndMovieProductsModel>>();

         _backToCampusProductController =
        StreamController<ApiResponse<DealsForYouProductsModel>>();
  }

  List<WoohooCategory> woohooCategories = [];

  Future<List<WoohooCategory>> getCategories() async {
    try {
      if (woohooCategories.isNotEmpty) {
        return woohooCategories;
      }
      AppDialogs.loading(alignment: Alignment.bottomCenter);
      WoohooCategoriesResponse response = await _repository!.getCategories();
      Get.back();
      if (response.success ?? false) {
        woohooCategories = response.data ?? [];
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return woohooCategories;
  }

  Future getProductList(String categoryId, bool isFoodOnly) async {
    try {
      itemsSink.add(ApiResponse.loading('Fetching'));
      WoohooProductListResponse response =
          await _repository!.getProductList(categoryId, isFoodOnly);
      if (response.success ?? false) {
        itemsSink.add(ApiResponse.completed(response));
      } else {
        itemsSink.add(ApiResponse.error(response.message));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      itemsSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<WoohooProductDetailResponse?> getProductDetails(int id) async {
    try {
      detailsSink.add(ApiResponse.loading('Fetching'));
      WoohooProductDetailResponse response =
          await _repository!.getProductDetails(id);
      detailsSink.add(ApiResponse.completed(response));
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      detailsSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
    return null;
  }

  Future sendInvoice(String type, String id) async {
    try {
      AppDialogs.loading();
      CommonResponse response = await _repository!.sendInvoice(type, id);
      Get.back();
    } catch (e, s) {
      Get.back();
      toastMessage(ApiErrorMessage.getNetworkError(e));
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<int?> createRedeemOrder(Map<String, dynamic> body) async {
    try {
      AppDialogs.loading();
      RedeemOrderResponse response = await _repository!.createRedeemOrder(body);
      Get.back();

      if (response.success ?? false) {
        return response.redeemId;
      }
    } catch (e, s) {
      Get.back();
      toastMessage(ApiErrorMessage.getNetworkError(e));
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<dynamic> createOrder(
      {required String userId,
      required int woohooProductId,
      required Map<String, dynamic> orderBody,
      bool showLoading = true,
      int? redeemTransactionId,
      int? upiTransactionId,
      String? rzpPaymentId,
      String? stateForRedeem,
        String ?decentro_txn_id,
      int? themeId,
        String? orderType, String? touchPoint, String? payAmount,
     int? insTableId,
     String? hiCardNo,
     String? hiCardPinNumber,
     String? payableAmnt,
     String? eventId,

      }) async {
    try {
      if (upiTransactionId == null &&
          redeemTransactionId == null &&
          rzpPaymentId == null) {
        print('Order not found');
      }

      if (showLoading) AppDialogs.loading();

      Map<String, dynamic> body1 = {
        "card_number":hiCardNo,
        "pin_number":hiCardPinNumber,
        "payable_amount":payableAmnt,
        "ins_table_id": insTableId, // spin ins table id. default 0
        "product_id": woohooProductId,
        "decentro_txn_id":decentro_txn_id,
        "user_id": userId,
        "event_id":eventId,
        "state": stateForRedeem,
        "touch_point": touchPoint,
        "pay_amount":payAmount,
        "order_type": orderType??(upiTransactionId != null
            ? "FOOD"
            : redeemTransactionId != null
            ? "REDEEM"
            : rzpPaymentId != null
            ? "BUY"
            : ""),
        "upi_transaction_id": upiTransactionId,
        "redeem_transaction_id": redeemTransactionId,
        "rzp_payment_id": rzpPaymentId,
        "orderBody": orderBody,
        "template_img":themeId,
        
      };

      WoohooCreateOrderResponse? response =
          await _repository!.createOrder(body1);
      if (showLoading) Get.back();
      return response;
    } catch (e, s) {
      if (showLoading) Get.back();
      Completer().completeError(e, s);

      if (e is DioError && e.type == DioErrorType.connectTimeout) {
        return 1;
      }
    }
    return null;
  }

  Future<OrderStatusResponse?> getOrderStatus(String referenceNo) async {
    try {
      AppDialogs.loading();
      OrderStatusResponse? response =
          await _repository!.getOrderStatus(referenceNo);
      Get.back();
      return response;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<OrderStatusResponse?> getActiveCards(String orderId) async {
    try {
      AppDialogs.loading();
      OrderStatusResponse? response =
          await _repository!.getActiveCards(orderId);
      Get.back();
      return response;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<CardBalanceData?> getCardBalance(String cardNo, String pinNo) async {
    try {
      CardBalanceResponse response = await _repository!
          .getCardBalance({"cardNumber": "$cardNo", "pin": "$pinNo"});

      if (response.success ?? false) {
        return response.data;
      } else {
        toastMessage(response.message ?? 'Unable to complete request');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

  Future<TransactionHistoryData?> getTransactions(
      String cardNo, String pinNo) async {
    try {
      TransactionHistoryResponse? response =
          await _repository!.getTransactions({
        "cards": [
          {"cardNumber": "$cardNo", "pin": "$pinNo"}
        ]
      });
      if (response.success ?? false) {
        return response.data;
      } else {
        toastMessage(response.message ?? 'Unable to complete request');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }


  Future getOffersProductList() async {
    try {
      offerProductsListSink.add(ApiResponse.loading('Fetching'));
      OffersProductListModel response =
          await _repository!.getOffersProductList();
      if (response.success ?? false) {
        offerProductsListSink.add(ApiResponse.completed(response));
      } else {
        offerProductsListSink.add(ApiResponse.error(response.message));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      itemsSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

Future<GetHowItWorksModel?>getHowItWorks() async {
    
    try {
       AppDialogs.loading();
      howItWorksSink.add(ApiResponse.loading('Fetching'));
   
      GetHowItWorksModel response =
          await _repository!.getHowItworks();
          print("aa11");
           print(response.success);
           print("bb22");
      if (response.success ?? false) {
        howItWorksSink.add(ApiResponse.completed(response));
      } else {
        howItWorksSink
            .add(ApiResponse.error('Something went wrong'));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
     howItWorksSink
          .add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }finally {
      Get.back();
    }
  }


 Future dealsForYouProducts() async {
    try {
      dealsProductsSink.add(ApiResponse.loading('Fetching'));
      
     
      DealsForYouProductsModel response =
          await _repository!.dealsForYouProducts();
        

      if (response.success ?? false) {
        dealsProductsSink.add(ApiResponse.completed(response));
      } else {
         toastMessage( 'Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      dealsProductsSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<CheckVoucherCodeValidOrNotmodel> checkVoucherCodeValidOrNot(String promoCode, int productId) async {
    try {
      return await _repository!.checkVoucherCodeValidOrNot(promoCode, productId);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }


   Future getFoodAndMovieProducts() async {
    try {
      foodAndMovieProductsSink.add(ApiResponse.loading('Fetching'));
      
     
      GetFoodAndMovieProductsModel response =
          await _repository!.getFoodAndMovieProducts();
        

      if (response.success ?? false) {
        foodAndMovieProductsSink.add(ApiResponse.completed(response));
      } else {
         toastMessage( 'Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      foodAndMovieProductsSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }


   Future backToCampusProducts() async {
    try {
      backToCampusProductsSink.add(ApiResponse.loading('Fetching'));
      
     
      DealsForYouProductsModel response =
          await _repository!.backToCampusProducts();
        

      if (response.success ?? false) {
        backToCampusProductsSink.add(ApiResponse.completed(response));
      } else {
         toastMessage( 'Something went wrong.');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      backToCampusProductsSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  dispose() {
    itemsSink.close();
    _itemsController.close();
    detailsSink.close();
    _detailsController.close();

    offerProductsListSink.close();
   _offerProductsListController.close();

   _howItWorksController.close();
   _dealsProductsController.close();

   _foodAndMovieProductsController.close();
   _backToCampusProductController.close();

   

  }
}
