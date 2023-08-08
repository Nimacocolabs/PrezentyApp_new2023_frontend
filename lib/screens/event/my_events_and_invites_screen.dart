import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/EventDeeplink/event_invite_details_screen.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/util/CustomLoader/LinearLoader.dart';
import 'package:event_app/util/CustomLoader/dot_type.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/common_widgets.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/string_constants.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/event_list_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../see_all_events_screen.dart';

class MyEventsAndInvitesScreen extends StatefulWidget {
  final bool? showAppBar;
  const MyEventsAndInvitesScreen({this.showAppBar});

  @override
  State<MyEventsAndInvitesScreen> createState() => _MyEventsAndInvitesScreenState();
}

class _MyEventsAndInvitesScreenState extends State<MyEventsAndInvitesScreen> {
  EventBloc _eventBloc = EventBloc();
 TextEditingController _textFieldControlSearch = TextEditingController();

 List<EventItem> searchEventsList = [];
  List<EventItem> eventsList = [];
  List<EventItem> invitesList = [];
  int eventsTabIndex = 0;
  int invitesTabIndex = 0;
  var searchText = '';
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventBloc = EventBloc();
      _eventBloc.getHomeList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ?? false ?
       CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ): null,
      //bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SingleChildScrollView(child: Column(
         mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: screenWidth,
            child: StreamBuilder<ApiResponse<dynamic>>(
        stream: _eventBloc.eventListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data?.status != null) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Center(
                    child: LinearLoader(
                      dotOneColor: Colors.red,
                      dotTwoColor: Colors.orange,
                      dotThreeColor: Colors.green,
                      dotType: DotType.circle,
                      dotIcon: Icon(Icons.adjust),
                      duration: Duration(seconds: 1),
                    ),
                  ),
                );
              case Status.COMPLETED:
                HomeEventsResponse resp = snapshot.data?.data;
                if (_textFieldControlSearch.text.isNotEmpty) {
                  return _buildSearchList(
                      resp.imageFilesLocation ?? "", resp.videoFileUrl ?? '');
                } else {
                  return _buildList(
                      resp.imageFilesLocation ?? '', resp.videoFileUrl ?? '');
                }
              case Status.ERROR:
                return CommonApiResultsEmptyWidget(
                    "${snapshot.data?.message ?? ""}",
                    textColorReceived: Colors.black);
              default:
                print("");
            }
          }
          return Container();
        }) ,
          )
      
      ],)),
    );
  }
  


  Widget _buildList(String imageBaseUrl, String videoBaseUrl) {
    if (eventsTabIndex == 0) {
      eventsList = [];
      DateTime now = DateTime.now();
      _eventBloc.eventList.forEach((element) {
        DateTime dt = DateHelper.getDateTime('${element.date} ${element.time}');
        if (dt.isAfter(now)) {
          eventsList.add(element);
        }
      });
    } else {
      eventsList = _eventBloc.eventList;
    }

    if (invitesTabIndex == 0) {
      invitesList = [];
      DateTime now = DateTime.now();
      _eventBloc.inviteList.forEach((element) {
        DateTime dt = DateHelper.getDateTime('${element.date} ${element.time}');
        if (dt.isAfter(now)) {
          invitesList.add(element);
        }
      });
    } else {
      invitesList = _eventBloc.inviteList;
    }

    eventsList = eventsList.reversed.toList();
    invitesList = invitesList.reversed.toList();
    return ListView(
      physics: ScrollPhysics(),
      padding: EdgeInsets.only(top: 5,bottom: 120),
 shrinkWrap: true,
      children: [
// my events list
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: eventsTabIndex == 0
              ? Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            child: Text('Upcoming Events'))),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              setState(() {
                                eventsTabIndex = 1;
                               
                              });
                            },
                            child: Text(
                              'My Events',
                              style: TextStyle(color: Colors.black),
                            ))),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              setState(() {
                                eventsTabIndex = 0;
                              });
                            },
                            child: Text(
                              'Upcoming Events',
                              style: TextStyle(color: Colors.black),
                            ))),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            child: Text('My Events'))),
                  ],
                ),
        ),
        eventsList.isEmpty
            ? CommonApiResultsEmptyWidget("No Events to show",
                textColorReceived: Colors.black)
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventsList.length > 2 ? 2 : eventsList.length,
                //eventsList.length > 6 ? 2 : eventsList.length,
                itemBuilder: (context, index) {
                  return EventListItem(
                      imageBaseUrl: imageBaseUrl,
                      videoBaseUrl: videoBaseUrl,
                      onTap: () async {
                        bool? b = await Get.to(() => MyEventScreen(
                              eventId: eventsList[index].id ?? 0,
                            ));
                        if (b ?? false) {
                          _eventBloc.getHomeList(false);
                        }
                      },
                      eventItem: eventsList[index],
                      onFavClick: () {
                        addOrRemoveFromFavourites(eventsList[index].id ?? 0);
                      });
                }),
        Visibility(
          visible: eventsList.isNotEmpty,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () async {
                final isToRefreshList = await Get.to(() => SeeAllEventsScreen(
                    isUpcoming: (eventsTabIndex == 0), isMyEvents: true));
                if (isToRefreshList != null) {
                  _eventBloc.getHomeList(
                      false, _textFieldControlSearch.text.trim());
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'See All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: invitesTabIndex == 0
              ? Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            child: Text('Upcoming Invites'))),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              setState(() {
                                invitesTabIndex = 1;
                              
                              });
                            },
                            child: Text(
                              'My Invites',
                              style: TextStyle(color: Colors.black),
                            ))),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              setState(() {
                                invitesTabIndex = 0;
                              });
                            },
                            child: Text(
                              'Upcoming Invites',
                              style: TextStyle(color: Colors.black),
                            ))),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {},
                            child: Text('My Invites'))),
                  ],
                ),
        ),
        invitesList.isEmpty
            ? CommonApiResultsEmptyWidget("No Invites to show",
                textColorReceived: Colors.black)
            : Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:invitesList.length > 2 ? 2 : invitesList.length,
                    //invitesList.length > 6 ? 6 : invitesList.length,
                    itemBuilder: (context, index) {
                      return EventListItem(
                          videoBaseUrl: videoBaseUrl,
                          imageBaseUrl: imageBaseUrl,
                          onTap: () {
                            Get.to(() => EventInviteDetailsScreen(
                                  eventId: invitesList[index].id ?? 0,
                                ));
                          },
                          eventItem: invitesList[index],
                          onFavClick: () {
                            addOrRemoveFromFavourites(
                                invitesList[index].id ?? 0);
                          });
                    }),
              ),
        Visibility(
          visible: invitesList.isNotEmpty,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () async {
                final isToRefreshList = await Get.to(() => SeeAllEventsScreen(
                    isUpcoming: (invitesTabIndex == 0), isMyEvents: false));
                if (isToRefreshList != null) {
                  _eventBloc.getHomeList(
                      false, _textFieldControlSearch.text.trim());
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'See All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    ;
  }

  Widget _buildSearchList(String imageBaseUrl, String videoBaseUrl) {
    searchEventsList = _eventBloc.eventList + _eventBloc.inviteList;
    return searchEventsList.isEmpty
        ? CommonApiResultsEmptyWidget("No Results found",
            textColorReceived: Colors.black)
        : Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchEventsList.length,
                itemBuilder: (context, index) {
                  EventItem eventItem = searchEventsList[index];

                  return EventListItem(
                      videoBaseUrl: videoBaseUrl,
                      imageBaseUrl: imageBaseUrl,
                      onTap: () async {
                        if ('${eventItem.userId}' == User.userId) {
                          bool? b = await Get.to(() => MyEventScreen(
                                eventId: eventItem.id ?? 0,
                              ));
                          if (b ?? false) {
                            _eventBloc.getHomeList(
                                false, _textFieldControlSearch.text.trim());
                          }
                        } else {
                          Get.to(() => EventInviteDetailsScreen(
                                eventId: eventItem.id ?? 0,
                              ));
                        }
                      },
                      eventItem: eventItem);
                }),
          );
  }

  void addOrRemoveFromFavourites(int id) {
    AppDialogs.loading();
    _eventBloc.addRemoveFavourite(id).then((value) {
      CommonResponse response = value;
      if (response.success == true) {
        if (response.message != null)
          Fluttertoast.showToast(msg: response.message ?? "");
        Get.back();
        _eventBloc.getHomeList(false, _textFieldControlSearch.text.trim());
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
        Get.back();
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

}