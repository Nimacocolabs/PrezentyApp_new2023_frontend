import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/widgets/app_video_thumbnail.dart';
import 'package:flutter/material.dart';

class EventListItem extends StatefulWidget {
  final bool isSquareShape;
  final Function onTap;
  final String imageBaseUrl;
  final String videoBaseUrl;
  final EventItem eventItem;

  final VoidCallback? onFavClick;
  final bool isFromFav;

  const EventListItem(
      {Key? key,
      required this.onTap,
      required this.eventItem,
      required this.imageBaseUrl,
      required this.videoBaseUrl,
      this.onFavClick, this.isSquareShape = true, this.isFromFav=false})
      : super(key: key);


  @override
  _EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.isSquareShape) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                (widget.eventItem.imageUrl??'').isNotEmpty?
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                  '${widget.imageBaseUrl}${widget.eventItem.imageUrl}',
                  placeholder: (context, url) =>
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  errorWidget: (context, url, error) =>
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Image(
                          image: AssetImage('assets/images/no_image.png'),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                )
                    : //(widget.eventItem.videoFile??'').isNotEmpty?
                AppVideoThumbnail(
                  videoFileUrl: 'https://prezenty.in/prezenty/common/uploads/video-event/'+'${widget.eventItem
                      .videoFile}',),
                  //   :  Container(
                  // margin: EdgeInsets.all(5),
                  // child: Image(
                  //   image: AssetImage('assets/images/no_image.png'),
                  //   height: double.infinity,
                  //   width: double.infinity,
                  // ),
                // ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  width: screenWidth / 2,
                  height: 45,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.black12])),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: screenWidth / 2,
                    padding: EdgeInsets.fromLTRB(12, 12, 18, 12),
                    // color: color1.withOpacity(0.5),
                    child: Text(
                      '${widget.eventItem.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: widget.onFavClick == null ? null : widget.onFavClick,
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                            (widget.eventItem.isFavourite ?? false) ||widget.isFromFav
                                ? 'assets/images/ic_hearts_filled.png'
                                : 'assets/images/ic_hearts.png'),
                      ),
                    )),
              ],
            ),
            onTap: () {
              widget.onTap();
            },
          ),
        ),
      );
    } else {
      final DateTime dt = DateHelper.getDateTime('${widget.eventItem.date} ${widget.eventItem.time}');
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap:() {
            widget.onTap();
          },
          child: Container(
              padding: EdgeInsets.all(8),
              child:Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: (widget.eventItem.imageUrl??'').isNotEmpty?
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                        '${widget.imageBaseUrl}${widget.eventItem.imageUrl}',
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          margin: EdgeInsets.all(5),
                          child: Image(
                            image: AssetImage('assets/images/no_image.png'),
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                      )
                          :(widget.eventItem.videoFile??'').isNotEmpty?
                      AppVideoThumbnail(videoFileUrl: '${widget.videoBaseUrl}${widget.eventItem.videoFile}',)
                          :Container(
                        margin: EdgeInsets.all(5),
                        child: Image(
                          image: AssetImage('assets/images/no_image.png'),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${widget.eventItem.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),
                      ),
                      SizedBox(height: 10,),
                      Wrap(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Text(
                                  DateHelper.formatDateTime(dt, 'dd-MMM-yyyy'),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400)
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Text(
                                  DateHelper.formatDateTime(dt, 'hh:mm a'),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],))
                ],
              )),
        ),
      );
    }
  }
}
