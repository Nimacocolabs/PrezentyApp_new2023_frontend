import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/participant_bloc.dart';
import 'package:event_app/models/blocked_users_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/common_widgets.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat_screen.dart';

class BlockedUsersScreen extends StatefulWidget {
  final int eventId;
  final bool isHost;

  const BlockedUsersScreen({Key? key, required this.eventId, required this.isHost}) : super(key: key);

  @override
  _BlockedUsersScreenState createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  late ParticipantBloc _participantBloc;

  @override
  void initState() {
    super.initState();
    _participantBloc = ParticipantBloc();
    _participantBloc.getBlockedUsers(widget.eventId);
  }

  @override
  void dispose() {
    _participantBloc.dispose();
    super.dispose();
  }

  void _errorWidgetFunction() {
    _participantBloc.getBlockedUsers(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.green,
      onRefresh: () {
        return _participantBloc.getBlockedUsers(widget.eventId);
      },
      child: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: StreamBuilder<ApiResponse<BlockedUsersResponse>>(
            stream: _participantBloc.blockedParticipantStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status!) {
                  case Status.LOADING:
                    return CommonApiLoader();
                  case Status.COMPLETED:
                    return _buildUserWidget(snapshot.data!.data);
                  case Status.ERROR:
                    return CommonApiErrorWidget(
                        snapshot.data!.message!, _errorWidgetFunction);
                }
              }
              return Container(
                child: Center(
                  child: Text(""),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildUserWidget(BlockedUsersResponse? data) {
    if (data?.usersList != null) {
      if (data?.usersList!.length != 0) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          ),
          itemCount: data?.usersList!.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                        child:Container(
                        alignment: FractionalOffset.center,
                          width: 100,
                          height: double.infinity,
                          child: SizedBox(
                            width: 100,
                            height:100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${data!.usersList![index].blockedUserEmail}',
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/images/ic_person_avatar.png'),
                              ),
                            ),
                          ),
                        ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(3, 5, 3, 8),
                              alignment: FractionalOffset.center,
                              child: Text(
                                '${data.usersList![index].participant?.name ?? '---'}${data.usersList![index].participant?.id == null ? '(Host)' : ''}',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(widget.isHost)
                        Positioned(
                        top: 0,
                        right: 0,
                        child: data.usersList![index].participant?.id == null
                            ? SizedBox()
                            : IconButton(
                          iconSize: 28,
                          onPressed: () {
                            String nameToShow = data.usersList![index]
                                .participant?.name ??
                                "N/A";
                            String emailToShow = data.usersList![index]
                                .participant?.email ??
                                "N/A";
                            String phoneToShow = data.usersList![index]
                                .participant?.phone ??
                                "N/A";
                            String addressToShow = data.usersList![index]
                                .participant?.address ??
                                "N/A";
                            CommonWidgets().showPersonInfoDialog(
                                name: nameToShow,
                                email: emailToShow,
                                phone: phoneToShow,
                                address: addressToShow);
                          },
                          icon: Icon(
                            Icons.info,
                            color: secondaryColor.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    if ((data.usersList![index].participant?.email ?? '')
                        .isEmpty) {
                      toastMessage('Email of this user is not available');
                      return;
                    }

                    bool? b = await Get.to(() => ChatScreen(
                        eventId: widget.eventId,
                        opponentEmail: data.usersList![index].blockedUserEmail,
                        displayName: data.usersList![index].participant?.name,isBlocked: true,));

                    if(b??false){
                      _participantBloc.getBlockedUsers(widget.eventId);
                    }

                  },
                ),
              ),
            );
          },
        );
      } else {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: CommonApiResultsEmptyWidget("Results Empty",
              textColorReceived: Colors.black),
        );
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.black);
    }
  }
}
