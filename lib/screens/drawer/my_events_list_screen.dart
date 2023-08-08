import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/util/common_methods.dart';
import 'package:event_app/util/common_widgets.dart';
import 'package:event_app/util/string_constants.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/event_list_item.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MyEventsListScreen extends StatefulWidget {
  const MyEventsListScreen({Key? key}) : super(key: key);

  @override
  _MyEventsListScreenState createState() => _MyEventsListScreenState();
}

class _MyEventsListScreenState extends State<MyEventsListScreen>
    with LoadMoreListener {
  late ScrollController _itemsScrollController;
  bool isLoadingMore = false;
  List<EventItem> eventsList = [];
  late EventBloc _bloc;

  @override
  void initState() {
    super.initState();

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = EventBloc(this);
    _bloc.getMyEventList(false);
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
        _bloc.getMyEventList(true);
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
        try {
          CommonMethods().userFavouritesUpdated();
        } catch (e) {}
        Get.back();
        return Future.value(true);
      },
      child: Scaffold(
       appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TitleWithSeeAllButton(title: 'My Events'),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.green,
                  onRefresh: () {
                    return _bloc.getMyEventList(false);
                  },
                  child: StreamBuilder<ApiResponse<dynamic>>(
                      stream: _bloc.eventListStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CommonApiLoader();
                        } else if (snapshot.hasData) {
                          switch (snapshot.data!.status!) {
                            case Status.LOADING:
                              return CommonApiLoader();
                            case Status.COMPLETED:
                              HomeEventsResponse resp = snapshot.data!.data;
                              return _buildList(resp.imageFilesLocation!,
                                  resp.videoFileUrl!, _bloc.eventList);
                            case Status.ERROR:
                              return CommonApiErrorWidget(
                                  snapshot.data!.message!, () {
                                _bloc.getMyEventList(false);
                              });
                          }
                        }
                        return Container();
                      }),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildList(String imageUrl, String videoBaseUrl, List itemsList) {
    return itemsList.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: Text('No events'),
          )
        : GridView.builder(
            controller: _itemsScrollController,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              EventItem eventItem = itemsList[index];

              return EventListItem(
                videoBaseUrl: videoBaseUrl,
                imageBaseUrl: imageUrl,
                onTap: () async {
                  bool? b = await Get.to(() => MyEventScreen(
                        eventId: eventItem.id!,
                      ));
                  if (b ?? false) {
                    _bloc.getMyEventList(false);
                  }
                },
                eventItem: eventItem,
                onFavClick: () {
                  print("****1");
                  addOrRemoveFromFavourites(eventItem);
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
        if (eventItem.isFavourite!) {
          Fluttertoast.showToast(
              msg: response.message ?? "Successfully removed from favourites ");
        } else {
          Fluttertoast.showToast(
              msg: response.message ?? "Successfully added to favourites");
        }
        _bloc.getMyEventList(false);
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }
}
