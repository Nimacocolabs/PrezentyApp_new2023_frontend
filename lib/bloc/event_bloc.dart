import 'dart:async';

import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/event_gifts_received_model.dart';
import 'package:event_app/models/event_participate_success.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/event_details.dart';
import 'package:event_app/models/get_event_based_gifts_model.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/models/my_wishes_response.dart';
import 'package:event_app/models/participant_response.dart';
import 'package:event_app/models/pick_music_response.dart';
import 'package:event_app/models/received_payments_response.dart';
import 'package:event_app/models/user_event_summary_model.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/event_repository.dart';
import 'package:event_app/repositories/participant_repository.dart';
import 'package:event_app/screens/EventDeeplink/event_invite_details_screen.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/chat_data.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/string_constants.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class EventBloc{

  bool isLoading=false;
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  late EventRepository _repository;
  LoadMoreListener? _listener;
  List<EventItem> eventList = [];
  List<EventItem> inviteList = [];
  List<MyWishListItem> myWishList = [];
  List<ListItem> pickMusicList = [];


  StreamController<ApiResponse<dynamic>>? _receivedPaymentsController;
  StreamSink<ApiResponse<dynamic>>? get _receivedPaymentsSink => _receivedPaymentsController!.sink;
  Stream<ApiResponse<dynamic>> get receivedPaymentsStream => _receivedPaymentsController!.stream;

  StreamController<ApiResponse<dynamic>>? _eventDetailController;
  StreamSink<ApiResponse<dynamic>>? get _eventDetailSink => _eventDetailController!.sink;
  Stream<ApiResponse<dynamic>> get eventDetailStream => _eventDetailController!.stream;

  StreamController<ApiResponse<dynamic>>? _eventListController;
  StreamSink<ApiResponse<dynamic>>? get _eventListSink => _eventListController!.sink;
  Stream<ApiResponse<dynamic>> get eventListStream => _eventListController!.stream;

  late StreamController<ApiResponse<MyWishesResponse>> _myWishController;
  StreamSink<ApiResponse<MyWishesResponse>>? get _myWishSink => _myWishController.sink;
  Stream<ApiResponse<MyWishesResponse>> get myWishStream => _myWishController.stream;

  late StreamController<ApiResponse<PickMusicResponse>> _pickMusicListController;
  StreamSink<ApiResponse<PickMusicResponse>>? get _pickMusicListSink => _pickMusicListController.sink;
  Stream<ApiResponse<PickMusicResponse>> get pickMusicListStream => _pickMusicListController.stream;

   

    late StreamController<ApiResponse<GetEventBasedGiftModel>> _eventBasedGiftController;
  StreamSink<ApiResponse<GetEventBasedGiftModel>>? get _eventBasedGiftSink => _eventBasedGiftController.sink;
  Stream<ApiResponse<GetEventBasedGiftModel>> get eventBasedGiftStream => _eventBasedGiftController.stream;

   late StreamController<ApiResponse<EventGiftsReceivedModel>> _eventGiftsReceivedController;
  StreamSink<ApiResponse<EventGiftsReceivedModel>>? get _eventGiftsReceivedSink => _eventGiftsReceivedController.sink;
  Stream<ApiResponse<EventGiftsReceivedModel>> get eventGiftsReceivedStream => _eventGiftsReceivedController.stream;



  EventBloc([this._listener]){
     _repository = EventRepository();
    _receivedPaymentsController = StreamController<ApiResponse<dynamic>>();
     _eventDetailController = StreamController<ApiResponse<dynamic>>();
     _eventListController = StreamController<ApiResponse<dynamic>>();
     _myWishController = StreamController<ApiResponse<MyWishesResponse>>();
     _pickMusicListController = StreamController<ApiResponse<PickMusicResponse>>();
      _eventBasedGiftController = StreamController<ApiResponse<GetEventBasedGiftModel>>();
      _eventGiftsReceivedController = StreamController<ApiResponse<EventGiftsReceivedModel>>();
  }

  // Future<CreateEventResponse> createEvent(FormData body) async {
  //   try {
  //     return await _repository!.createEvent(body);
  //   }catch (e, s) {
  //     Completer().completeError(e, s);
  //     throw e;
  //   }
  // }

  Future<CommonResponse> updateEvent(Map<String,dynamic> body) async {
    try {
      return await _repository.updateEvent(body);
    }catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<CommonResponse> deleteEvent(int id) async {
    try {
      return await _repository.deleteEvent(id);
    }catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  getInviteEventDetail (int id, String email) async {
      _eventDetailSink!.add(ApiResponse.loading('Fetching detail info'));

      try {
        EventDetailsResponse response = await _repository.getEventDetails(id,email);
        if (response.success == true) {

          if(User.apiToken.isNotEmpty && '${response.detail!.userId}'==User.userId){
            Get.offAll(()=>MainScreen());
            Get.to(()=>MyEventScreen(eventId: id));
            return;
          }else {
            _eventDetailSink!.add(ApiResponse.completed(response));
          }
        } else {
          _eventDetailSink!.add(ApiResponse.error(response.message??"Something went wrong"));
        }
      } catch (error) {
        _eventDetailSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    }

  getMyEventDetail(int id, String email,{bool reloadParticipants = false}) async {
    try {
      _eventDetailSink!.add(ApiResponse.loading('Fetching info'));
      EventDetailsResponse response = await _repository.getEventDetails(id,email);
      if (response.success == true) {
        List<ParticipantListItem>? list = await _getParticipants(id);
       if(list != null){
         response.participantList = list;
          _eventDetailSink!.add(ApiResponse.completed(response));
        } else {
          _eventDetailSink!.add(ApiResponse.error("Something went wrong"));
         }
      } else {
        _eventDetailSink!.add(ApiResponse.error(response.message??"Something went wrong"));
      }
    }catch (e, s) {
      Completer().completeError(e, s);
      _eventDetailSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  Future<List<ParticipantListItem>?> _getParticipants(int id)async {
     try {
      List<ParticipantListItem> participantList = [];
      ParticipantResponse response1 = await ParticipantRepository() .getParticipantList(id, 0, 100, ChatData.chatUserEmail);
      if(response1.success??false) {

        String hostName = response1.name ?? '';
        String hostEmail = response1.email ?? '';
        bool showHost = (User.userEmail != hostEmail ||
            (ChatData.chatUserEmail.isNotEmpty &&
                ChatData.chatUserEmail != hostEmail));
        if (showHost) {
          participantList.insert(0, ParticipantListItem(
              name: hostName, email: hostEmail, eventId: id));
        }
        response1.list!.forEach((element) {
          if (element.email != User.userEmail &&
              element.email != ChatData.chatUserEmail) {
            participantList.add(element);
          }
        });
        return participantList;
      }

     } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }

  Future<void> sendGoLiveNotification(int id) async {
    try {
      await _repository.sendGoLiveNotification(id);
    }catch (e, s) {
      Completer().completeError(e, s);
    }
  }

  getReceivedPayments(int eventId) async {
    try {
      _receivedPaymentsSink!.add(ApiResponse.loading('Fetching items'));
      ReceivedPaymentsResponse response = await _repository.getReceivedPayments(eventId);

      if(response.success??false){
        _receivedPaymentsSink!.add(ApiResponse.completed(response));
      }else{
        _receivedPaymentsSink!.add(ApiResponse.error(response.message));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
       _receivedPaymentsSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }

  participateEvent(Map<String, dynamic> body,bool isFromDynamicLink) async {
    try {
      AppDialogs.loading();
      EventParticipateSuccess response = await _repository.participateEvent(body);
      Get.back();

      if (response.success == true) {
        if(User.apiToken.isEmpty){
          await SharedPrefs.setString(SharedPrefs.spGuestUserEmail, body['email']);
        }

        ChatData.chatUserEmail = body["email"];

        toastMessage( response.message ?? "Successfully processed your request");

        Get.offAll(()=>EventInviteDetailsScreen(eventId: body["event_id"],isFromDynamicLink: isFromDynamicLink,));
        // Get.back(result: true);
      } else {
        toastMessage(response.message ?? StringConstants.apiFailureMsg);
      }
    } catch (e,s) {
      Get.back();
      Completer().completeError(e,s);
      toastMessage( ApiErrorMessage.getNetworkError(e));
    }
  }

  addRemoveFavourite(int? eventId) async {
    try {
      CommonResponse commonResponse =
      await _repository.addOrRemoveFavourite(eventId);
      return commonResponse;
    } catch (error) {
      throw ApiErrorMessage.getNetworkError(error);
    }
  }

  getFavouriteEventList(bool isPagination) async {
    if (isPagination) {
      _listener!.refresh(true);
    } else {
      pageNumber=0;
      _eventListSink!.add(ApiResponse.loading('Fetching items'));
    }
    try {
      HomeEventsResponse response = await _repository
          .getFavouriteEventList(pageNumber, perPage);

      hasNextPage = response.hasNextPage!;
      pageNumber = response.page!;
      if (isPagination) {
        if (eventList.length == 0) {
          eventList = response.list!;
        } else {
          eventList.addAll(response.list!);
        }
      } else {
        eventList = response.list!;
      }
      _eventListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener!.refresh(false);
      }
    } catch (error,s) {
      Completer().completeError(error,s);
      if (isPagination) {
        _listener!.refresh(false);
      } else {
        _eventListSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    }
  }

  getHomeList(bool isPagination, [String keyword='',int isUpcoming=0]) async {
    if(isLoading) return;

    isLoading = true;
    if (isPagination) {
      _listener!.refresh(true);
    } else {
      pageNumber=0;
      _eventListSink!.add(ApiResponse.loading('Fetching items'));
    }

    try {
      HomeEventsResponse response = await _repository .getHomeList( pageNumber, keyword, isUpcoming);

      hasNextPage = response.hasNextPage??false;
      pageNumber = response.page??1;
      if(response.success??false){
        if (isPagination) {
          if (eventList.isEmpty) {
            eventList = response.eventList;
          } else {
            eventList.addAll(response.eventList);
          }

          if (inviteList.isEmpty) {
            inviteList = response.inviteList;
          } else {
            inviteList.addAll(response.inviteList);
          }
        } else {
          eventList = response.eventList;
          inviteList = response.inviteList;
        }
        _eventListSink!.add(ApiResponse.completed(response));
      }else{
        _eventListSink!.add(ApiResponse.error(response.message));
      }

    } catch (e, s) {
      Completer().completeError(e, s);
      _eventListSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }finally{
      isLoading = false;
    }
  }

  getMyEventList(bool isPagination) async {
    if(isLoading) return;

    isLoading = true;
    if (isPagination) {
      _listener!.refresh(true);
    } else {
      pageNumber=0;
      _eventListSink!.add(ApiResponse.loading('Fetching items'));
    }
    try {
      HomeEventsResponse response = await _repository
          .getMyEventList(pageNumber, perPage);

      hasNextPage = response.hasNextPage!;
      pageNumber = response.page!;
      if (isPagination) {
        if (eventList.length == 0) {
          eventList = response.list??[];
        } else {
          eventList.addAll(response.list??[]);
        }
      } else {
        eventList = response.list??[];
      }
      _eventListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener!.refresh(false);
      }
    } catch (error,s) {
      Completer().completeError(error,s);
      if (isPagination) {
        _listener!.refresh(false);
      } else {
        _eventListSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    }finally{
      isLoading = false;
    }
  }

  getMyWishList(bool isPagination, int? eventId) async {
    if (isPagination) {
      _listener!.refresh(true);
    } else {
      pageNumber=0;
      _myWishSink!.add(ApiResponse.loading('Fetching items'));
    }
    try {
      MyWishesResponse response = await _repository
          .getMyWishList(eventId, pageNumber, perPage);

      hasNextPage = response.hasNextPage!;
      pageNumber = response.page!;
      if (isPagination) {
        if (myWishList.length == 0) {
          myWishList = response.list!;
        } else {
          myWishList.addAll(response.list!);
        }
      } else {
        myWishList = response.list!;
      }
      _myWishSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener!.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener!.refresh(false);
      } else {
        _myWishSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    }
  }

  Future<CommonResponse> sendVideo(dio.FormData body) async {
    try {
      return await _repository.sendVideo(body);
    }catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }


  Future<bool> sendFeedbackMessage(String userId, String name,String email,String phone, String message) async {
    try {
      AppDialogs.loading();
      CommonResponse response = await _repository.sendFeedbackMessage(userId, {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "message":message
      });
      Get.back();

      toastMessage(response.message??'Something went wrong');
      if(response.success??false){
        return true;
      }


    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return false;
  }


  getPickMusicList(bool isPagination) async {
    if(isLoading) return;

    isLoading = true;
    if (isPagination) {
      _listener!.refresh(true);
    } else {
      pageNumber=0;
      _pickMusicListSink!.add(ApiResponse.loading('Fetching items'));
    }
    try {
      PickMusicResponse response = await _repository
          .getPickMusicList(pageNumber, perPage);

      hasNextPage = response.hasNextPage!;
      pageNumber = response.page!;
      if (isPagination) {
        if (pickMusicList.length == 0) {
          pickMusicList = response.list!;
        } else {
          pickMusicList.addAll(response.list!);
        }
      } else {
        pickMusicList = response.list!;
      }
      _pickMusicListSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener!.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener!.refresh(false);
      } else {
        _pickMusicListSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    }finally{
      isLoading = false;
    }
  }

getUserEventSummary(
String accountId
  ) async {
    try {
      AppDialogs.loading();
      final response = await _repository.getUserEventSummary(
          accountId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
  }

getEventBasedGift({int?  eventId}) async {
    try {
      _eventBasedGiftSink!.add(ApiResponse.loading('Fetching items'));
      
      GetEventBasedGiftModel response = await _repository.getEventBasedGift(eventId!);
      if(response.success??false){
        _eventBasedGiftSink!.add(ApiResponse.completed(response));
      }else{
        _eventBasedGiftSink!.add(ApiResponse.error(response.message));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
       _eventBasedGiftSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }


  eventGiftsReceived(int eventId) async {
    try {
      _eventGiftsReceivedSink!.add(ApiResponse.loading('Fetching items'));
      EventGiftsReceivedModel response = await _repository.eventGiftsReceived(eventId);

      if(response.success??false){
        _eventGiftsReceivedSink!.add(ApiResponse.completed(response));
      }else{
        _eventGiftsReceivedSink!.add(ApiResponse.error(response.message));
      }
    } catch (e, s) {
      Completer().completeError(e, s);
       _eventGiftsReceivedSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(e)));
    }
  }
  dispose() {

    _pickMusicListSink?.close();
    _pickMusicListController.close();

    _eventListSink?.close();
    _eventListController?.close();

    _receivedPaymentsSink?.close();
    _receivedPaymentsController?.close();

    _eventDetailSink?.close();
    _eventDetailController?.close();

    _myWishSink?.close();
    _myWishController.close();

   
    _eventBasedGiftSink?.close();
    _eventBasedGiftController.close();

    _eventGiftsReceivedSink?.close();
    _eventGiftsReceivedController.close();
  }

}