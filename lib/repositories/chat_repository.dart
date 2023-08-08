import 'package:dio/dio.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/personal_chat_message.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/util/chat_data.dart';

class ChatRepository{
  late ApiProvider apiClient;

  ChatRepository (){
    apiClient =ApiProvider();
  }

  Future<ChatMessageListResponse> getPreviousMessages(int pageNumber, int eventId,String? senderMail) async {
   String path;
   if(senderMail==null){
     path = '${Apis.getGroupChatMessages}?event_id=$eventId&page=${pageNumber+1}&per_page=20';
   }else{
     path = '${Apis.getPersonalChatMessages}?receiver_email=${ChatData.chatUserEmail}&event_id=$eventId&sender_email=$senderMail&page=${pageNumber + 1}&per_page=20';
   }

    Response response = await apiClient
        .getJsonInstance()
        .post(path);
    return ChatMessageListResponse.fromJson(response.data);
  }
  Future<CommonResponse> sendMessage(Map<String,dynamic> map) async {
    FormData data=FormData.fromMap(map);
    Response response = await apiClient
        .getMultipartInstance()
        .post(Apis.sendChatMessages,data: data);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> blockUser(Map<String,dynamic> map) async {
    FormData data=FormData.fromMap(map);
    Response response = await apiClient
        .getMultipartInstance()
        .post(Apis.blockUser,data: data);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> unBlockUser(Map<String,dynamic> map) async {
    FormData data=FormData.fromMap(map);
    Response response = await apiClient
        .getMultipartInstance()
        .post(Apis.unBlockUser,data: data);
    return CommonResponse.fromJson(response.data);
  }

}