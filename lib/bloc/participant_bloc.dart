import 'dart:async';

import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/blocked_users_response.dart';
import 'package:event_app/models/participant_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/participant_repository.dart';
import 'package:event_app/util/chat_data.dart';
import 'package:event_app/util/user.dart';


class ParticipantBloc  {

  bool isLoading=false;
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  LoadMoreListener? _listener;
  late ParticipantRepository _repository;
  late StreamController<ApiResponse<ParticipantResponse>> _participantListController;
  StreamSink<ApiResponse<ParticipantResponse>>? get _participantListSink => _participantListController.sink;
  Stream<ApiResponse<ParticipantResponse>> get participantListStream => _participantListController.stream;


  late StreamController<ApiResponse<BlockedUsersResponse>> _blockedParticipantController;
  StreamSink<ApiResponse<BlockedUsersResponse>> get _blockedParticipantSink =>
      _blockedParticipantController.sink;
  Stream<ApiResponse<BlockedUsersResponse>> get blockedParticipantStream =>
      _blockedParticipantController.stream;


  List<ParticipantListItem> itemsList = [];

  ParticipantBloc([this._listener]) {
    _repository = ParticipantRepository();
    _participantListController = StreamController<ApiResponse<ParticipantResponse>>.broadcast();
    _blockedParticipantController = StreamController<ApiResponse<BlockedUsersResponse>>();
  }

  getParticipantList(bool isPagination, int eventId) async {
    if(isLoading) return;

    isLoading = true;
    if (isPagination) {
      _listener!.refresh(true);
    } else {
      itemsList =[];
      pageNumber=0;
      _participantListSink!.add(ApiResponse.loading('Fetching items'));
    }
    try {
      ParticipantResponse response = await _repository
          .getParticipantList(eventId, pageNumber, perPage,ChatData.chatUserEmail);

     if(response.success??false){
       hasNextPage = response.hasNextPage!;
       pageNumber = response.page!;
       // if (isPagination) {
         // if (itemsList.length == 0) {
         //   itemsList = response.list!;
         // } else {
         //   itemsList.addAll(response.list!);
         // }
       // } else {
       //   itemsList = response.list!;
       // }
           if(itemsList.isEmpty){
          String hostName = response.name ?? '';
          String hostEmail = response.email ?? '';

          bool showHost = (User.userEmail != hostEmail ||
              (ChatData.chatUserEmail.isNotEmpty &&
                  ChatData.chatUserEmail != hostEmail));
          if (showHost) {
            itemsList.insert(0,
                ParticipantListItem(name: hostName, email: hostEmail, eventId: eventId));
          }
        }

        response.list!.forEach((element) {

         if(element.email!=User.userEmail&&element.email!=ChatData.chatUserEmail){
           itemsList.add(element);
         }
       });

       _participantListSink!.add(ApiResponse.completed(response));
     }else{
       _participantListSink!.add(ApiResponse.error(response.message??'Unable to complete request'));
     }
      if (isPagination) {
        _listener!.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener!.refresh(false);
      } else {
        _participantListSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    }finally{
      isLoading = false;
    }
  }

  getBlockedUsers(int id) async {
    _blockedParticipantSink.add(ApiResponse.loading('Fetching info'));

    try {
      BlockedUsersResponse response =
      await _repository.getBlockedUsersList(id,ChatData.chatUserEmail);
      if (response.success == true) {
        _blockedParticipantSink.add(ApiResponse.completed(response));
      } else {
        _blockedParticipantSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      _blockedParticipantSink.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
    }
  }

  dispose() {
    _participantListSink?.close();
    _participantListController.close();

    _blockedParticipantSink.close();
    _blockedParticipantController.close();
  }

}
