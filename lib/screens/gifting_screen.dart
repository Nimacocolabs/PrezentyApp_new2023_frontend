import 'dart:async';
import 'dart:convert';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/gateway_key_response.dart';
import 'package:event_app/models/get_event_based_gifts_model.dart';
import 'package:event_app/models/hi_card/gift_hi_card_model.dart';
import 'package:event_app/models/user_event_summary_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_payment_order_details.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/screens/drawer/my_vouchers/my_vouchers_screen.dart';
import 'package:event_app/screens/event/create_new_event_screen.dart';
import 'package:event_app/screens/event/my_events_and_invites_screen.dart';
import 'package:event_app/screens/event/template_category_list_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_text_box.dart';
import 'event/received_payments_screen.dart';
import 'info_video_screen.dart';
import 'prepaid_cards_wallet/my_cards_wallet/wallet_payment_screen.dart';

class GiftingScreen extends StatefulWidget {
  const GiftingScreen({Key? key, this.currentPageIndex = 0}) : super(key: key);

  final int currentPageIndex;

  @override
  State<GiftingScreen> createState() => _GiftingScreenState();
}

class _GiftingScreenState extends State<GiftingScreen> {
  EventBloc _eventBloc = EventBloc();
  ProfileBloc _profileBloc = ProfileBloc();
  WalletBloc _walletBloc = WalletBloc();

  TextFieldControl _textFieldControlTitle = TextFieldControl();
  TextFieldControl _textFieldControlCreatedBy = TextFieldControl();
  TextEditingController _textFieldControlEventIDSearch =
      TextEditingController();
  TextEditingController _textEditingControllerLoadingAmount =
      TextEditingController();
  DateTime _dateTime = DateTime.now();
  String selectedCategoryId = '';
  late bool isToShowFoodList;

  double? tabIndex = 1;
  double? currentTabIndex = 1;
  double? categoryTabIndex = 0;
  double? scrollChangeValue;
  bool? prepaidCardUserOrNot;
  GetEventBasedGiftModel? eventGiftData;
  late Razorpay _razorPay;
  WalletPaymentOrderDetails? paymentOrderDetails;
  UserEventSummaryModel? eventSummaryData;
 
  bool showSearchByEventId = false;
  String? giftingType;

  String? imageBaseUrl =
      "https://prezenty.in/prezenty/common/uploads/woohoo-images/";

  late PageController _pageController;

  List pages = [
    {'icon': Icons.event, 'title': 'Create event'},
    {'icon': Icons.card_giftcard_rounded, 'title': "Gift Now"},
    {'icon': Icons.card_giftcard_rounded, 'title': "Send E-Gift Card"},
    {'icon': Icons.history_rounded, 'title': "My Events & Invites"},
    {'icon': Icons.calendar_month_rounded, 'title': "Event Summary"},
    {'icon': Icons.discount_outlined, 'title': "My Vouchers"},
  ];

  RxInt currentPageIndex = 0.obs;

  @override
  void initState() {
    super.initState();

    currentPageIndex(widget.currentPageIndex);

    _pageController = PageController(
      initialPage: widget.currentPageIndex,
      viewportFraction: 0.4,
    );

    _eventBloc = EventBloc();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userEventSummaryDetails();
    });
  }

  userEventSummaryDetails() async {
    eventSummaryData = await _eventBloc.getUserEventSummary(User.userId);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWidget(
          title: "",
          onPressedFunction: () {
            Get.to(() => MainScreen());
          },
          image: User.userImageUrl),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SafeArea(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 130,
                child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      currentPageIndex(index);
                    },
                    children: [
                      for (int i = 0; i < pages.length; i++) headerTiles(i),
                    ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < pages.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      Icons.circle,
                      size: currentPageIndex == i ? 16 : 12,
                      color: currentPageIndex == i ? primaryColor : Colors.grey,
                    ),
                  )
              ]),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: IndexedStack(index: currentPageIndex.value, children: [
                    Container(
                      //height: MediaQuery.of(context).size.height,
                      height: 450,
                      width: screenWidth,
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 10),
                      child: CreateNewEventScreen(showAppBar: false),
                    ),
                    giftNowWidget(),
                    
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: screenWidth,
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 10),
                      child: WoohooVoucherListScreen(
                          redeemData: RedeemData.buyVoucher(),
                          showBackButton: true,
                          showAppBar: false),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: screenWidth,
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 10),
                      child: MyEventsAndInvitesScreen(showAppBar: false),
                    ),
                    eventHistoryWidget(),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: screenWidth,
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 10),
                      child: MyVouchersScreen(showAppBar: false),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headerTiles(int index) {
    bool isCurrent = currentPageIndex == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 160,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: isCurrent ? 8 : 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            pages[index]['icon'],
            color: primaryColor,
            size: 42,
          ),
          if (!isCurrent)
            SizedBox(
              height: 2,
            ),
          Expanded(
            child: Text(
              '${pages[index]['title']}',
              overflow:
                  isCurrent ? TextOverflow.visible : TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
                fontSize: isCurrent ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  eventHistoryWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Get.to(() => WoohooVoucherListScreen(
                    redeemData: RedeemData.hiRewardRedeem(),
                    showBackButton: true,
                    showAppBar: true,
                  ));
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
                child: Row(children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Redeem H! Rewards",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          Get.to(() => WoohooVoucherListScreen(
                                redeemData: RedeemData.hiRewardRedeem(),
                                showBackButton: true,
                                showAppBar: true,
                              ));
                        },
                        child: Text(
                          "Redeem",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ),
                ]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
          child: Card(
            elevation: 5,
            color: Colors.grey.shade200,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "H! Rewards Balance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 60, right: 10),
                  child: Container(
                    height: 90,
                    width: 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor])),
                    child: Center(
                      child: Text(
                        "${User.userHiCardBalance}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        eventHistoryList(),
      ],
    );
  }

  Widget eventHistoryList() {
    if (eventSummaryData?.data?.isEmpty ?? true) {
      return Center(child: CommonApiResultsEmptyWidget('No history to show'));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: eventSummaryData?.data
                ?.map((UserEventSummaryData e) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(() =>
                              ReceivedPaymentsScreen(eventId: e.eventId!));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black45,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white70,
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(212, 228, 253, 3),
                                Color.fromRGBO(241, 206, 228, 3)
                              ])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                elevation: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(212, 228, 253, 3),
                                      Color.fromRGBO(241, 206, 228, 3)
                                    ]),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${e.eventName}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.event_note_rounded,
                                    color: primaryColor,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Event ID: ${e.eventId}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Received Rewards: ${e.recievedAmount}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Date: ${e.eventDate}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 55, left: 10),
                                    child: TextButton(
                                        onPressed: () {
                                          Get.to(() => ReceivedPaymentsScreen(
                                              eventId: e.eventId!));
                                        },
                                        child: Text(
                                          "View More",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 16),
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList() ??
            [],
      );
    }
  }

  createEventFormWidget() {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 8, bottom: 10),
                child: TitleWithSeeAllButton(
                  title: 'Create your memorable moment',
                ),
              )),
              IconButton(
                onPressed: () {
                  Get.to(() => InfoVideoScreen(videoId: 'create_event'));
                },
                icon: Icon(Icons.info_outline_rounded),
                color: Colors.grey,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                AppTextBox(
                  textFieldControl: _textFieldControlTitle,
                  hintText: 'Title',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Created by',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                AppTextBox(
                  textFieldControl: _textFieldControlCreatedBy,
                  hintText: 'Created by',
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DateTime dt =
                                  await DateHelper.pickDate(context, _dateTime);
                              if (_dateTime != dt) {
                                _dateTime = DateTime(dt.year, dt.month, dt.day,
                                    _dateTime.hour, _dateTime.minute);
                                setState(() {});
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${DateHelper.formatDateTime(_dateTime, 'dd-MMM-yyy')}'),
                                    Icon(CupertinoIcons.calendar),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DateTime dt =
                                  await DateHelper.pickTime(context, _dateTime);
                              if (_dateTime != dt) {
                                _dateTime = DateTime(
                                    _dateTime.year,
                                    _dateTime.month,
                                    _dateTime.day,
                                    dt.hour,
                                    dt.minute);
                                setState(() {});
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${DateHelper.formatDateTime(_dateTime, 'hh:mm a')}'),
                                    Icon(CupertinoIcons.time),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 80, right: 80, top: 10, bottom: 30),
                  child: Container(
                    height: 45,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          _validate();
                        },
                        child: Text(
                          "Continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  giftNowWidget() {
    int? eventIdSearched =
        int.tryParse(_textFieldControlEventIDSearch.text.trim());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            "You can gift H! Rewards or Vouchers or to Wallet for your loved ones.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: screenWidth * 2,
            height: showSearchByEventId ? 160 :90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.black45, style: BorderStyle.solid)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showSearchByEventId =true;
                            giftingType = "Send H! Rewards";
                          });
                         
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,left:8,right: 8),
                          child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [primaryColor, secondaryColor])),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Gift H! Rewards",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                         setState(() {
                            showSearchByEventId =true;
                              giftingType = "Send Vouchers";
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,left:8,right: 8),
                          child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [primaryColor, secondaryColor])),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Gift Voucher",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                           setState(() {
                            showSearchByEventId =true;
                              giftingType = "Send To Wallet";
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,left:8,right: 8),
                          child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [primaryColor, secondaryColor])),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Gift To Wallet",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                showSearchByEventId ?
             searchByEventId(typeOfGift: giftingType): Container(),
              ],
            ),
          ),
        ),
        eventBasedGiftWidget(eventIdValue: eventIdSearched,giftTypeValue: giftingType),
        SizedBox(
          height: 30,
        ),
     
      ],
    );
  }

  eventBasedGiftWidget({int? eventIdValue,String? giftTypeValue}) {
    return SizedBox(
      width: screenWidth,

      //height: screenHeight*0.72,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _eventBloc.eventBasedGiftStream,
          builder: (context, snapshot) {
            print("aaaa");

            if (snapshot.hasData && snapshot.data?.status != null) {
              print("bbbbb");
              print(snapshot.data!.status);
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  print("ccccc");
                  return CommonApiLoader();
                case Status.COMPLETED:
                  print("dddd");
                  GetEventBasedGiftModel resp = snapshot.data!.data;
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                          child: Column(
                        children: [
                          Container(
                            height: 190,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black45,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(212, 228, 253, 3),
                                  Color.fromRGBO(241, 206, 228, 3)
                                ])),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.card_giftcard_rounded,
                                      color: primaryColor,
                                      size: 35,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13,
                                              left: 5,
                                              right: 5,
                                              bottom: 6),
                                          child: Text(
                                            "Event Id: ${resp.data?.id}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "Event Name: ${resp.data?.title}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "Created By: ${resp.data?.createdBy}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                       giftingType == "Send To Wallet" && resp.data?.wallet == "no" ?
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Text("The event user doesnot have a wallet.",
  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
):

                              Padding(
                                padding: const EdgeInsets.only(left:90,right:90),
                                child: InkWell(
                                  onTap: () {

                                    giftingType == "Send H! Rewards" ?
                                     giftHiRewardsWidget(
                                              typedEventId: eventIdValue)
                                              : giftingType == "Send Vouchers" ?
                                              Get.to(() => WoohooVoucherListScreen(
                                                redeemData:
                                                    RedeemData.buyVoucher(),
                                                showBackButton: true,
                                                eventId:
                                                    eventIdValue.toString(),
                                                showAppBar: true,
                                              ))
                                              :


                                      
                                    giftToWalletWidget();
                                    
                                  },
                                  child: Container(
                                      height: 45,
                                     
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                          gradient: LinearGradient(
                                              colors: [
                                                primaryColor,
                                                secondaryColor
                                              ])),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(
                                                  4.0),
                                          child: Text(
                                            "${giftTypeValue}",
                                            textAlign:
                                                TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 17,
                                                color:
                                                    Colors.white),
                                          ),
                                        ),
                                      )),
                                ),
                              )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  );
                case Status.ERROR:
                  print("eeee");
                  return CommonApiResultsEmptyWidget(
                      "${snapshot.data?.message ?? ""}",
                      textColorReceived: Colors.black);
                default:
                  print("");
              }
            }
            return SizedBox();
          }),
    );
  }

  giftToWalletWidget() {
    _textEditingControllerLoadingAmount.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: ((context) {
          return SingleChildScrollView(
            child: StatefulBuilder(
              builder: ((BuildContext context, setState) => SafeArea(
                    child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: Text("Load Money To Wallet",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20)),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Event ID',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            AppTextBox(
                              enabled: false,
                              hintText:
                                  "${_textFieldControlEventIDSearch.value.text.trim()}",
                              textInputAction: TextInputAction.next,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Enter the amount to be loaded",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (v) {
                                  int? amountValue = int.tryParse(
                                      _textEditingControllerLoadingAmount
                                          .value.text
                                          .trim());
                                  if (_textEditingControllerLoadingAmount
                                      .value.text.isEmpty) {
                                    return "Amount cannot be empty";
                                  } else if (amountValue == 0) {
                                    return "Enter an amount greater than zero";
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixText: "${rupeeSymbol}"),
                                controller: _textEditingControllerLoadingAmount,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 140, right: 120, bottom: 5),
                              child: ElevatedButton(
                                  onPressed: () {
                                    String amount =
                                        _textEditingControllerLoadingAmount
                                            .value.text
                                            .trim();
                                    String eventId =
                                        _textFieldControlEventIDSearch
                                            .value.text
                                            .trim();
                                    validateGiftToWallet(
                                        givenAmount: amount,
                                        searchEventId: eventId);
                                  },
                                  child: Text("Submit")),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          );
        }));
  }

  validateGiftToWallet({String? givenAmount, String? searchEventId}) async {
    if (givenAmount!.isEmpty) {
      toastMessage("Enter a valid amount");
    } else if (givenAmount == "0") {
      toastMessage("Enter an amount greater than zero");
    } else {
      CommonResponse validateWalletData =
          await _walletBloc.validateWalletNumber(
        type: "event",
        eventID: searchEventId,
        amount: givenAmount,
      );
      if (validateWalletData.statusCode == 200) {
        Get.off(WalletPaymentScreen(
          accountid: User.userId,
          amount: givenAmount,
          walletNumber: validateWalletData.walletNumber,
          type: "event",
          eventId: searchEventId,
        ));
      } else {
        toastMessage("${validateWalletData.message}");
      }
    }
  }

  giftHiRewardsWidget({int? typedEventId}) async {
    String _amount = '';
    await showModalBottomSheet(
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
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                            Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: secondaryColor.shade200)),
                                width: screenWidth * .5,
                                child: TextField(
                                  onChanged: (val) {
                                    setState(() {
                                      _amount = val;
                                    });
                                  },
                                  autofocus: true,
                                  minLines: 1,
                                  maxLines: 1,
                                  maxLength: 5,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 0, 12),
                                      child: Text(
                                        '$rupeeSymbol',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: secondaryColor.shade300),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 12),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 10),
                              child: Text(
                                "Equivalent H! rewards",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: secondaryColor.shade200)),
                                width: screenWidth * .5,
                                child: TextField(
                                  onChanged: (v) {
                                    setState(() {});
                                  },
                                  enabled: false,
                                  autofocus: true,
                                  minLines: 1,
                                  maxLines: 1,
                                  maxLength: 5,
                                  keyboardType: TextInputType.number,
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
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 0, 12),
                                      child: Text(
                                        '${_amount}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: secondaryColor.shade300),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 12),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          participantId: "",
                                          accountId: User.userId,
                                          eventId: typedEventId,
                                          voucherType: "GIFT",
                                          amount: _amount);
                                  int? insTableId = sendGiftData?.insTableId;
                                  if (sendGiftData!.statusCode == 200) {
                                    String amount = _amount;
                                    startPayment(
                                        amountGiven: amount,
                                        insTableIdPassed: insTableId);
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

  startPayment({String? amountGiven, int? insTableIdPassed}) async {
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
            _showSuccessDialog();
            Get.to(() => GiftingScreen());

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

  _showSuccessDialog() {
    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green.shade300,
                    size: 70,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You have successfully gifted H! Rewards.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validate() {
    FocusScope.of(context).unfocus();
    String title = _textFieldControlTitle.controller.text.trim();
    if (title.isEmpty) {
      toastMessage('Please provide a title for your event');
      _textFieldControlTitle.focusNode.requestFocus();
    } else if (_dateTime.isBefore(DateTime.now())) {
      toastMessage('Please provide a valid date and time');
    } else {
      EventData.init(
          title, _dateTime, _textFieldControlCreatedBy.controller.text.trim());

      // Navigator.pushNamed(context, '/createEventStart');
      Get.to(() => TemplateCategoryListScreen());
    }
  }

  searchByEventId({String? typeOfGift}) {
   
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Container(
        child: TextField(
          keyboardType: TextInputType.number,
          controller: _textFieldControlEventIDSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: "Enter Event ID",
              suffix: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    int? serachedEventId = int.tryParse(
                        _textFieldControlEventIDSearch.text.trim());
                    FocusScope.of(context).unfocus();
                    _eventBloc.getEventBasedGift(eventId: serachedEventId);
                    
                  },
                  child: Text("Go"),
                ),
              )),
          onChanged: (val) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
