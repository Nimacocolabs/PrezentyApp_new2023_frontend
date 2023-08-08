import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/participant_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/participant_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/common_widgets.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/PainationLoader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat_screen.dart';

class ParticipantsScreen extends StatefulWidget {
  final int eventId;
  final bool isHost;

  const ParticipantsScreen(
      {Key? key, required this.eventId, required this.isHost})
      : super(key: key);

  @override
  _ParticipantsScreenState createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen>
    with LoadMoreListener {
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  late ParticipantBloc _participantBloc = ParticipantBloc();

  @override
  void initState() {
    super.initState();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _participantBloc = ParticipantBloc(this);
    _participantBloc.getParticipantList(false, widget.eventId);
  }

  @override
  void dispose() {
    _itemsScrollController.dispose();
    _participantBloc.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_participantBloc.hasNextPage) {
        _participantBloc.getParticipantList(true, widget.eventId);
      }
    }
    if (_itemsScrollController.offset <=
            _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the top");
    }
  }

  void _errorWidgetFunction() {
    if (_participantBloc != null)
      _participantBloc.getParticipantList(true, widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.green,
        onRefresh: () {
          return _participantBloc.getParticipantList(false, widget.eventId);
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: StreamBuilder<ApiResponse<dynamic>>(
                  stream: _participantBloc.participantListStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CommonApiLoader();
                    } else if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return CommonApiLoader();
                        case Status.COMPLETED:
                          return _participantBloc.itemsList != null &&
                                  _participantBloc.itemsList.length > 0
                              ? ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: _participantBloc.itemsList.length,
                                  itemBuilder: (context, index) {
                                    return _buildParticipantsList(
                                        _participantBloc.itemsList[index]);
                                  })
                              : SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: CommonApiResultsEmptyWidget(
                                      "Results Empty",
                                      textColorReceived: Colors.black),
                                ); //_buildUsersList(_participantBloc.itemsList);
                        case Status.ERROR:
                          return CommonApiErrorWidget(
                              snapshot.data!.message!, _errorWidgetFunction,
                              textColorReceived: Colors.black);
                      }
                    }
                    return Container(
                      child: Center(
                        child: Text(""),
                      ),
                    );
                  }),
            ),
            Visibility(
              child: PaginationLoader(),
              visible: isLoadingMore ? true : false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
    }
  }

  Widget _buildParticipantsList(ParticipantListItem itemsList) {
    return InkWell(
      onTap: () async {
        if ((itemsList.email ?? '').isEmpty) {
          toastMessage('Email of this user is not available');
          return;
        }

        bool? b = await Get.to(() => ChatScreen(
            eventId: widget.eventId,
            opponentEmail: itemsList.email!,
            displayName: itemsList.name,
            isBlocked: itemsList.isBlocked ?? false,
            hideBlock:
                (itemsList.id == null) || (itemsList.email ?? '').isEmpty));
        if (b ?? false) {
          _participantBloc.getParticipantList(false, widget.eventId);
        }
      },
      child: Card(
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${itemsList.email}',
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/ic_person_avatar.png'),
                    ),
                  ),
                ),
              ),
              VerticalDivider(),
              Text(
                '${itemsList.name ?? '---'}${itemsList.id == null ? '(Host)' : ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              if (widget.isHost)
                Container(
                  // top: 0,
                  // right: 0,
                  child: itemsList.id == null
                      ? SizedBox()
                      : IconButton(
                          iconSize: 28,
                          onPressed: () {
                            String nameToShow = itemsList.name ?? "N/A";
                            String emailToShow = itemsList.email ?? "N/A";
                            String phoneToShow = itemsList.phone ?? "N/A";
                            String addressToShow = itemsList.address ?? "N/A";
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
        ),
      ),
    );
  }

// Widget _buildUsersList(List<ParticipantListItem> itemsList) {
//   if (itemsList != null) {
//     if (itemsList.length > 0) {
//       return GridView.builder(
//         controller: _itemsScrollController,
//         shrinkWrap: true,
//         physics: const AlwaysScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
//         ),
//         itemCount: itemsList.length,
//         itemBuilder: (context, index) {
//           return Card(
//             color: itemsList[index].id == null
//                 ? primaryColor.shade100
//                 : Colors.white,
//             margin: EdgeInsets.all(8),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8)),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: InkWell(
//                 child: Stack(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               alignment: FractionalOffset.center,
//                               width: 100,
//                               height: double.infinity,
//                               child: SizedBox(
//                                 width: 100,
//                                 height: 100,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(100),
//                                   child: CachedNetworkImage(
//                                     fit: BoxFit.fill,
//                                     imageUrl:
//                                         'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${itemsList[index].email}',
//                                     placeholder: (context, url) => Center(
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                     errorWidget: (context, url, error) =>
//                                         Image.asset(
//                                             'assets/images/ic_person_avatar.png'),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Container(
//                             padding: EdgeInsets.fromLTRB(3, 5, 3, 8),
//                             alignment: FractionalOffset.center,
//                             child: Text(
//                               '${itemsList[index].name ?? '---'}${itemsList[index].id == null ? '(Host)' : ''}',
//                               maxLines: 1,
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (widget.isHost)
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: itemsList[index].id == null
//                             ? SizedBox()
//                             : IconButton(
//                                 iconSize: 28,
//                                 onPressed: () {
//                                   String nameToShow =
//                                       itemsList[index].name ?? "N/A";
//                                   String emailToShow =
//                                       itemsList[index].email ?? "N/A";
//                                   String phoneToShow =
//                                       itemsList[index].phone ?? "N/A";
//                                   String addressToShow =
//                                       itemsList[index].address ?? "N/A";
//                                   CommonWidgets().showPersonInfoDialog(
//                                       name: nameToShow,
//                                       email: emailToShow,
//                                       phone: phoneToShow,
//                                       address: addressToShow);
//                                 },
//                                 icon: Icon(
//                                   Icons.info,
//                                   color: secondaryColor.shade400,
//                                 ),
//                               ),
//                       ),
//                   ],
//                 ),
//                 onTap: () async {
//                   if ((itemsList[index].email ?? '').isEmpty) {
//                     toastMessage('Email of this user is not available');
//                     return;
//                   }
//
//                   bool? b = await Get.to(() => ChatScreen(
//                       eventId: widget.eventId,
//                       opponentEmail: itemsList[index].email!,
//                       displayName: itemsList[index].name,
//                       isBlocked: itemsList[index].isBlocked ?? false,
//                       hideBlock: (itemsList[index].id == null) ||
//                           (itemsList[index].email ?? '').isEmpty));
//                   if (b ?? false) {
//                     _participantBloc.getParticipantList(
//                         false, widget.eventId);
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       );
//     } else {
//       return SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: CommonApiResultsEmptyWidget("Results Empty",
//             textColorReceived: Colors.black),
//       );
//     }
//   } else {
//     return CommonApiErrorWidget("No results found", _errorWidgetFunction,
//         textColorReceived: Colors.black);
//   }
// }
}
