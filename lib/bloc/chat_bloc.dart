import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/personal_chat_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/repositories/chat_repository.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/chat_data.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:get/get.dart';

class ChatBloc{
  bool isLoading=false;
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  late ChatRepository _repository;
  late StreamController<dynamic> _itemsController;

  StreamSink<dynamic>? get itemsSink => _itemsController.sink;
  Stream<dynamic> get itemsStream => _itemsController.stream;

  late StreamController<bool> _isPreviousLoadingController;
  StreamSink<bool>? get _isPreviousLoadingSink => _isPreviousLoadingController.sink;
  Stream<bool> get isPreviousLoadingStream => _isPreviousLoadingController.stream;

  late StreamController<bool> _isSendingLoadingController;
  StreamSink<bool>? get _isSendingLoadingSink => _isSendingLoadingController.sink;
  Stream<bool> get isSendingLoadingStream => _isSendingLoadingController.stream;

  TextFieldControl textFieldControl =TextFieldControl();

  ChatBloc() {
    _repository = ChatRepository();
    _itemsController = StreamController<dynamic>();
    _isPreviousLoadingController = StreamController<bool>();
    _isSendingLoadingController = StreamController<bool>();
  }

  _setPreviousLoading(bool b){
    isLoading=b;
    _isPreviousLoadingSink!.add(isLoading);
  }

  getList(String? senderEmail) async {
if(isLoading) return;

_setPreviousLoading(true);
    try {
      itemsSink!.add(ApiResponse.loading('loading previous messages'));
      ChatMessageListResponse response = await _repository
          .getPreviousMessages(pageNumber, ChatData.eventId,senderEmail);

      hasNextPage = response.hasNextPage??false;
      pageNumber = response.page!;

      if(response.success??false) {
        (response.list ?? []).forEach((element) {
          ChatData.chatMessageList.add(element);
        });
      }

      itemsSink!.add(ApiResponse.completed(response));

    } catch (error,s) {
      Completer().completeError(error,s);
      toastMessage(ApiErrorMessage.getNetworkError(error));
      itemsSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
    }finally{
      _setPreviousLoading(false);
    }
  }

  getMessages(String? senderEmail) async {
    if(isLoading) return;

    try {
      ChatMessageListResponse response = await _repository
          .getPreviousMessages(0, ChatData.eventId,senderEmail);

      if(response.success??false) {

        List list =[];

        for (int i = 0; i < (response.list??[]).length; i++) {
          list.add( response.list![i]);
        }

        list.forEach((element) {
          bool b = ChatData.chatMessageList.any((element1) => element.id==element1.id);
          if (!b&&element.senderEmail!=ChatData.chatUserEmail) ChatData.chatMessageList.insert(0,element);
        });
      }

      itemsSink!.add(ApiResponse.completed(response));

    } catch (error,s) {
      Completer().completeError(error,s);
      toastMessage(ApiErrorMessage.getNetworkError(error));
      itemsSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
    }
  }

  sendMessage(var message,String? receiverEmail) async {

    _isSendingLoadingSink!.add(true);
    try {
      DateTime dt = DateTime.now();
      log(dt.toString());
      Map<String,dynamic> map = {
        'message': message,
        'event_id': ChatData.eventId,
        'sender_email': ChatData.chatUserEmail,
        'date': DateHelper.formatDateTime(dt, 'yyyy-MM-dd'),
        'time': DateHelper.formatDateTime(dt, 'HH:mm'),
      };
      if(receiverEmail!=null){
        map.addAll({'receiver_email': receiverEmail});
      }

      log(jsonEncode(map));

      CommonResponse response = await _repository
          .sendMessage(map);

      if(response.success??false) {
        textFieldControl.controller.text='';
        ChatData.chatMessageList.insert(0, ChatMessage.fromJson(map));
        itemsSink!.add(true);
      }else{
        toastMessage(response.message??'Unable to send message');
      }

    } catch (error,s) {
      Completer().completeError(error,s);
      toastMessage(ApiErrorMessage.getNetworkError(error));
    }finally{
      _isSendingLoadingSink!.add(false);
    }
  }

  Future<bool> block(int eventId, String blockedByUserEmail, String blockUserEmail) async {
    AppDialogs.loading();
    try{
      Map<String,dynamic> map = {
        'event_id': eventId,
        'blocked_user_email':'$blockUserEmail',
        'blocked_by_user_email':'$blockedByUserEmail',
      };
      CommonResponse response = await _repository
          .blockUser(map);

      toastMessage(response.message??'Unable to read response message');
      if(response.success??false){
        return true;
      }
    }catch(e,s){
      Completer().completeError(e,s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }finally{
      Get.back();
    }
    return false;
  }

  Future<bool> unBlock(int eventId, String blockedByUserEmail, String blockUserEmail) async {
    AppDialogs.loading();
    try{
      Map<String,dynamic> map = {
        'event_id': eventId,
        'blocked_user_email':'$blockUserEmail',
        'blocked_by_user_email':'$blockedByUserEmail',
      };
      CommonResponse response = await _repository
          .unBlockUser(map);

      toastMessage(response.message??'Unable to read response message');
      if(response.success??false){
        return true;
      }
    }catch(e,s){
      Completer().completeError(e,s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }finally{
      Get.back();
    }
    return false;
  }

  dispose() {
    _isPreviousLoadingSink?.close();
    _isPreviousLoadingController.close();

    _isSendingLoadingSink?.close();
    _isSendingLoadingController.close();

    itemsSink?.close();
    _itemsController.close();
  }

}
