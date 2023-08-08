import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/models/event_gifts_received_model.dart';
import 'package:event_app/models/event_participate_success.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/create_event_response.dart';
import 'package:event_app/models/get_event_based_gifts_model.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/models/my_wishes_response.dart';
import 'package:event_app/models/pick_music_response.dart';
import 'package:event_app/models/received_payments_response.dart';
import 'package:event_app/models/event_details.dart';
import 'package:event_app/models/user_event_summary_model.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';

class EventRepository{
  late ApiProvider apiProvider;
   late ApiProviderPrepaidCards apiPPCardProvider;

  EventRepository(){
    apiProvider = ApiProvider();
     apiPPCardProvider = new ApiProviderPrepaidCards();
  }

  Future<CreateEventResponse> createEvent(FormData body) async {
    final response = await apiProvider.getMultipartInstance().post('${Apis.createEvent}',data: body);
    return CreateEventResponse.fromJson(response.data);
  }

  Future<CommonResponse> updateEvent(Map<String,dynamic> body) async {
    FormData formData = FormData.fromMap(body);
    final response = await apiProvider.getMultipartInstance().post('${Apis.updateEvent}',data: formData);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> deleteEvent(int id) async {
    FormData formData = FormData.fromMap({
      'id': id
    });
    final response = await apiProvider.getMultipartInstance().post('${Apis.deleteEvent}',data: formData);
    return CommonResponse.fromJson(response.data);
  }

  Future<EventDetailsResponse> getEventDetails(int id,String email) async {
    final response = await apiProvider.getJsonInstance().get('${Apis.getEventDetails}?event_id=$id&email=$email',);
    return EventDetailsResponse.fromJson(response.data);
  }

  Future<EventDetailsResponse> getParticipants(int id) async {
    final response = await apiProvider.getJsonInstance().get('${Apis.getParticipants}?id=$id&page=1&per_page=20',);
    return EventDetailsResponse.fromJson(response.data);
  }

  Future<void> sendGoLiveNotification(int eventId) async {
    FormData data = FormData.fromMap({'event_id':'$eventId'});
    await apiProvider.getMultipartInstance().post('${Apis.sendGoLiveNotification}',data: data);
  }



  Future<ReceivedPaymentsResponse> getReceivedPayments(int eventId) async {
    Response response = await apiProvider.getJsonInstance().get('${Apis.getReceivedPayments}?event_id=$eventId');
    return ReceivedPaymentsResponse.fromJson(response.data);
  }

  Future<EventParticipateSuccess> participateEvent(Map<String,dynamic> body) async {
    final response = await apiProvider
        .getJsonInstance()
        .post(Apis.postJointEvent, data: body);
    return EventParticipateSuccess.fromJson(response.data);
  }

  Future<CommonResponse> addOrRemoveFavourite(int? eventId) async {
    FormData formData = FormData.fromMap({
      'event_id':eventId
    });
    final response = await apiProvider.getMultipartInstance().post('${Apis.addFavourite}',data: formData);
    return CommonResponse.fromJson(response.data);
  }

  Future<HomeEventsResponse> getFavouriteEventList(int pageNumber, int perPage) async {
    final response = await apiProvider.getJsonInstance().get('${Apis.getFavouriteList}');
    return HomeEventsResponse.fromJson(response.data);
  }

  Future<HomeEventsResponse> getHomeList(int page, String keyword,int isUpcoming) async {
    final response = await apiProvider.getJsonInstance().get('${Apis.geHomeEventList}?keyword=$keyword&is_upcomming=$isUpcoming&page=${page+1}');
    return HomeEventsResponse.fromJson(response.data);
  }

  Future<HomeEventsResponse> getMyEventList( int pageNumber, int perPage) async {
    final response = await apiProvider.getJsonInstance().get('${Apis.getMyEventsList}?keyword=&is_upcomming=');////page=${pageNumber + 1}&per_page=$perPage
    return HomeEventsResponse.fromJson(response.data);
  }

  Future<MyWishesResponse> getMyWishList(int? eventId, int pageNumber, int perPage) async {
    String path;
    if(eventId==null){
      path='${Apis.getMyWishesList}?page=${pageNumber + 1}&per_page=$perPage';
    }else{
      path='${Apis.getMyWishesList}?id=$eventId&page=${pageNumber + 1}&per_page=$perPage';
    }

    final response = await apiProvider.getJsonInstance().get(path);
    return MyWishesResponse.fromJson(response.data);
  }

  Future<CommonResponse> sendVideo(FormData body) async {
    final response = await apiProvider.getMultipartInstance().post('${Apis.sendVideoWish}',data: body);
    return CommonResponse.fromJson(response.data);
  }

  Future<CommonResponse> sendFeedbackMessage(String userId, Map<String,dynamic> map) async {
    final response = await apiProvider.getMultipartInstance().post('${Apis.sendFeedbackMessage}',data: FormData.fromMap(map));
    return CommonResponse.fromJson(response.data);
  }

  Future<PickMusicResponse> getPickMusicList( int pageNumber, int perPage) async {
    final response = await apiProvider.getJsonInstance().get('${Apis.getMusicList}?page=${pageNumber + 1}&per_page=$perPage');
    return PickMusicResponse.fromJson(response.data);
  }
  Future<UserEventSummaryModel> getUserEventSummary(String accountId) async {
    Response response = await apiPPCardProvider.getMultipartInstance().post('${Apis.getUserEventSummary}?account_id=$accountId');
    return UserEventSummaryModel.fromJson(jsonDecode(response.data) );
  }
   Future<GetEventBasedGiftModel> getEventBasedGift(int eventId) async {
    Response response = await apiPPCardProvider.getMultipartInstance().post('${Apis.eventBasedGift}?event_id=$eventId',
     );
    return GetEventBasedGiftModel.fromJson(jsonDecode(response.data) );
  }

   Future<EventGiftsReceivedModel> eventGiftsReceived(int eventId) async {
    Response response = await apiPPCardProvider.getJsonInstance().post('${Apis.eventGiftReceived}?event_id=$eventId');
    return EventGiftsReceivedModel.fromJson(jsonDecode(response.data));
  }


  //////Notification read unread ////////////////////

  Future getNotificationStatus(int? id) async {
    final response = await apiPPCardProvider.getJsonInstance().post('${Apis.notificationread}',data: {"notification_id":id

    });
    print("response->${response}");
    return response.data;
  }

}
