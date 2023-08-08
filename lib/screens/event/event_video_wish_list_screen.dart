import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/my_wishes_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_video_thumbnail.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:event_app/widgets/videoPlayer/video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/event_data.dart';

class EventVideoWishListScreen extends StatefulWidget {
  final int? eventId;

  const EventVideoWishListScreen({Key? key, required this.eventId})
      : super(key: key);

  @override
  _EventVideoWishListScreenState createState() =>
      _EventVideoWishListScreenState();
}

class _EventVideoWishListScreenState extends State<EventVideoWishListScreen>
    with LoadMoreListener {
  late ScrollController _itemsScrollController;
  late EventBloc _bloc;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    EventData.init();
    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);
    _bloc = EventBloc(this);
    _bloc.getMyWishList(false, widget.eventId);
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
        _bloc.getMyWishList(true, widget.eventId);
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
    return Scaffold(
       appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TitleWithSeeAllButton(title: 'Video Wishes'),
            Expanded(
              child: StreamBuilder<ApiResponse<dynamic>>(
                  stream: _bloc.myWishStream,
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
                          MyWishesResponse resp = snapshot.data!.data;
                          return _buildList(
                              resp.baseUrl!, _bloc.myWishList);
                        case Status.ERROR:
                          return Text('${snapshot.data!.message!}');
                      }
                    }
                    return Container();
                  }),
            )
          ],
        ));
  }

  Widget _buildList(String baseUrl, List itemsList) {
    if (itemsList.length > 0) {
      return ListView.builder(
          controller: _itemsScrollController,
          shrinkWrap: true,
          itemCount: itemsList.length,
          itemBuilder: (context, index) {
            MyWishListItem item = itemsList[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.fromLTRB(12, 8, 100, 16),
              child: InkWell(
                onTap: () {
                  Get.to(()=>AppVideoPlayer(
                    videoFileUrl: baseUrl + item.videoUrl.toString(),
                  ));
                },
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                            SizedBox(
                            width: 20,
                              height: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${item.email}',
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/images/ic_person_avatar.png'),
                                ),
                              ),),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Text(item.name.toString()),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(item.caption ?? ''),
                                ),
                              ],
                            ),
                          ),

                          IconButton(onPressed: () async {
                            String url = '$baseUrl${item.videoUrl}';
                            Share.share(url);
                            return;
                            if(await canLaunchUrl(Uri.parse(url))){
                              launchUrl(Uri.parse(url));
                            }else{
                              toastMessage('Unable to share');
                            }
                          }, icon: Icon(Icons.share,color: Colors.grey,))
                        ],
                      ),
                    AspectRatio(
                        aspectRatio: 1/1,
                        child: AppVideoThumbnail(videoFileUrl: '$baseUrl${item.videoUrl}',)),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          item.date.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      return CommonApiResultsEmptyWidget("Results Empty",
          textColorReceived: Colors.black);
    }
  }
}
