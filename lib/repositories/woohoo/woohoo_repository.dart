import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/redeem_order_response.dart';
import 'package:event_app/models/woohoo/card_balance_response.dart';
import 'package:event_app/models/woohoo/deals_for_you_products_model.dart';
import 'package:event_app/models/woohoo/get_food_and_movie_products_model.dart';
import 'package:event_app/models/woohoo/get_how_it_works_model.dart';
import 'package:event_app/models/woohoo/offers_product_list_model.dart';
import 'package:event_app/models/woohoo/order_status_response.dart';
import 'package:event_app/models/woohoo/transaction_history_response.dart';
import 'package:event_app/models/woohoo/woohoo_categories_response.dart';
import 'package:event_app/models/woohoo/woohoo_create_order_response.dart';
import 'package:event_app/models/woohoo/woohoo_product_detail_response.dart';
import 'package:event_app/models/woohoo/woohoo_product_list_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';

import '../../models/woohoo/check_voucher_code_valid_or_notmodel.dart';

class WoohooRepository {
  ApiProvider apiClient = ApiProvider();
  ApiProviderPrepaidCards apiProviderPPCards = ApiProviderPrepaidCards();
  WoohooRepository() {
    apiClient = ApiProvider();
    apiProviderPPCards = new ApiProviderPrepaidCards();
  }

  Future<WoohooCategoriesResponse> getCategories() async {
    Response response =
        await apiClient.getJsonInstance().get('${Apis.getProductCategories}');
    return WoohooCategoriesResponse.fromJson(response.data);
  }

  Future<WoohooProductListResponse> getProductList(
      String categoryId, bool isFoodOnly) async {
    String cat, type;
    if (isFoodOnly) {
      cat = 'null';
      type = '1';
    } else {
      type = 'null';
      cat = categoryId.isEmpty ? 'null' : categoryId;
    }

    Response response = await apiClient
        .getJsonInstance()
        .get('${Apis.ProductList}?type=$type&cat_id=$cat');
    return WoohooProductListResponse.fromJson(response.data);
  }

  Future<WoohooProductDetailResponse> getProductDetails(int id) async {
    Response response =
        await apiClient.getJsonInstance().get('${Apis.ProductDetails}?id=$id');

    return WoohooProductDetailResponse.fromJson(response.data);
  }

  Future<CommonResponse> sendInvoice(String type, String id) async {
    Map<String, dynamic> body = {"order_type": type, "id": id};
    Response response =
        await apiClient.getJsonInstance().post(Apis.sendInvoice, data: body);

    return CommonResponse.fromJson(response.data);
  }

  Future<RedeemOrderResponse> createRedeemOrder(
      Map<String, dynamic> body) async {
    Response response = await apiClient
        .getJsonInstance()
        .post(Apis.createRedeemOrder, data: body);

    return RedeemOrderResponse.fromJson(response.data);
  }

  Future<WoohooCreateOrderResponse?> createOrder(
      Map<String, dynamic> body) async {
    Response response = await apiClient
        .getJsonInstanceWoohoo('token')
        .post(Apis.orderCreation, data: body);

    return WoohooCreateOrderResponse.fromJson(response.data);
  }

  Future<OrderStatusResponse?> getOrderStatus(String referenceNo) async {
    // String? token = await getWoohooToken();
    // if(token ==null){
    //   return null;
    // }

    Response response = await apiClient
        .getJsonInstanceWoohoo('token')
        .get('${Apis.getOrderStatus}?ref_id=$referenceNo');

    return OrderStatusResponse.fromJson(response.data);
  }

  Future<OrderStatusResponse?> getActiveCards(String orderId) async {
    // String? token = await getWoohooToken();
    // if(token ==null){
    //   return null;
    // }

    Response response = await apiClient
        .getJsonInstanceWoohoo('token')
        .get('${Apis.getActiveCards}?order_id=$orderId');

    return OrderStatusResponse.fromJson(response.data);
  }

  Future<CardBalanceResponse> getCardBalance(Map<String, dynamic> body) async {
    // String? token = await getWoohooToken();
    // if(token ==null){
    //   return null;
    // }

    FormData data = FormData.fromMap(body);
    final response = await apiClient
        .getJsonInstanceWoohoo('token')
        .post('${Apis.cardBalance}', data: data);
    return CardBalanceResponse.fromJson(response.data);
  }

  Future<TransactionHistoryResponse> getTransactions(
      Map<String, dynamic> body) async {
    // String? token = await getWoohooToken();
    // if(token ==null){
    //   return null;
    // }

    FormData data = FormData.fromMap(body);
    final response = await apiClient
        .getJsonInstanceWoohoo('token')
        .post('${Apis.getTransactions}', data: data);
    return TransactionHistoryResponse.fromJson(response.data);
  }

  Future<OffersProductListModel> getOffersProductList() async {
    Response response = await apiProviderPPCards
        .getJsonInstance()
        .get('${Apis.offerProductList}');
    return OffersProductListModel.fromJson(json.decode(response.data));
  }

  Future<GetHowItWorksModel> getHowItworks() async {
    Response response =
        await apiProviderPPCards.getJsonInstance().get('${Apis.getHowItWorks}');
    return GetHowItWorksModel.fromJson(json.decode(response.data));
  }

  Future<DealsForYouProductsModel> dealsForYouProducts() async {
    Response response = await apiProviderPPCards
        .getJsonInstance()
        .get('${Apis.getDealsForYouProducts}');
     
    return DealsForYouProductsModel.fromJson(json.decode(response.data));
  }
 Future<CheckVoucherCodeValidOrNotmodel> checkVoucherCodeValidOrNot(String promoCode, int productId) async {
    Response response =
        await apiProviderPPCards.getJsonInstance().post(Apis.checkVoucherCodeValidOrNOt, data: {"promocode":promoCode,"product_id":productId});
    return CheckVoucherCodeValidOrNotmodel.fromJson(json.decode(response.data));
  }
  
   Future<GetFoodAndMovieProductsModel> getFoodAndMovieProducts() async {
    Response response = await apiProviderPPCards
        .getJsonInstance()
        .get('${Apis.getFoodAndMovieProducts}');
     
    return GetFoodAndMovieProductsModel.fromJson(json.decode(response.data));
  }
 
  Future<DealsForYouProductsModel> backToCampusProducts() async {
    Response response = await apiProviderPPCards
        .getJsonInstance()
        .get('${Apis.getBackToCampusProductsList}');
     
    return DealsForYouProductsModel.fromJson(json.decode(response.data));
  }
}

// Future<String?> getWoohooToken() async {
//   try {
//     Dio _dio = Dio(BaseOptions(
//       receiveTimeout: 40000,
//       connectTimeout: 40000,
//
//     ));
//     _dio.options.headers.addAll({"Content-Type": "application/json"});
//
//     print('verify');
//     Response res = await _dio.get('${ApiProvider.baseUrl}woohoo/verify');
//     print(res.data.toString());
//
//     Map<String,dynamic> map2 = res.data;
//     String? token = map2['token'];
//
//     return token;
//   } catch (e, s) {
//     Completer().completeError(e, s);
//     toastMessage(ApiErrorMessage.getNetworkError(e));
//   }
//   return null;
// }
