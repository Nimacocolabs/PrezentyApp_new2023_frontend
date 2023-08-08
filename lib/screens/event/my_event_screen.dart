import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'dart:io';

import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/event_details.dart';
import 'package:event_app/models/participant_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/chat/chat_screen.dart';
import 'package:event_app/screens/chat/event_participants_screen.dart';
import 'package:event_app/screens/event/choose_event_video_screen.dart';
import 'package:event_app/screens/event/create_dummy_screen.dart';
import 'package:event_app/screens/event/event_video_wish_list_screen.dart';
import 'package:event_app/util/CustomLoader/LinearLoader.dart';
import 'package:event_app/util/CustomLoader/dot_type.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/common_widgets.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/download_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/event_details_button.dart';
import 'package:event_app/widgets/event_share_button.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'report/report_screen.dart';
import 'create_event_preview_screen.dart';
import 'image_editor_screen.dart';
import 'meeting_ongoing_screen.dart';
import 'received_payments_screen.dart';
import 'send_food_voucher_list_participants_screen.dart';

class MyEventScreen extends StatefulWidget {
  final int eventId;

  const MyEventScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _MyEventScreenState createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
  EventBloc _eventBloc = EventBloc();
  EventDetailsResponse? eventDetail;

  @override
  void initState() {
    super.initState();

    EventData.init();
    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _getDetails,
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _eventBloc.eventDetailStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status!) {
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
                      eventDetail = snapshot.data!.data;
                      return _buildContent();
                    case Status.ERROR:
                      return CommonApiErrorWidget(
                          "${snapshot.data!.message!}", _getDetails);
                  }
                }
                return SizedBox();
              }),
        ),
      ),
    );
  }

  Future _getDetails([isReloadParticipants = false]) async {
    _eventBloc.getMyEventDetail(widget.eventId, User.userEmail,
        reloadParticipants: isReloadParticipants);
  }

  Widget _buildContent() {
    if (eventDetail == null) {
      return CommonApiErrorWidget("Something went wrong", _getDetails);
    }
  

    if (EventData.eventId != eventDetail!.detail!.id!) {
      if ((eventDetail!.detail?.imageUrl ?? '').isNotEmpty) {
        EventData.templateType = TemplateType.IMAGE_URL;
        EventData.baseUrlTemplateServerFile =
            eventDetail!.imageFilesLocation ?? '';
        EventData.templateServerFileName = eventDetail!.detail?.imageUrl ?? '';
      } else if ((eventDetail!.detail?.videoFile ?? '').isNotEmpty) {
        EventData.templateType = TemplateType.VIDEO_URL;
        EventData.baseUrlTemplateServerFile = eventDetail!.baseUrlVideo ?? '';
        EventData.templateServerFileName = eventDetail!.detail?.videoFile ?? '';
      }
      EventData.eventId = eventDetail!.detail!.id!;
      EventData.title = eventDetail!.detail!.title!;
      EventData.createdBy = eventDetail!.detail?.createdBy ?? '';
      EventData.dateTime = DateHelper.getDateTime(
          '${eventDetail!.detail!.date} ${eventDetail!.detail!.time}');
    }
    final now = DateTime.now();
    final twoDays = EventData.dateTime!.add(Duration(days: 2));

    bool isExpired = EventData.dateTime!.isBefore(now);


    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(12),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      eventDetail!.detail!.title ?? '',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Event ID: ${widget.eventId}",
                    style: TextStyle(
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text(
                        //   eventDetail!.detail!.title!,
                        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        // ),
                        if ((eventDetail!.detail!.createdBy ?? '').isNotEmpty)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Created by ',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                TextSpan(
                                  text: '${eventDetail!.detail!.createdBy}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade100,
                              ),
                              child: Icon(
                                CupertinoIcons.calendar,
                                color: primaryColor,
                                size: 22,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${DateHelper.formatDateTime(EventData.dateTime!, 'dd-MMM-yyy')}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade100,
                              ),
                              child: Icon(CupertinoIcons.time,
                                  color: primaryColor, size: 22),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${DateHelper.formatDateTime(EventData.dateTime!, 'hh:mm a')}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _confirmDelete();
                  //   },
                  //   child: Column(
                  //     children: [
                  //       Icon(
                  //         CupertinoIcons.delete,
                  //         color: primaryColor,
                  //       ),
                  //       Text(
                  //         'Delete',
                  //         style: TextStyle(color: primaryColor),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
              Divider(
                height: 32,
              ),

              SizedBox(
                height: 16,
              ),


              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(
                            () => ReceivedPaymentsScreen(eventId: widget.eventId),
                        transition: Transition.fade);
                  },
                  child: ListTile(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    leading: Image.asset(
                      'assets/images/ic_nav_gifts_vouchers.png',
                    ),
                    title: Text(
                      'Received gifts',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: EventDetailsButton(
                        child: Column(
                           mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/ic_templates.png',
                              height: 50,
                              width: 500,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Edit Template',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        onTap: isExpired?null:() async {
                          if (EventData.templateType ==
                                  TemplateType.IMAGE_URL ||
                              EventData.templateType ==
                                  TemplateType.IMAGE_FILE) {
                            bool b = await _loadImage();
                            if (b) {
                              List<Layer> layers = [
                                Layer(
                                    LayerType.Canvas,
                                    CanvasProperties.canvas(
                                        true, Colors.white, 100)),
                                Layer(
                                    LayerType.Image,
                                    ImageProperties.image(
                                        true,
                                        Offset(0, 0),
                                        EventData.templateFilePath,
                                        false,
                                        100,
                                        100,
                                        0)),
                              ];
                              Get.to(() => ImageEditorScreen(
                                    isEdit: true,
                                    layers: layers,
                                  ));
                            }
                          } else if (EventData.templateType ==
                                  TemplateType.VIDEO_URL ||
                              EventData.templateType ==
                                  TemplateType.VIDEO_FILE) {
                            Get.to(
                                () => ChooseEventVideoScreen(
                                    selectedVideoFilePath:
                                        EventData.templateFilePath,
                                    isUpdateVideo: true),
                                opaque: false);
                          }
                        }),
                  ),

                  SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: EventDetailsButton(
                      onTap: isExpired? null: () {
                        Get.to(() => SendFoodVoucherListParticipants(
                              eventId: widget.eventId,
                              eventAccount: eventDetail!.detail?.vaNumber ?? '',
                            ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ic_foods.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          
                          Text(
                            'Send Food Vouchers',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: EventDetailsButton(
                  //     onTap:   ()  {
                  //       Get.to(() => CreateDummyScreen(isEdit: true,));
                  //     },
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Image.asset(
                  //           'assets/images/ic_gift_vouchers.png',
                  //           height: 50,
                  //           width: 50,
                  //         ),
                  //         SizedBox(
                  //           height: 8,
                  //         ),
                  //         Text(
                  //           'Edit Gift or Vouchers',
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis,
                  //           style: TextStyle(
                  //               color: Colors.white, fontWeight: FontWeight.w500),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 16,
              ),

              SizedBox(
                height: 16,
              ),

              Row(
                children: [
                  Expanded(
                    child: EventDetailsButton(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/ic_video.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Video Wishes',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        onTap: () {
                          Get.to(() => EventVideoWishListScreen(
                                eventId: widget.eventId,
                              ));
                        }),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: EventDetailsButton(
                      onTap: () {
                        Get.to(() => ReportScreen(eventId: widget.eventId));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ic_reports.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Reports',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),

              Text(
                'Live Stream',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 8,
              ),
              EventDetailsButton(
                onTap: isExpired?null:() async {
                  DateTime dt1 = DateHelper.getDate(EventData.dateTime!);
                  DateTime dt2 = DateHelper.getDate(DateTime.now());

                  if (dt1.isBefore(dt2)) {
                    toastMessage(
                        'Live stream cannot be started for a past event');
                  } else if (dt1.isAfter(dt2)) {
                    toastMessage(
                        'Live stream can only be started on the day of event');
                  } else {
                    _eventBloc.sendGoLiveNotification(widget.eventId);
                    // Get.to(() => MeetingOngoingScreen(eventTitle: eventDetail!.detail!.title??'',eventId:widget.eventId));
                    //  todo changed for ios
                    String url =
                        "https://meet.jit.si/${md5.convert(utf8.encode('event:${widget.eventId}')).toString()}";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      launchUrl(Uri.parse(url));
                    } else {
                      toastMessage('Unable to open $url');
                    }
                  }
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_live.png',
                      height: 70,
                      width: 70,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Text(
                        'Go Live',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Image.asset(
                      'assets/images/ic_go_live.png',
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
              ),

              // TitleWithSeeAllButton(title: 'Gifts & Vouchers',margin: EdgeInsets.symmetric(vertical: 16),),

              SizedBox(
                height: 16,
              ),

              TitleWithSeeAllButton(
                title: 'Users',
                seeAllOnTap: () {
                  Get.to(() => EventParticipantsScreen(
                      eventId: widget.eventId, isHost: true));
                },
                margin: EdgeInsets.zero,
              ),
              _buildParticipantList(eventDetail!.participantList),
            ],
          ),
        ),
        Center(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(width: 2, color: secondaryColor.shade400),
            ),
            onPressed: () async {
              if (EventData.templateType == TemplateType.IMAGE_URL ||
                  EventData.templateType == TemplateType.IMAGE_FILE) {
                bool b = await _loadImage();
                if (b)
                  Get.to(() => CreateEventPreviewScreen(
                      isFromViewDemo: true,
                      hasAudio: eventDetail!.detail!.musicFileUrl != null));
              } else if (EventData.templateType == TemplateType.VIDEO_URL ||
                  EventData.templateType == TemplateType.VIDEO_FILE) {
                Get.to(() => CreateEventPreviewScreen(
                    isFromViewDemo: true, hasAudio: false));
              } else {
                toastMessage('Something went wrong');
              }
            },
            child: Text(
              'View Demo',
              style: TextStyle(color: secondaryColor.shade400),
            ),
          ),
        ),
        twoDays.isBefore(now)  ? SizedBox() :

        isExpired?SizedBox():
        EventShareButton(
          eventId: widget.eventId,
          eventTitle: eventDetail!.detail!.title ?? '',
          eventImageUrl: '${eventDetail!.imageFilesLocation}${eventDetail!.detail!.imageUrl}',
        ),
      ],
    );
  }

  Future<bool> _loadImage() async {
    if (EventData.templateFilePath.isEmpty) {
      bool b = await _downloadImageTemplateData();
      if (!b) return false;
    }
    return true;
  }

  Widget _buildParticipantList(List itemsList) {
    if (itemsList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text('No participators'),
      );
    }
    return Container(
      height: 140,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: itemsList.length,
          itemBuilder: (context, index) {
            ParticipantListItem item = itemsList[index];
            return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Material(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: InkWell(
                        onTap: () async {
                          if ((item.email ?? '').isEmpty) {
                            toastMessage('Email of this user is not available');
                            return;
                          }
                          bool? b = await Get.to(() => ChatScreen(
                              eventId: widget.eventId,
                              opponentEmail: item.email!,
                              displayName: item.name,
                              isBlocked: item.isBlocked ?? false));
                          if (b ?? false) {
                            _getDetails(true);
                          }
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: FractionalOffset.center,
                                  width: 80,
                                  height: double.infinity,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${item.email}',
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/ic_person_avatar.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                padding: EdgeInsets.fromLTRB(3, 8, 3, 8),
                                alignment: FractionalOffset.center,
                                child: Text(
                                  '${itemsList[index].name ?? ''}',
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
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: itemsList[index].id == null
                          ? SizedBox()
                          : IconButton(
                              onPressed: () {
                                String nameToShow =
                                    itemsList[index].name ?? "N/A";
                                String emailToShow =
                                    itemsList[index].email ?? "N/A";
                                String phoneToShow =
                                    itemsList[index].phone ?? "N/A";
                                String addressToShow =
                                    itemsList[index].address ?? "N/A";
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
                ));
          }),
    );
  }

  Future<bool> _downloadImageTemplateData() async {
    bool downloadSuccess = false;
    if ((eventDetail!.detail!.imageUrl ?? '').isNotEmpty) {
      String root = '';

      if (Platform.isAndroid) {
        root = '${(await getExternalStorageDirectory())!.path}';
      } else {
        root = '${(await getApplicationDocumentsDirectory()).path}';
      }

      String path = '$root/Event/event/${eventDetail!.detail!.id}';
      String fileName = 'image.png';

      File file = File('$path/$fileName');
      if (file.existsSync()) await file.delete(recursive: true);

      bool ib = await DownloadHelper.load(
          context,
          '${eventDetail!.imageFilesLocation}${eventDetail!.detail!.imageUrl}',
          path,
          fileName);

      if (ib) {
        EventData.templateFilePath = '$path/$fileName';
        EventData.templateType = TemplateType.IMAGE_FILE;
        downloadSuccess = true;
      }
      ;

      String audioFileName = 'audio.mp3';

      File aud = File('$path/$audioFileName');
      if (aud.existsSync()) await aud.delete(recursive: true);

      if (eventDetail!.detail!.musicFileUrl != null) {
        bool ab = await DownloadHelper.load(
            context,
            '${eventDetail!.musicFilesLocation}${eventDetail!.detail!.musicFileUrl}',
            path,
            audioFileName);

        if (ab) {
          EventData.eventAudioFilePath = '$path/$audioFileName';
        } else {
          downloadSuccess = false;
        }
      }

      if (!downloadSuccess) {
        toastMessage('Unable to download event data');
      }
    }

    return downloadSuccess;
  }

  _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Are you sure want to delete this event?'),
          actions: [
            OutlinedButton(
              child: Text('No'),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () {
                Get.back();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  _delete() async {
    AppDialogs.loading();

    bool result = false;
    try {
      EventBloc _eventBloc = EventBloc();
      CommonResponse response = await _eventBloc.deleteEvent(widget.eventId);

      if (response.success!) {
        toastMessage('Event deleted successfully');

        Get.back();
        result = true;
      } else if (response.success! == false) {
        toastMessage('${response.message!}');
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e) {
      toastMessage('Something went wrong. Please try again');
    } finally {
      Get.back(result: result);
    }
  }
}
