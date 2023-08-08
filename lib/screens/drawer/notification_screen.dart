import 'package:event_app/bloc/notifications_list_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/notifications_list_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/event_repository.dart';
import 'package:event_app/screens/common_notifications_screen.dart';
import 'package:event_app/screens/drawer/bid_notification_screen.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/screens/event/event_video_wish_list_screen.dart';
import 'package:event_app/screens/event/received_payments_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with LoadMoreListener {
  late ScrollController _itemsScrollController;
  late NotificationListBloc _notificationListBloc;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _notificationListBloc = NotificationListBloc(this);
    _notificationListBloc.getList(false);
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
      if (_notificationListBloc.hasNextPage) {
        _notificationListBloc.getList(true);
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
    _notificationListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // CommonMethods().userFavouritesUpdated();
        // Get.back();
        return true;
        // return Future.value(true);
      },
      child: Scaffold(
          appBar: CommonAppBarWidget(
            onPressedFunction: () {
              Get.back();
            },
            image: User.userImageUrl,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TitleWithSeeAllButton(title: 'Notifications'),
                RefreshIndicator(
                  onRefresh: (){return _notificationListBloc.getList(true);},
                  child: StreamBuilder<ApiResponse<dynamic>>(
                      stream: _notificationListBloc.itemsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          switch (snapshot.data!.status!) {
                            case Status.LOADING:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case Status.COMPLETED:
                              //NotificationResponse resp = snapshot.data!.data;
                              return _buildList(_notificationListBloc.itemsList);
                            case Status.ERROR:
                              return Text('${snapshot.data!.message!}');
                          }
                        }
                        return Container();
                      }),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildList(List itemsList) {
    return itemsList.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: Text('No Notifications'),
          )
        : Column(
      children:[
    ListView.builder(
            controller: _itemsScrollController,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              ListItem notificationItem = itemsList[index];
              print("fjgg${notificationItem.url}");
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.fromLTRB(10, 4, 10, 4),
                child: InkWell(
                  onTap: notificationItem.type == null &&
                         notificationItem.typeId == null &&
                          notificationItem.eventId == null
                      ? null
                      : () {

                    notificationItem.type == "participated" ?
                          _gotoScreen(
                              notificationItem.type,
                              notificationItem.typeId,
                              notificationItem.eventId,
                              notificationItem.description) :
                      Get.to(() => BidNotificationScreen(
                        isFromNotification: true,
                        title:  notificationItem.message,
                        imageUrl: notificationItem.imageUrl,
                        url: notificationItem.url,
                      ));
                    EventRepository().getNotificationStatus(notificationItem.id);
                        },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        Row(children: [
                          GestureDetector(
                            onTap: (){
                           //   notificationItem.status==1?EventRepository().getNotificationStatus(notificationItem.id):
                            },
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                              text: '${notificationItem.message}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600)),
                            ])),

                          ),
                         Spacer(),
                       notificationItem.status==1?Icon(Icons.circle,color: Colors.green,size: 13,)  :Icon(Icons.check,color: Colors.blue,size: 18,)
                        ]),
                        SizedBox(
                          height: 10,
                        ),

                        Text(
                          '${parseformatDate(notificationItem.createdAt, 'dd-MM-yy h:mm a')}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.blueGrey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })]);
  }

  _gotoScreen(String? type, int? typeId, int? eventId, String? description) {
    switch ((type ?? '')) {
      case 'video_wish':
        Get.to(() => EventVideoWishListScreen(
              eventId: eventId!,
            ));
        break;
      // case 'gift_voucher':
      //   Get.to(()=>ReceivedGiftVoucherListScreen(eventIdReceived: eventId,));
      //   break;
      case 'participated':
        Get.to(() => MyEventScreen(
              eventId: eventId!,
            ));
        break;
      case 'receive_event_gift':
        Get.to(() => ReceivedPaymentsScreen(eventId: eventId!));
        break;
      case 'general':
        Get.to(() => CommonNotificationScreen(notificationContent: description,));
        break;
    }
  }
}
