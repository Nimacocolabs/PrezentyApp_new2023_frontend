import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/event_details.dart';
import 'package:event_app/models/gateway_key_response.dart';
import 'package:event_app/models/hi_card/gift_hi_card_model.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/chat/event_participants_screen.dart';
import 'package:event_app/screens/event/image_editor_preview_screen.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/chat_data.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/util/notifications.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_video_thumbnail.dart';
import 'package:event_app/widgets/videoPlayer/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/wallet&prepaid_cards/wallet_payment_order_details.dart';
import '../../network/api_error_message.dart';
import '../../network/apis.dart';
import '../splash_screen.dart';
import 'participate_screen.dart';
import 'video_wish/video_wish_camera_android_screen.dart';
import 'video_wish/video_wish_camera_ios_screen.dart';

class EventInviteDetailsScreen extends StatefulWidget {
  final int eventId;
  final bool isFromDynamicLink;

  const EventInviteDetailsScreen(
      {Key? key, required this.eventId, this.isFromDynamicLink = false})
      : super(key: key);

  @override
  _EventInviteDetailsScreenState createState() =>
      _EventInviteDetailsScreenState();
}

class _EventInviteDetailsScreenState extends State<EventInviteDetailsScreen> {
  EventBloc _bloc = EventBloc();
  ProfileBloc _profileBloc = ProfileBloc();
  String participantEmail = '';
  late Razorpay _razorPay;
  WalletPaymentOrderDetails? paymentOrderDetails;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setScreenDimensions(context);

      if (User.apiToken.isEmpty) {
        await SharedPrefs.init();
      }
      await EventData.initPath();

      participantEmail = User.userEmail;

      if (participantEmail.isEmpty) {
        participantEmail = SharedPrefs.getString(SharedPrefs.spGuestUserEmail);
      }
      ChatData.chatUserEmail = participantEmail;
      _loadDetails();
    });
  }

  _loadDetails() {
    _bloc.getInviteEventDetail(widget.eventId, participantEmail);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        try {
          if (User.apiToken.isEmpty) {
            Get.offAll(
                () => LoginScreen(
                      isFromWoohoo: false,
                    ),
                transition: Transition.fade);
          } else {
            if (widget.isFromDynamicLink) {
              Get.offAll(() => MainScreen(), transition: Transition.fade);
            } else {
              Get.back();
            }
          }
        } catch (e, s) {
          Completer().completeError(e, s);
          Get.offAll(() => SplashScreen());
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
        ),
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () async {
            return _bloc.getInviteEventDetail(widget.eventId, participantEmail);
          },
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _bloc.eventDetailStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      return CommonApiLoader();
                    case Status.COMPLETED:
                      return _buildContent(snapshot.data!.data);
                    case Status.ERROR:
                      return CommonApiErrorWidget(
                          snapshot.data!.message!, _loadDetails);
                  }
                }
                return SizedBox();
              }),
        )),
      ),
    );
  }

  Widget _buildContent(EventDetailsResponse? response) {
    if (response == null || response.detail == null) {
      return CommonApiErrorWidget('Something went wrong', () {});
    }

    Detail eventDetail = response.detail!;

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(12),
      children: [
        if (!_isEventExpired(eventDetail))
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextButton(
                onPressed: () {
                  _addEventToCalendar(eventDetail);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: secondaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Add to calendar',
                        style: new TextStyle(
                            color: secondaryColor, fontWeight: FontWeight.bold))
                  ],
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  side: BorderSide(
                    width: 1,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Text(
                "Event Title",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
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
          height: 4,
        ),
        Text(
          "${eventDetail.title}",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Event Date",
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          '${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse('${eventDetail.date} ${eventDetail.time}'))}',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
        if ((eventDetail.createdBy ?? '').isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Created by",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "${eventDetail.createdBy}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
        Card(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 20),
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: InkWell(
            onTap: () {
              if (eventDetail.videoFile != null) {
                Get.to(() => AppVideoPlayer(
                      videoFileUrl:
                          '${response.baseUrlVideo}${eventDetail.videoFile!}',
                    ));
              } else {
                String? audioUrl;
                if ((eventDetail.musicFileUrl ?? '').isNotEmpty) {
                  audioUrl =
                      '${response.musicFilesLocation}${eventDetail.musicFileUrl}';
                }
                Get.to(
                    () => PreviewScreen(
                        imageUrl:
                            '${response.imageFilesLocation}${eventDetail.imageUrl}',
                        audioUrl: audioUrl),
                    transition: Transition.fade);
              }
            },
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                child: eventDetail.videoFile != null
                    ? AppVideoThumbnail(
                        videoFileUrl:
                            '${response.baseUrlVideo}${eventDetail.videoFile!}',
                      )
                    : SizedBox.expand(
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fill,
                          imageUrl:
                              '${response.imageFilesLocation}${eventDetail.imageUrl}',
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.black12.withOpacity(0.02),
                            child: Image(
                              image: AssetImage('assets/images/no_image.png'),
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            padding: EdgeInsets.all(5),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
        if (!_isEventExpired(eventDetail))
          (response.isParticipated!
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _button('Send H! Rewards',
                        'assets/images/ic_send_gift_outlined.jpeg', () {
                      // _showBottomSheet(response.participantId!, eventDetail);
                      _sendGiftValue(response.participantId!, eventDetail);
                    }),
                    _button('Send Gift Voucher',
                        'assets/images/ic_send_gift_outlined.jpeg', () {
                      _sendGiftVoucher();
                    }),
                    _button('Send video',
                        'assets/images/ic_video_wish_outlined.jpeg', () async {
                      if (response.participantId == null) {
                        toastMessage('Cannot send video wish');
                      } else {
                        if (!await Permission.camera.request().isGranted) {
                          toastMessage('Camera permission is required');
                          return;
                        }
                        // else if (!await Permission.microphone.request().isGranted) {
                        //   toastMessage('Microphone permission is required');
                        //   return;
                        // }

                        if (Platform.isAndroid) {
                          Get.to(() => VideoWishCameraAndroidScreen(
                                participantId: response.participantId ?? 0,
                              ));
                        } else {
                          Get.to(() => VideoWishCameraIosScreen(
                                participantId: response.participantId ?? 0,
                              ));
                        }
                      }
                    }),
                    _button('Join Chat', 'assets/images/ic_chat_outlined.jpeg',
                        () {
                      if (ChatData.chatUserEmail.isEmpty &&
                          User.apiToken.isNotEmpty) {
                        ChatData.chatUserEmail = User.userEmail;
                      }

                      Notifications.setUserId(ChatData.chatUserEmail);

                      print('ChatData.chatUserEmail:${ChatData.chatUserEmail}');
                      Get.to(() => EventParticipantsScreen(
                          eventId: widget.eventId, isHost: false));
                    }),
                    _button('Join Live Stream',
                        'assets/images/ic_live_stream_outlined.jpeg', () async {
                      DateTime dt1 = DateHelper.getDate(
                          DateHelper.getDateTime(eventDetail.date!));
                      DateTime dt2 = DateHelper.getDate(DateTime.now());

                      if (dt1 != dt2) {
                        toastMessage(
                            'Live stream can only be started on the day of event');
                      } else {
                        //Get.to(() => MeetingOngoingScreen(eventTitle: eventDetail.title!,eventId: eventDetail.id!,));
                        //todo changed for ios
                        String url =
                            "https://meet.jit.si/${md5.convert(utf8.encode('event:${widget.eventId}')).toString()}";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          launchUrl(Uri.parse(url));
                        } else {
                          toastMessage('Unable to open $url');
                        }
                        // Get.to(() => MeetingOngoingScreen(eventTitle: eventDetail.title!,eventId: eventDetail.id!,));
                      }
                    })
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () async {
                      await Get.to(() => ParticipateScreen(
                          eventId: widget.eventId,
                          eventDetails: response,
                          isFromDynamicLink: widget.isFromDynamicLink));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text('Join this Event(Rsvp)',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
      ],
    );
  }

  _sendGiftVoucher() {
    Get.to(() => WoohooVoucherListScreen(
          redeemData: RedeemData.buyVoucher(),
          showBackButton: true,
          showAppBar: true,
        ));
  }

  _sendGiftValue(int participantId, Detail eventDetail) {
    String _amount = '';
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (builder) {
          return SingleChildScrollView(
            child: StatefulBuilder(
              builder: ((BuildContext context, setState) => SafeArea(
           child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Thank you for the gift!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: secondaryColor.shade200)),
                          width: screenWidth * .5,
                          child: TextField(
                            autofocus: true,
                            minLines: 1,
                            maxLines: 1,
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (val) {
                              setState(() {
                               _amount = val;
                              });
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: secondaryColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              hintText: 'Enter the amount',
                              counterText: '',
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                                child: Text(
                                  '$rupeeSymbol',
                                  style: TextStyle(
                                      fontSize: 30, color: secondaryColor.shade300),
                                ),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                            ),
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                        child: Text("Equivalent H! rewards",
                        textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                      ),
                        Center(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: secondaryColor.shade200)),
                          width: screenWidth * .5,
                          child: TextField(
                            enabled: false,
                            autofocus: true,
                            minLines: 1,
                            maxLines: 1,
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                           
                            onChanged: (v) {
                              setState(() {
                                
                              });
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: secondaryColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            
                              counterText: '',
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                                child: Text(
                                  '${_amount}',
                                  style: TextStyle(
                                      fontSize: 20, color: secondaryColor.shade300),
                                ),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text("1 H! Reward = ${rupeeSymbol}1",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      fontFamily: "Play",
                                    )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            width: screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                                VerticalDivider(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  "The Gift Value can be redeemed in any of the brands/merchants associated with Prezenty!",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            
                            GiftHiCardModel? sendGiftData =
                                await _profileBloc.senfGiftToUsers(
                                    participantId: participantId.toString(),
                                    accountId: "",
                                    eventId: eventDetail.id!,
                                    voucherType: "GIFT",
                                    amount: _amount);
                                     int? insTableId = sendGiftData?.insTableId;
                            if (sendGiftData!.statusCode == 200) {
                              String amount = _amount;
                              startPayment(amountGiven: amount,insTableIdPassed: insTableId);
                            } else {
                              toastMessage(
                                  "Something went wrong.Please try again later");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Continue'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              )),
             
            ),
          );
        });
  }

  startPayment({String? amountGiven,int? insTableIdPassed}) async {
    String key = await getGatewayKey();
    if (key.isEmpty) {
      toastMessage('Unable to get payment key');
    } else {
      
      paymentOrderDetails = await _getGatewayOrderId(amountGiven!);
      String orderId = paymentOrderDetails?.orderId ?? "";

      if (orderId.isEmpty) {
        toastMessage('Unable to get order');
      } else {
        try {
          _razorPay = Razorpay();
          _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
              (PaymentSuccessResponse paymentSuccessResponse) {
            toastMessage('Payment successful');
            Get.close(3);
            Get.back();
            Get.to(() => MainScreen());
            Future.delayed(Duration(milliseconds: 100), () async {});
          }); 
          _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
              (PaymentFailureResponse paymentFailureResponse) {
            _onPaymentErrorFn(paymentFailureResponse);
            
          });

          _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});

          var options = {
            'key': key,
            "amount": paymentOrderDetails?.convertedAmount,

            'order_id': paymentOrderDetails?.orderId,
            'currency': "INR",
            'name': 'Prezenty',
            'description': 'Payment',
            'prefill': {
              'name': '${User.userName}',
              'contact': '${User.userMobile}',
              'email': '${User.userEmail}'
            },
            'notes': {
              "type": "GIFTMONEYEVENT",
             // "user_id": User.userId,
              "ins_table_id": insTableIdPassed,
              // 'order_id': paymentOrderDetails?.orderId,
              //"gift_amount":amountEntered,
              "gift_amount": amountGiven,
              // 'state_code': permanentAddress ? permanentStateCode :stateCode ,
              // 'address': permanentAddress ? permanentAddressValue : addressControl.text,
            }
          };

          debugPrint('options:' + jsonEncode(options));

          _razorPay.open(options);
          return true;
        } catch (e, s) {
          Completer().completeError(e, s);
          toastMessage('Unable to start payment. Please try again');
          return false;
        }
      }
    }
  }

  Future<String> getGatewayKey() async {
    try {
      AppDialogs.loading();
      final response = await ApiProviderPrepaidCards()
          .getJsonInstance()
          .get(Apis.getRazorpayGateWayKey);
      GatewayKeyResponse _gatewayKeyResponse =
          GatewayKeyResponse.fromJson(jsonDecode(response.data));
      Get.back();
      return _gatewayKeyResponse.apiKey ?? '';
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return '';
  }

  Future<WalletPaymentOrderDetails?> _getGatewayOrderId(
      String amountEntered) async {

    try {
      AppDialogs.loading();
      final response = await ApiProviderPrepaidCards()
          .getJsonInstance()
          .get('${Apis.getOrderIdTouchPoint}?amount=$amountEntered');
      WalletPaymentOrderDetails _gatewayKeyResponse =
          WalletPaymentOrderDetails.fromJson(jsonDecode(response.data));
     
      Get.back();
 
      return _gatewayKeyResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

  _onPaymentErrorFn(PaymentFailureResponse response) {
    Get.back();
    String msg = '';
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      msg = 'Payment Has Been Cancelled';
    } else if (response.code == Razorpay.NETWORK_ERROR) {
      msg = 'Network Issues while payment request';
    } else {
      msg = 'Payment Error, Try after some time';
    }

    AppDialogs.message(msg);
  }
  // _showBottomSheet(int participantId, Detail eventDetail) async {
  //   String _amount = '';
  //   bool? b = await showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       enableDrag: false,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       builder: (builder) {
  //         return Padding(
  //           padding: MediaQuery.of(context).viewInsets,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(20),
  //                 child: Text(
  //                   'Thank you for the gift!',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 18),
  //                 ),
  //               ),
  //               Center(
  //                 child: Container(
  //                   margin: const EdgeInsets.symmetric(vertical: 12),
  //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border:  Border.all(color: secondaryColor.shade200)),
  //                   width: screenWidth*.5,
  //                   child: TextField(autofocus: true,
  //                   minLines: 1,
  //                     maxLines: 1,maxLength: 5,
  //                     keyboardType: TextInputType.number,
  //                     inputFormatters: <TextInputFormatter>[
  //                       FilteringTextInputFormatter.digitsOnly
  //                     ],
  //                     onChanged: (val) => _amount = val,
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: secondaryColor),
  //                     decoration: InputDecoration(
  //                       border: InputBorder.none,
  //                       disabledBorder: InputBorder.none,
  //                       enabledBorder: InputBorder.none,
  //                       errorBorder: InputBorder.none,
  //                       focusedBorder: InputBorder.none,
  //                       focusedErrorBorder: InputBorder.none,
  //                       hintText: '0',
  //                       counterText: '',
  //                       hintStyle: TextStyle(fontSize: 30,color: Colors.grey),
  //                       prefixIcon: Padding(
  //                         padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
  //                         child: Text('$rupeeSymbol',style:  TextStyle(fontSize: 30,color: secondaryColor.shade300),),
  //                       ),
  //                       contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 20,),

  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Center(
  //                   child: Container(
  //                     width: screenWidth,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [Icon(Icons.info_outline_rounded, size: 24, color: Colors.grey,),
  //                     VerticalDivider(width: 10,),
  //                     Expanded(child: Text("The Gift Value can be redeemed in any of the brands/merchants associated with Prezenty!", style: TextStyle(color: Colors.grey, fontSize: 11, ),))],
  //                     ),
  //                   ),
  //                 ),
  //               ),

  //               SizedBox(
  //                 height: 8,
  //               ),

  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                   ),
  //                   onPressed: () {
  //                     Get.back(result: true);
  //                   },
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(16),
  //                     child: Text('Continue'),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });

  //   if(b??false){
  //     PaymentData paymentData = PaymentData.gift(amount: _amount, account: eventDetail.vaNumber!, purpose: 'Send gift', participantId: participantId, eventId: eventDetail.id!);
  //     Get.to(()=>PaymentV2Screen(paymentData: paymentData));

  //   }
  // }

  Widget _button(String text, String asset, VoidCallback onTap) {
    return Card(
      shadowColor: primaryColor.shade200,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                asset,
                height: 25,
                width: 25,
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(text,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600))),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isEventExpired(Detail eventDetail) {
    String dateTimeString = '${eventDetail.date} ${eventDetail.time}';
    try {
      DateTime eventTime = DateHelper.getDate(DateTime.parse(dateTimeString));
      DateTime dateTimeNow = DateHelper.getDate(DateTime.now());

      return eventTime.compareTo(dateTimeNow) < 0;
    } catch (e) {
      return true;
    }
  }

  _addEventToCalendar(Detail eventDetail) async {
    try {
      DateTime dateTime =
          DateTime.parse('${eventDetail.date} ${eventDetail.time}');

      Event buildEvent({Recurrence? recurrence}) {
        return Event(
          title: '${eventDetail.title}',
          description: 'Need to attend',
          location: '',
          startDate: dateTime,
          endDate: dateTime.add(Duration(minutes: 30)),
          allDay: false,
          recurrence: recurrence,
        );
      }

      await Add2Calendar.addEvent2Cal(
        buildEvent(),
      );
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage('unable to process your request');
    }
  }
}
