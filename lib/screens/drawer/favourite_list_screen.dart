import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/EventDeeplink/event_invite_details_screen.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/util/common_methods.dart';
import 'package:event_app/util/common_widgets.dart';
import 'package:event_app/util/string_constants.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/PainationLoader.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/event_list_item.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FavouritesListScreen extends StatefulWidget {
  const FavouritesListScreen({Key? key}) : super(key: key);

  @override
  _FavouritesListScreenState createState() => _FavouritesListScreenState();
}

class _FavouritesListScreenState extends State<FavouritesListScreen>
    with LoadMoreListener {
  late ScrollController _itemsScrollController;
  late EventBloc _bloc;

  bool isLoadingMore = false;
  List<EventItem> eventsList = [];
  bool isFavouritesUpdated = false;

  @override
  void initState() {
    super.initState();

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = EventBloc(this);
    _bloc.getFavouriteEventList(false);
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
        _bloc.getFavouriteEventList(true);
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
          if (isFavouritesUpdated) {
            CommonMethods().userFavouritesUpdated();
          }
          Get.back();
          return Future.value(true);
        },
        child: Scaffold(
          // appBar: AppBar(
          //   leading: BackButton(
          //     onPressed: _backPressFunction,
          //   ),
          // ),
          appBar:CommonAppBarWidget(
              onPressedFunction:_backPressFunction,
              image: User.userImageUrl,
            ),
          body: SafeArea(
            child: Column(
              children: [
                TitleWithSeeAllButton(title: 'My Favourites'),
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.green,
                    onRefresh: () {
                      return _bloc.getFavouriteEventList(false);
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: FractionalOffset.topCenter,
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder<ApiResponse<dynamic>>(
                                stream: _bloc.eventListStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data!.status!) {
                                      case Status.LOADING:
                                        return CommonApiLoader();
                                      case Status.COMPLETED:
                                        HomeEventsResponse resp =
                                            snapshot.data!.data;
                                        return _buildList(
                                            resp.imageFilesLocation??'',
                                            resp.videoFileUrl??'',
                                            _bloc.eventList);
                                      case Status.ERROR:
                                        return CommonApiErrorWidget(
                                            snapshot.data!.message!,
                                            _errorWidgetFunction);
                                    }
                                  }

                                  return Container(
                                    child: Center(
                                      child: Text(""),
                                    ),
                                  );
                                }),
                            flex: 1,
                          ),
                          Visibility(
                            child: PaginationLoader(),
                            visible: isLoadingMore ? true : false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildList(String imageBaseUrl, String videoBaseUrl, List itemsList) {
    if (itemsList.length > 0) {
      return GridView.builder(
          controller: _itemsScrollController,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemsList.length,
          itemBuilder: (context, index) {
            EventItem eventItem = itemsList[index];
            return EventListItem(
                isSquareShape: true,
                onTap: () async {
                  if ('${eventItem.userId}' == User.userId) {
                    bool? b = await Get.to(() => MyEventScreen(
                      eventId:eventItem.id!,
                    ));
                    if (b ?? false) {
                      isFavouritesUpdated = true;
                      _bloc.getFavouriteEventList(false);
                    }
                  } else {
                    Get.to(() => EventInviteDetailsScreen(
                          eventId: eventItem.id!,
                        ));
                  }
                },
                eventItem: eventItem,
                onFavClick: () {
                  addOrRemoveFromFavourites(itemsList[index]);
                },
                isFromFav: true,
                imageBaseUrl: imageBaseUrl,
                videoBaseUrl: videoBaseUrl);
          });
    } else {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.black),
      );
    }
  }

  void _backPressFunction() {
    print("clicked");
    if (isFavouritesUpdated) {
      CommonMethods().userFavouritesUpdated();
    }
    Get.back();
  }

  void _errorWidgetFunction() {
    _bloc.getFavouriteEventList(false);
  }

  void addOrRemoveFromFavourites(EventItem eventItem) {
    AppDialogs.loading();
    _bloc.addRemoveFavourite(eventItem.id).then((value) {
      Get.back();
      CommonResponse response = value;
      if (response.success == true) {
        isFavouritesUpdated = true;

        Fluttertoast.showToast(
            msg: response.message ?? "Successfully removed from favourites ");

        _bloc.getFavouriteEventList(false);
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }
}
