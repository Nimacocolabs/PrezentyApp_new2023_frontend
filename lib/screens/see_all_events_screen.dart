import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/common_widgets.dart';
import 'package:event_app/util/string_constants.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/event_list_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'EventDeeplink/event_invite_details_screen.dart';
import 'event/my_event_screen.dart';

class SeeAllEventsScreen extends StatefulWidget {
  final bool isUpcoming;
  final bool isMyEvents;

  const SeeAllEventsScreen(
      {Key? key, required this.isUpcoming, required this.isMyEvents})
      : super(key: key);

  @override
  _SeeAllEventsScreenState createState() => _SeeAllEventsScreenState();
}

class _SeeAllEventsScreenState extends State<SeeAllEventsScreen>
    with LoadMoreListener {
  late ScrollController _itemsScrollController;
  late EventBloc _bloc;
  bool isLoadingMore = false;

  String title = '';
  bool isFavouritesUpdated = false;

  @override
  void initState() {
    super.initState();
    title =
        '${widget.isUpcoming ? 'Upcoming' : 'My'} ${widget.isMyEvents ? 'Events' : 'Invites'}';

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = EventBloc(this);
    _bloc.getHomeList(false, '', widget.isUpcoming ? 1 : 0);
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
    }
  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
            _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_bloc.hasNextPage) {
        _bloc.getHomeList(true, '', widget.isUpcoming ? 1 : 0);
      }
    }
    if (_itemsScrollController.offset <=
            _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the top");
    }
  }

  @override
  void dispose() {
    _itemsScrollController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Get.back(result: isFavouritesUpdated);
          return Future.value(true);
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: AppBar(
              title: Text("$title"),
              leading: BackButton(onPressed: () {
                Get.back(result: isFavouritesUpdated);
              }),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.green,
              onRefresh: () {
                return _bloc.getHomeList(true, '', widget.isUpcoming ? 1 : 0);
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment: FractionalOffset.topCenter,
                child: StreamBuilder<ApiResponse<dynamic>>(
                    stream: _bloc.eventListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status!) {
                          case Status.LOADING:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case Status.COMPLETED:
                            HomeEventsResponse resp = snapshot.data!.data;
                            return _buildList(
                                resp.imageFilesLocation!,
                                resp.imageFilesLocation!,
                                widget.isMyEvents
                                    ? _bloc.eventList
                                    : _bloc.inviteList);
                          case Status.ERROR:
                            return Text('${snapshot.data!.message!}');
                        }
                      }

                      return Container(
                        child: Center(
                          child: Text(""),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ));
  }

  Widget _buildList(String imageBaseUrl, String videoBaseUrl, List itemsList) {
    if (itemsList.isEmpty) {
      return CommonApiResultsEmptyWidget('No events');
    }

    return GridView.builder(
        controller: _itemsScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return EventListItem(
            imageBaseUrl: imageBaseUrl,
            videoBaseUrl: videoBaseUrl,
            onTap:'${itemsList[index].userId}' == User.userId
                ? () async {
              bool? b = await Get.to(() => MyEventScreen(
                eventId:itemsList[index].id!,
              ));
              if (b ?? false) {
                isFavouritesUpdated = true;
                _bloc.getHomeList(false, '', widget.isUpcoming ? 1 : 0);
              }
            } : (){Get.to(() => EventInviteDetailsScreen(
                eventId: itemsList[index].id!,
                      ));
            },
            eventItem: itemsList[index],
            onFavClick: () {
              addOrRemoveFromFavourites(itemsList[index]);
            },
          );
        });
  }

  void addOrRemoveFromFavourites(EventItem eventItem) {
    AppDialogs.loading();
    _bloc.addRemoveFavourite(eventItem.id).then((value) {
      Get.back();
      CommonResponse response = value;
      if (response.success == true) {
        isFavouritesUpdated = true;
        if (eventItem.isFavourite!) {
          Fluttertoast.showToast(
              msg: response.message ?? "Successfully removed from favourites ");
        } else {
          Fluttertoast.showToast(
              msg: response.message ?? "Successfully added to favourites");
        }
        _bloc.getHomeList(false, '');
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }
}
