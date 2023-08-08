import 'dart:async';
import 'dart:convert';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/models/send_food_participant_list_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/send_food_voucher_repository.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:get/get.dart';

class SendFoodVoucherBloc {
  late SendFoodVoucherRepository _repository;

  late StreamController<ApiResponse<SendFoodParticipantListResponse>> _participantListController;
  StreamSink<ApiResponse<SendFoodParticipantListResponse>> get _participantListSink => _participantListController.sink;
  Stream<ApiResponse<SendFoodParticipantListResponse>> get participantListStream => _participantListController.stream;

  List<Participant> participantsList = [];

  SendFoodVoucherBloc() {
    _repository = SendFoodVoucherRepository();
    _participantListController = StreamController<ApiResponse<SendFoodParticipantListResponse>>();
  }

  getParticipantList(int eventId) async {
   try {
     _participantListSink.add(ApiResponse.loading('Fetching'));

     SendFoodParticipantListResponse response = await _repository
          .getAllEventParticipants(eventId);
     if(response.success??false){
       participantsList = response.list!;

       _participantListSink.add(ApiResponse.completed(response));
     }else{
       _participantListSink.add(ApiResponse.error(response.message??'Something went wrong'));
     }
    } catch (error) {
        _participantListSink
            .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
    }
  }

  Future<PaymentTaxResponse?> createFoodOrder(String orderId, int eventId, int voucherId,
      List<Participant> list,int denomination) async {
   try {

    Map<String,dynamic> map ={
      'EventOrder[event_id]':eventId,
      'EventOrder[type]':1,
      'woohoo_id':voucherId,
      'amount':denomination
    };

    list.forEach((element) {
      map['EventParticipant[${element.id}][order_members_count]'] = element.count;
    });

    print(jsonEncode(map));
    AppDialogs.loading();

    PaymentTaxResponse response = await _repository.createOrder(orderId, map );
    Get.back();
     if(response.success??false){
       return response;
     }else{
       toastMessage(
           response.message??'Something went wrong');
     }
    } catch (e,s) {
       Get.back();
       Completer().completeError(e,s);
       toastMessage(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
    return null;
  }

  dispose() {
    _participantListSink.close();
    _participantListController.close();
  }
}
