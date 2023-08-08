// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:event_app/bloc/event_bloc.dart';
// import 'package:event_app/interface/load_more_listener.dart';
// import 'package:event_app/models/my_wishes_response.dart';
// import 'package:event_app/network/api_response.dart';
// import 'package:event_app/widgets/CommonApiErrorWidget.dart';
// import 'package:event_app/widgets/CommonApiLoader.dart';
// import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
// import 'package:event_app/widgets/app_video_thumbnail.dart';
// import 'package:event_app/widgets/title_with_see_all.dart';
// import 'package:event_app/widgets/videoPlayer/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class MyVideoWishListScreen extends StatefulWidget {
//   const MyVideoWishListScreen({Key? key}) : super(key: key);
//
//   @override
//   _MyVideoWishListScreenState createState() => _MyVideoWishListScreenState();
// }
//
// class _MyVideoWishListScreenState extends State<MyVideoWishListScreen>
//     with LoadMoreListener {
//   late ScrollController _itemsScrollController;
//   late EventBloc _bloc;
//   bool isLoadingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _itemsScrollController = ScrollController();
//     _itemsScrollController.addListener(_scrollListener);
//     _bloc = EventBloc(this);
//     _bloc.getMyWishList(false,null);
//   }
//
//   @override
//   refresh(bool isLoading) {
//     if (mounted) {
//       setState(() {
//         isLoadingMore = isLoading;
//       });
//     }
//   }
//
//   void _scrollListener() {
//     if (_itemsScrollController.offset >=
//         _itemsScrollController.position.maxScrollExtent &&
//         !_itemsScrollController.position.outOfRange) {
//       print("reach the bottom");
//       if (_bloc.hasNextPage) {
//         _bloc.getMyWishList(true,null);
//       }
//     }
//     if (_itemsScrollController.offset <=
//         _itemsScrollController.position.minScrollExtent &&
//         !_itemsScrollController.position.outOfRange) {
//       print("reach the top");
//     }
//   }
//
//   @override
//   void dispose() {
//     _itemsScrollController.dispose();
//     _bloc.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: SafeArea(
//         child: Column(
//           children: [
//             TitleWithSeeAllButton(title: 'My Wishes'),
//             Expanded(
//               child: RefreshIndicator(
//                 color: Colors.white,
//                 backgroundColor: Colors.green,
//                 onRefresh: () {
//                   return _bloc.getMyWishList(false,null);
//                 },
//                 child: Container(
//                   height: double.infinity,
//                   width: double.infinity,
//                   alignment: FractionalOffset.topCenter,
//                   child: StreamBuilder<ApiResponse<dynamic>>(
//                       stream: _bloc.myWishStream,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           switch (snapshot.data!.status!) {
//                             case Status.LOADING:
//                               return CommonApiLoader();
//                             case Status.COMPLETED:
//                               MyWishesResponse resp = snapshot.data!.data;
//                               return _buildList(
//                                   resp.baseUrl!, _bloc.myWishList);
//                             case Status.ERROR:
//                               return CommonApiErrorWidget(
//                                   snapshot.data!.message!, _errorWidgetFunction);
//                           }
//                         }
//
//                         return Container(
//                           child: Center(
//                             child: Text(""),
//                           ),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildList(String baseUrl, List itemsList) {
//      if (itemsList.length > 0) {
//         return ListView.builder(
//             controller: _itemsScrollController,
//             shrinkWrap: true,
//             physics: AlwaysScrollableScrollPhysics(),
//             itemCount: itemsList.length,
//             itemBuilder: (context, index) {
//               MyWishListItem eventItem = itemsList[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   child: InkWell(
//                     onTap: () {
//                       Get.to(()=>AppVideoPlayer(
//                         videoFileUrl:
//                         baseUrl + eventItem.videoUrl.toString(),
//                       ));
//                     },
//                     borderRadius: const BorderRadius.all(Radius.circular(12)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Row(
//                             children: [
//                               SizedBox(
//                               width: 90,
//                               height: 90,
//                               child: AppVideoThumbnail(videoFileUrl: '${baseUrl}${eventItem.videoUrl}',),
//                             ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           SizedBox(
//                                             width: 30,
//                                             height: 30,
//                                             child: ClipRRect(
//                                               borderRadius: BorderRadius.circular(100),
//                                               child: CachedNetworkImage(
//                                                 fit: BoxFit.fill,
//                                                 imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${eventItem.email}',
//                                                 placeholder: (context, url) => Center(
//                                                   child: CircularProgressIndicator(),
//                                                 ),
//                                                 errorWidget: (context, url, error) =>
//                                                     Image.asset('assets/images/ic_person_avatar.png'),
//                                               ),
//                                             ),),
//                                           SizedBox(
//                                             width: 12,
//                                           ),
//                                           Expanded(
//                                             child: Text(eventItem.name??'',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.w500)),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 12,),
//                                       Wrap(
//                                         // mainAxisSize: MainAxisSize.max,
//                                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(
//                                                   Icons.event, color: Colors.black38
//                                               ),
//                                               SizedBox(width: 5),
//                                               Text(
//                                                   '${eventItem.date}',
//                                                   style: TextStyle(
//                                                       color: Colors.black45,
//                                                       fontWeight: FontWeight.w400)
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(width: 8,),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(
//                                                   Icons.access_time_rounded,
//                                                   color: Colors.black38
//                                               ),
//                                               SizedBox(width: 5),
//                                               Text(
//                                                   '${eventItem.time}',
//                                                   style: TextStyle(
//                                                       color: Colors.black45,
//                                                       fontWeight: FontWeight.w400)
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   )),
//                             ],
//                           ),
//                           Container(
//                             padding: EdgeInsets.fromLTRB(5, 10, 5, 2),
//                             alignment:FractionalOffset.centerLeft,
//                             child: Text(
//                               eventItem.caption.toString(),
//                               style: TextStyle(color: Colors.black54,
//                                   fontSize: 16,fontWeight: FontWeight.w400),
//                             ),),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             });
//       } else {
//         return SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
//           child: CommonApiResultsEmptyWidget("Results Empty",
//               textColorReceived: Colors.black),
//         );
//       }
//   }
//
//
//   void _errorWidgetFunction() {
//     _bloc.getMyWishList(false,null);
//   }
// }