import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/models/send_food_order_list_response.dart';
import 'package:event_app/models/send_food_participant_list_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/apis.dart';

class SendFoodVoucherRepository{
  late ApiProvider apiProvider;

  SendFoodVoucherRepository() {
    apiProvider = new ApiProvider();
  }

  Future<SendFoodParticipantListResponse> getAllEventParticipants(int eventId) async {
    final response = await apiProvider.getJsonInstance().get(
        "${Apis.getEventParticipantsList}?event_id=$eventId");
    return SendFoodParticipantListResponse.fromJson(response.data);
  }

  Future<PaymentTaxResponse> createOrder(String orderId, Map<String,dynamic> map)
  async {
    FormData formData = FormData.fromMap(map);
    final response = await apiProvider.getMultipartInstance().post(
        "${Apis.createSendFoodOrder}?order_id=$orderId",data: formData);
    return PaymentTaxResponse.fromJson(response.data);
  }

}