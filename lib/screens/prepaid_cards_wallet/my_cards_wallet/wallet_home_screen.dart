import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/repositories/profile_repository.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/getsucessupi.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/set_pin.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/upiresponse.dart';
import 'package:event_app/services/dynamic_link_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/fetch_user_details_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/get_load_money_content.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_details_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/loadmoney_transaction_history_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/request_physical_card.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/load_money_wait_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_tabs.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_payment_screen.dart';
import 'package:event_app/screens/profile/profile_details_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/common_drawer_widget.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../models/block_card_response.dart';
import '../../../widgets/app_dialogs.dart';
import '../apply_prepaid_card_list_screen.dart';

class WalletHomeScreen extends StatefulWidget {
  final bool? isToLoadMoney;
  WalletHomeScreen({this.isToLoadMoney});

  @override
  State<WalletHomeScreen> createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  late WalletBloc _walletBloc;
  ProfileBloc _profileBloc = ProfileBloc();
  bool permanentAddress = true;
  String? accountId = User.userId;
  RxBool enableRequestPhysicalCard = false.obs;
  RxBool isCardExpanded = false.obs;
  String viewExpand = "More";
  fetchUserData? userData;
  bool? isLoadMyWallet;
  int selectedRadioValue = 1;
  WalletDetails? walletData;
  String? confirmWalletNumber;
  bool _passwordVisible = true;
  String? currentBalance;
  GetLoadMoneyContent? loadMoneyData;
  bool? prepaidCardUserOrNot;
  bool? prepaidCardUserOrNotToken;

  TextEditingController _textEditingControllerReceiverWalletNo =
  TextEditingController();
  TextEditingController _textEditingControllerConfrimReceiverWalletNo =
  TextEditingController();
  TextEditingController _textEditingControllerAmount = TextEditingController();
  TextEditingController _textEditingControllerLoadingAmount =
  TextEditingController();
  TextEditingController _textEditingControllerEventID = TextEditingController();
  String cardUrl = "";


  @override
  void initState() {
    super.initState();
    _walletBloc = WalletBloc();
    getPrepaidCardUserOrNotToken();
    getPrepaidCardUserOrNot();
    _profileBloc = ProfileBloc();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getWalletDetails();
      widget.isToLoadMoney ?? false
          ? Navigator.pushReplacement(context, loadMoneyWidget())
          : null;
    });
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == "AppLifecycleState.resumed") {
        // The app has resumed from the background
        // Call your API for status check here
        typeMapping[selectedRadioValue] =="self"?        await getupistatus(): await getupistatus1();

      }
      return null;
    });
  }

  _share () async {
    Uri url = await DynamicLinkService().createDynamic1Link();
    log(url.toString());
    await Share.share('You are invited to this${url.toString()}');
  }
  Future _getWalletDetails() async {
    walletData = await _walletBloc.getWalletDetails(User.userId);

    userData = await _walletBloc.fetchUserKYCDetails(accountId!);
    await _checkEnableRequestPhysicalCard();
    setState(() {});
  }

  getPrepaidCardUserOrNotToken() async {
    prepaidCardUserOrNotToken = await _profileBloc.tokencard(User.userId);
    setState(() {});
  }

  getPrepaidCardUserOrNot() async {
    prepaidCardUserOrNot = await _profileBloc.confirmWalletUser(User.userId);
    setState(() {});
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        if (_walletBloc.walletDetailsData != null)
          PopupMenuButton(
            // color:Colors.purple.shade100,
              offset: Offset(60, 50),
              icon: Icon(
                Icons.settings_outlined,
                size: 22,
                color: Colors.white,
              ),
              onSelected: (v) {
                if (v == 1) {
                  if (_walletBloc.walletDetailsData == null
                  // ||
                  // (_walletBloc.walletDetailsData?.cardDetails ?? [])
                  ) {
                    return;
                  }
                  Get.to(() => RequestPhysicalCard(
                    kitNumber: _walletBloc.walletDetailsData!.kitNo!,
                    cardNumber: _walletBloc
                        .walletDetailsData!.cardDetails!.cardNumber!,entityid: _walletBloc.walletDetailsData!.entityId!,

                  ));
                } else if (v == 2) {
                  _showBlockPopUp(context, _walletBloc.walletDetailsData,
                      _walletBloc.walletDetailsData!.cardDetails!);
                  print("scd=>${enableRequestPhysicalCard.value}");
                }
              },
              itemBuilder: (context) => [
                if (enableRequestPhysicalCard.value = true)
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Request Physical card",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                PopupMenuItem(
                  child: Text(
                    "Block and Replace your card",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  value: 2,
                ),
              ]),

        // IconButton(
        //     onPressed: () => Get.offAll(() => MainScreen()),
        //     icon: Image(
        //       image: AssetImage("assets/images/ic_home.png"),
        //       color: Colors.white,
        //       width: 20,
        //       height: 20,
        //     )),
        InkWell(
          onTap: () {
            Get.to(() => ProfileDetailsScreen());
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.black87,
              radius: 25,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: '${User.userImageUrl}',
                // '${userData?.baseUrl}${userData?.userDetails?.imageUrl}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Center(
                  child: Image(
                    image: AssetImage(
                      'assets/images/ic_avatar.png',
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        // CommonAppBarWidget(
        //       onPressedFunction: (){
        //         Get.back();
        //       },
        //       image: User.userImageUrl,
        //     ),
      ]),
      drawer: CommonDrawerWidget(),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: RefreshIndicator(
        onRefresh: _getWalletDetails,
        child: SingleChildScrollView(
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _walletBloc.getWalletDetailsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      return CommonApiLoader();

                    case Status.COMPLETED:
                      WalletDetailsResponse response = snapshot.data!.data!;

                      return _buildWalletDetails(response);

                    case Status.ERROR:
                      return CommonApiResultsEmptyWidget(
                          "${snapshot.data!.message!}",
                          textColorReceived: Colors.black);
                  }
                }
                return SizedBox();
              }),
        ),
      ),
    );
  }

  _buildWalletDetails(WalletDetailsResponse walletDetails) {
    return ListView(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // Text("My cards",
          //     style: TextStyle(
          //         color: Colors.black87,
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              isCardExpanded(!isCardExpanded.value);
            },
            child: Obx(
                  () => Column(
                children: [
                  AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: isCardExpanded.value
                          ? screenWidth * 1.5
                          : screenWidth * 0.5,
                      child: Stack(children: [
                        ClipRRect(
                          child: Image(
                            alignment: Alignment.topCenter,
                            fit: BoxFit.fitWidth,
                            height:
                            isCardExpanded.value ? screenHeight * 0.9 : 170,
                            image: AssetImage(
                                "assets/cards/prepaid_card_blank.png"),
                            width: screenWidth,
                          ),
                        ),
                        Positioned(
                          //right: 0,
                            left: screenWidth * .08,
                            top: screenWidth * .60,
                            child: Text(
                              '${walletDetails.walletDetails!.cardDetails!.cardNumber!.substring(0, 4)} ${walletDetails.walletDetails!.cardDetails!.cardNumber!.substring(4, 8)} ${walletDetails.walletDetails!.cardDetails!.cardNumber!.substring(8, 12)} ${walletDetails.walletDetails!.cardDetails!.cardNumber!.substring(12, 16)}\n\n${(userData?.cardname ?? "").toUpperCase()}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 22),
                            )),
                        Positioned(
                          //right: 0,
                            left: screenWidth * .18,
                            top: screenWidth * .95,
                            child: Text(
                              '${walletDetails.walletDetails!.cardDetails!.expiry}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 22),
                            )),
                        if (!isCardExpanded.value)
                          Positioned(
                            left: 100,
                            bottom: 30,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8,
                                        color: secondaryColor.shade100,
                                      )
                                    ]),
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                margin: EdgeInsets.only(top: 8, bottom: 0),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.keyboard_arrow_down_rounded),
                                      SizedBox(width: 1),
                                      Text('Tap to expand '),
                                      //SizedBox(width: 5),
                                    ])),
                          )
                        else
                          Positioned(
                            left: 90,
                            bottom: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 8,
                                      color: secondaryColor.shade100,
                                    )
                                  ]),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              margin: EdgeInsets.only(top: 8, bottom: 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard_arrow_down_rounded),
                                  //SizedBox(width: 1),
                                  Text('Tap to minimize '),
                                ],
                              ),
                            ),
                          ),
                      ]))
                ],
              ),
            ),
          ),

          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(top: 5, left: 10),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(50),
          //         child: CachedNetworkImage(
          //           width: 50,
          //           height: 50,
          //           fit: BoxFit.cover,
          //           imageUrl: '${User.userImageUrlValueNotifier.value}',
          //           placeholder: (context, url) => Center(
          //             child: CircularProgressIndicator(),
          //           ),
          //           errorWidget: (context, url, error) => Container(
          //             margin: EdgeInsets.all(5),
          //             child: Image(
          //               image: AssetImage('assets/images/ic_avatar.png'),
          //               height: double.infinity,
          //               width: double.infinity,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 12,
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(top: 30),
          //       child: Text(
          //         User.userName,
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                generateurl(
                    "${walletDetails.walletDetails!.entityId}",
                    "${walletDetails.walletDetails!.kitNo}",
                    "${walletDetails.walletDetails!.dob}");
              },
              child: Text(
                "View Card",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 60,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(walletDetails.walletDetails?.cardName ?? '',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    SizedBox(width: 10),
                    // FutureBuilder(
                    //   future: _walletBloc.getEnableUpgradeButton(User.userId,
                    //       walletDetails.walletDetails?.cardDetails?[0].c ?? 0),
                    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //     switch (snapshot.connectionState) {
                    //       case ConnectionState.waiting:
                    //         return Padding(
                    //           padding: const EdgeInsets.all(6.0),
                    //           child: Center(
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //         );
                    //       default:
                    //         if (snapshot.hasError || !snapshot.data)
                    //           return SizedBox();
                    //         else
                    //           return ElevatedButton(
                    //               child: Text('Upgrade'),
                    //               onPressed: () {
                    //                 Get.to(() => ApplyPrepaidCardListScreen(
                    //                     isUpgrade: true,
                    //                     currentCardId: walletDetails
                    //                             .data?.walletDetails?.cardId ??
                    //                         0));
                    //               });
                    //     }
                    //   },
                    // ),
                  ],
                ),
              )),
          SizedBox(
            height: 8,
          ),
          Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(212, 228, 253, 3),
                    Color.fromRGBO(241, 206, 228, 3)
                  ]),
                ),
                height: 60,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text('Wallet number',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500))),
                    SizedBox(width: 10),
                    Text(
                      "${walletDetails.walletDetails?.walletNumber}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                  ],
                ),
              )),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding:
            const EdgeInsets.only(top: 0, left: 6, right: 6, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              height: 180,
              child: Row(
                children: [
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 30),
                      child: InkWell(
                        onTap: () {
                          loadMoneyWidget();
                        },
                        child: Container(
                          color: Colors.grey.shade200,
                          height: 110,
                          width: 90,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, top: 8),
                            child: Center(
                              child: Text(
                                "\nLoad\nMoney",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -10,
                      left: 20,
                      child: InkWell(
                        onTap: () {
                          loadMoneyWidget();
                        },
                        child: Image(
                          image:
                          AssetImage('assets/images/load_money_image.png'),
                          width: 80,
                          height: 80,
                        ),
                      ),
                      // child: ShaderMask(
                      //   blendMode: BlendMode.srcIn,
                      //   shaderCallback: (Rect bounds) {
                      //     return LinearGradient(
                      //       colors: [primaryColor, secondaryColor],
                      //       tileMode: TileMode.mirror,
                      //     ).createShader(bounds);
                      //   },
                      //   child: Icon(
                      //     Icons.shopping_bag_outlined,
                      //     size: 60,
                      //   ),
                      // ),
                    ),
                  ]),
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 30),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => LoadMoneyTransactionHistoryScreen(
                            loadMoneyType: "event",
                          ));
                        },
                        child: Container(
                          color: Colors.grey.shade200,
                          height: 110,
                          width: 100,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "\nEvent Money\nHistory",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      left: 35,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => LoadMoneyTransactionHistoryScreen(
                            loadMoneyType: "event",
                          ));
                        },
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.event_note_rounded,
                            size: 70,
                          ),
                        ),
                        // child: Image(
                        //   image: AssetImage('assets/images/p2p_image.png'),
                        //   width: 80,
                        //   height: 80,
                        // ),
                      ),
                    )
                  ]),
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 30),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => LoadMoneyTransactionHistoryScreen(
                            loadMoneyType: "load",
                          ));
                        },
                        child: Container(
                          color: Colors.grey.shade200,
                          height: 110,
                          width: 110,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\nTransaction\n    History",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      left: 25,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => LoadMoneyTransactionHistoryScreen(
                            loadMoneyType: "load",
                          ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/loadmoney_transaction_history_image.png'),
                          width: 80,
                          height: 80,
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),
          WalletHomeTabs(
            walletDetails: walletDetails.walletDetails!,
            cardDetail: walletDetails.walletDetails!.cardDetails!,
          ),
          SizedBox(
            height: 50,
          ),
        ]);
  }

  // Future<bool> _showBlockPopUp(context) async {
  //   return await showDialog(
  //         //show confirm dialogue
  //         //the return value will be from "Yes" or "No" options
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Block Now ?'),
  //           titleTextStyle: TextStyle(
  //               fontSize: 24,
  //               fontWeight: FontWeight.bold,
  //               color: secondaryColor),
  //           content: const Text('Do you want to block and replace your card?'),
  //           contentTextStyle: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.normal,
  //               color: secondaryColor),
  //           actions: [
  //             ElevatedButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               //return false when click on "NO"
  //               child: const Text(
  //                 'No',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             ElevatedButton(
  //               // onPressed:() =>
  //               onPressed: () => _blockCard(accountId!),
  //               //Navigator.of(context).pop(true),
  //               //return true when click on "Yes"
  //               child: const Text(
  //                 'Yes',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false; //if showDialouge had returned null, then return false
  // }

  Future<bool> _showBlockPopUp(context, WalletDetails, CardDetails) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Card'),
        titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: secondaryColor),
        content: SizedBox(
          height: 300,
          child: Column(
            children: [
              Text(
                "Current Status : ${CardDetails!.status}",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Do you want to change the status in your card?'),
              SizedBox(
                height: 20,
              ),
              if (CardDetails!.status == "ALLOCATED")
                Column(
                  children: [
                    SizedBox(
                        width: screenWidth * 1,
                        child: ElevatedButton(
                            onPressed: () {
                              _blockCard(WalletDetails.entityId,WalletDetails.kitNo,"L","Card Lock");
                            }, child: Text("LOCK"))),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: screenWidth * 1,
                        child: ElevatedButton(
                            onPressed: () {
                              _blockCard(WalletDetails.entityId,WalletDetails.kitNo,"BL","Card Block");
                            }, child: Text("BLOCK"))),
                    if (CardDetails!.status == "BLOCKED")
                      SizedBox(
                          width: screenWidth * 1,
                          child: ElevatedButton(
                              onPressed: () {
                                _replaceCard(WalletDetails.entityId,WalletDetails.kitNo);
                              }, child: Text("REPLACE"))),
                  ],
                ),
              // if(CardDetails![0].status=="LOCKED")
              //   SizedBox(
              //       width: screenWidth * 1,
              //       child: ElevatedButton(
              //           onPressed: () {
              //             _blockCard(WalletDetails.entityId,WalletDetails.kitNo,"UL","Card Unlock");
              //           }, child: Text("UNLOCK"))),
            ],
          ),
        ),
        contentTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: secondaryColor),
        // actions: [
        //   ElevatedButton(
        //     onPressed: () => Navigator.of(context).pop(false),
        //     //return false when click on "NO"
        //     child: const Text(
        //       'No',
        //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        //   ElevatedButton(
        //     // onPressed:() =>
        //     onPressed: () => _blockCard(accountId!),
        //     //Navigator.of(context).pop(true),
        //     //return true when click on "Yes"
        //     child: const Text(
        //       'Yes',
        //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Wallet?'),
        // titleTextStyle: TextStyle(
        //     fontSize: 12,
        //     fontWeight: FontWeight.bold,
        //     color: secondaryColor),
        content: const Text('Do you want to exit Wallet?'),
        // contentTextStyle: TextStyle(
        //     // fontSize: 18,
        //     fontWeight: FontWeight.normal,
        //     color: secondaryColor),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: const Text(
              'No',
              // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.offAll(() => MainScreen()),
            //Navigator.of(context).pop(true),
            //return true when click on "Yes"
            child: const Text(
              'Yes',
              // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }

  _checkEnableRequestPhysicalCard() async {
    enableRequestPhysicalCard.value =
    await _walletBloc.checkEnableRequestPhysicalCard( _walletBloc.walletDetailsData!.entityId ?? '',
        _walletBloc.walletDetailsData!.cardDetails!.kitNo ?? '');
    setState(() {});
  }

  Future generateurl(String entityid, kit, dob) async {
    try {
      Map<String, dynamic> data = {
        "entity_id": "${entityid}",
        "kit_no": "${kit}",
        "dob": "${dob}"
      };
      final response = await http.post(
        Uri.parse(
            "https://prezenty.in/prezentycards-live/public/api/prepaid/cards/card-widget"),
        headers: {
          "Authorization": "Bearer ${TokenPrepaidCard}",
        },
        body: data,
      );
      Get.back(); // Close any existing dialogs

      print(response.body);

      if (response.statusCode == 200) {
        toastMessage(response.statusCode);

        Map jsonResponse = json.decode(response.body);
        cardUrl = jsonResponse['cardUrl'];
        print("entity->${cardUrl}");
        Get.to(() => ViewcardPin(url: cardUrl));
        // Show the cardUrl in a WebView
        // Get.dialog(
        //   AlertDialog(
        //     title: Text('Card Widget'),
        //     content: Container(
        //       width: 600,
        //       height: 600, // Adjust height as needed
        //       child: WebView(
        //         initialUrl: cardUrl,
        //         javascriptMode: JavascriptMode.unrestricted,
        //       ),
        //     ),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           // Close the dialog
        //           Navigator.pop(context);
        //         },
        //         child: Text('OK'),
        //       ),
        //     ],
        //   ),
        // );
      } else {
        toastMessage('${response.statusCode}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  Future<dynamic> _blockCard(String entityId,kitNo,flag,reason) async {
    AppDialogs.loading();
    Map<String, dynamic> data = {
      "entityId": "${entityId}",
      "flag":"${flag}",
      "kitNo": "${kitNo}",
      "reason": "${reason}"
    };

    try {
      BlockCardResponse response = await _walletBloc.blockCard(json.encode(data));
      Get.back();
      if (response.statusCode == 200) {
        Get.back();
        AppDialogs.message(
            "${response.message!}");
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  Future<dynamic> _replaceCard(String entityId,kitNo) async {
    AppDialogs.loading();
    Map<String, dynamic> data = {
      "entityId": "${entityId}",
      "oldKitNo": "${kitNo}",
    };

    try {
      BlockCardResponse response = await _walletBloc.replaceCard(json.encode(data));
      Get.back();
      if (response.statusCode == 200) {
        Get.back();
        AppDialogs.message(
            "${response.message!}");
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  loadMoneyWidget() {
    _textEditingControllerReceiverWalletNo.clear();
    _textEditingControllerConfrimReceiverWalletNo.clear();
    _textEditingControllerAmount.clear();
    _textEditingControllerLoadingAmount.clear();
    _textEditingControllerEventID.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: StatefulBuilder(
                builder: ((BuildContext context, setState) => SafeArea(
                    child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                  child: selectedRadioValue == 1 ||
                                      selectedRadioValue == 3
                                      ? Text("Load Money",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20))
                                      : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text("Load Money",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      IconButton(
                                          onPressed: () async {
                                            loadMoneyData =
                                            await _walletBloc
                                                .getLoadMoneyContent();
                                            Get.dialog(Center(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    8.0),
                                                child: Material(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(22),
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize
                                                          .min,
                                                      children: [
                                                        Text(
                                                          "${loadMoneyData?.data ?? ""}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        ElevatedButton(
                                                            onPressed:
                                                                () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                                "OK"))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ));
                                          },
                                          icon: Icon(
                                              Icons.info_outline_rounded))
                                    ],
                                  )),
                            ),
                            Text(
                              "NOTE: Your monthly load limit is ${rupeeSymbol} 10,000.",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900),
                            ),
                            widget.isToLoadMoney ?? false
                                ? Container()
                                : Divider(
                              thickness: 2,
                            ),
                            widget.isToLoadMoney ?? false
                                ? Container()
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("For IMPS",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Account Number : ${userData?.vaNumber ?? ""} ",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "IFSC Code : ${userData?.vaIfsc ?? 0} ",
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      dense: false,
                                      title: const Text(
                                        'Self',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      leading: Radio<int?>(
                                          value: 1,
                                          groupValue: selectedRadioValue,
                                          onChanged: (val) {
                                            setState(() {
                                              selectedRadioValue = val ?? 1;
                                              isLoadMyWallet = true;
                                              _textEditingControllerReceiverWalletNo
                                                  .clear();
                                              _textEditingControllerConfrimReceiverWalletNo
                                                  .clear();
                                              _textEditingControllerAmount.clear();
                                            });
                                          }),
                                    )),
                                Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      dense: false,
                                      title: const Text('Others ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                      leading: Radio<int?>(
                                          value: 2,
                                          groupValue: selectedRadioValue,
                                          onChanged: (v) {
                                            setState(() {
                                              selectedRadioValue = v ?? 2;
                                              isLoadMyWallet = false;
                                              _textEditingControllerLoadingAmount
                                                  .clear();
                                              _textEditingControllerLoadingAmount
                                                  .clear();
                                              _textEditingControllerReceiverWalletNo
                                                  .clear();
                                              _textEditingControllerConfrimReceiverWalletNo
                                                  .clear();
                                              _textEditingControllerAmount.clear();
                                              _textEditingControllerEventID.clear();
                                            });
                                          }),
                                    )),
                                // Expanded(
                                //     child: ListTile(
                                //   contentPadding: EdgeInsets.all(0),
                                //   dense: false,
                                //   title: const Text('To Event ',
                                //       style: TextStyle(
                                //           color: Colors.black,
                                //           fontWeight: FontWeight.w600)),
                                //   leading: Radio<int?>(
                                //       value: 3,
                                //       groupValue: selectedRadioValue,
                                //       onChanged: (v) {
                                //         setState(() {
                                //           selectedRadioValue = v ?? 3;
                                //           isLoadMyWallet = false;
                                //
                                //           _textEditingControllerLoadingAmount
                                //               .clear();
                                //           _textEditingControllerReceiverWalletNo
                                //               .clear();
                                //           _textEditingControllerConfrimReceiverWalletNo
                                //               .clear();
                                //           _textEditingControllerAmount.clear();
                                //         });
                                //       }),
                                // )),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            selectedRadioValue == 1
                                ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Enter the amount to be loaded to your wallet",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
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
                                    controller:
                                    _textEditingControllerLoadingAmount,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60, right: 60),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        int? loadingAmount = int.tryParse(
                                            _textEditingControllerLoadingAmount
                                                .value.text
                                                .trim());
                                        if (_textEditingControllerLoadingAmount
                                            .value.text.isEmpty) {
                                          toastMessage(
                                              "Please enter a valid amount");
                                        } else if (loadingAmount == 0) {
                                          toastMessage(
                                              "Enter an amount greater than zero");
                                        } else {
                                          showPaymentConfirmationDialog(context,loadingAmount.toString(),"");
                                          // _validate(
                                          //   type: "self",
                                          //   amountTyped:
                                          //       loadingAmount.toString(),
                                          // );
                                        }
                                      },
                                      child: Text("Load Money")),
                                )
                              ],
                            )
                                : selectedRadioValue == 3
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Enter the Event Id",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    validator: (v) {
                                      int? amountValue = int.tryParse(
                                          _textEditingControllerEventID
                                              .value.text
                                              .trim());
                                      if (_textEditingControllerEventID
                                          .value.text.isEmpty) {
                                        return "Enter an Event Id";
                                      }
                                    },
                                    controller:
                                    _textEditingControllerEventID,
                                    keyboardType:
                                    TextInputType.number,
                                  ),
                                )
                              ],
                            )
                                : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Enter the PhoneNo/Wallet Number",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    validator: (val) {
                                      if (_textEditingControllerReceiverWalletNo
                                          .value.text.isEmpty) {
                                        return "Wallet number cannot be empty";
                                      }
                                    },
                                    obscureText: !_passwordVisible,
                                    controller:
                                    _textEditingControllerReceiverWalletNo,
                                    keyboardType:
                                    TextInputType.number,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                !_passwordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons
                                                  .visibility_off,
                                            ))),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Confirm  PhoneNo/WWallet Number",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                !_passwordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons
                                                  .visibility_off,
                                            ))),
                                    keyboardType:
                                    TextInputType.number,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    controller:
                                    _textEditingControllerConfrimReceiverWalletNo,
                                    validator: (value) {
                                      if ((_textEditingControllerReceiverWalletNo
                                          .value.text
                                          .trim()) !=
                                          _textEditingControllerConfrimReceiverWalletNo
                                              .value.text
                                              .trim()) {
                                        return "Wallet number does not match";
                                      } else if (_textEditingControllerConfrimReceiverWalletNo
                                          .value.text.isEmpty) {
                                        return "Wallet number cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (selectedRadioValue == 2 ||
                                selectedRadioValue == 3)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Enter the amount to be loaded",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      validator: (v) {
                                        int? amountValue = int.tryParse(
                                            _textEditingControllerAmount
                                                .value.text
                                                .trim());
                                        if (_textEditingControllerAmount
                                            .value.text.isEmpty) {
                                          return "Amount cannot be empty";
                                        } else if (amountValue == 0) {
                                          return "Enter an amount greater than zero";
                                        }
                                      },
                                      decoration: InputDecoration(
                                          prefixText: "${rupeeSymbol}"),
                                      controller: _textEditingControllerAmount,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 140,
                                        right: 120,
                                        bottom: 5),
                                    child: ElevatedButton(
                                        onPressed: () {showPaymentConfirmationDialog1(context,     _textEditingControllerAmount
                                            .value.text
                                            .trim(),       _textEditingControllerConfrimReceiverWalletNo
                                            .value.text
                                            .trim(),);
                                          // _validate(
                                          //   receiverWalletNo:
                                          //       _textEditingControllerReceiverWalletNo
                                          //           .value.text
                                          //           .trim(),
                                          //   confrimWalletNo:
                                          //       _textEditingControllerConfrimReceiverWalletNo
                                          //           .value.text
                                          //           .trim(),
                                          //   amountTyped:
                                          //       _textEditingControllerAmount
                                          //           .value.text
                                          //           .trim(),
                                          //   eventIdTyped:
                                          //       _textEditingControllerEventID
                                          //           .value.text
                                          //           .trim(),
                                          //   type: selectedRadioValue == 3
                                          //       ? "event"
                                          //       : "others",
                                          // );
                                        },
                                        child: Text("Submit")),
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                    )))),
          );
        });
  }

  _validate(
      {String? receiverWalletNo,
        String? confrimWalletNo,
        String? amountTyped,
        String? eventIdTyped,
        String? type}) async {
    int? sendingAmount = int.tryParse(amountTyped!);
    print("laoding amount = ${amountTyped} and typevalue = ${type}");
    if (sendingAmount == null || sendingAmount == 0) {
      toastMessage("Please enter a valid amount");
      if (selectedRadioValue == 3) if (eventIdTyped!.isEmpty) {
        toastMessage("Please enter an Event Id");
      } else if (selectedRadioValue == 2) {
        if (receiverWalletNo!.isEmpty) {
          toastMessage("Please enter a wallet number");
        } else if (confrimWalletNo!.isEmpty) {
          toastMessage("Please retype the wallet number");
        } else if (receiverWalletNo != confrimWalletNo) {
          toastMessage("Wallet numbers doesnot match each other");
        } else if (selectedRadioValue == 1) {
          if (sendingAmount == null || sendingAmount == 0) {
            toastMessage("Please enter a valid amount");
          }
        }
      }
    } else {
      CommonResponse validateWalletData =
      await _walletBloc.validateWalletNumber(
        accountId: User.userId,
        walletNumber: receiverWalletNo ?? "",
        type: type,
        eventID: eventIdTyped,
        amount: amountTyped,
      );

      String? currentBalance = walletData?.balanceInfo?.balance.toString();
      if (validateWalletData.statusCode == 200) {

        // Get.off(WalletPaymentScreen(
        //   accountid: User.userId,
        //   amount: amountTyped,
        //   availableWalletBalance: currentBalance,
        //   walletNumber: validateWaletData.walletNumber,
        //   eventId: eventIdTyped,
        //   type: type,
        // )


      } else {
        toastMessage("${validateWalletData.message}");
      }
    }
  }
  void showPaymentConfirmationDialog1(BuildContext context,String amount,phnno) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Confirmation'),
          content: Text('Are you sure you want to make the payment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                await getupothercard(amount,phnno);
                //   Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
                // Perform the payment logic here
                // For example, you can call a function to initiate the payment
                // If the payment is successful, you can close the dialog
                // If the payment fails, you can show an error message or handle it accordingly
                // For this example, let's just close the dialog

              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();

              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  void showPaymentConfirmationDialog(BuildContext context,String amount,phnno) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Confirmation'),
          content: Text('Are you sure you want to make the payment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                await getupcard(amount,phnno);
                //   Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
                // Perform the payment logic here
                // For example, you can call a function to initiate the payment
                // If the payment is successful, you can close the dialog
                // If the payment fails, you can show an error message or handle it accordingly
                // For this example, let's just close the dialog

              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();

              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  int taxid= 0;
  String getamount = "";
  Map<int, String> typeMapping = {
    1: "self",
    2: "others",
    3: "event",
  };
  Future<paymentupiResponse?> getupcard(String amount,phno) async {
    try {
      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
          '${Apis.upilink}',
          data:
          {
            "amount": amount,
            "type": typeMapping[selectedRadioValue],
          }
      );

      paymentupiResponse getupiResponse =
      paymentupiResponse.fromJson(response.data);
      print("response->${getupiResponse}");
      taxid = getupiResponse.data!.txnTblId!;

      // Check if the API call was successful before launching the URL
      if (getupiResponse != null && getupiResponse.statusCode==200) {
        // Replace 'your_url_here' with the actual URL you want to launch
        String url = 'your_url_here';

        // Launch the URL
        await launch("${getupiResponse.data!.paymentLink}");


      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
  Future<paymentupiResponse?> getupothercard(String amount,phno) async {


    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upilink}',
        data:

        {
          "amount":amount,
          "type":typeMapping[selectedRadioValue],
          "wallet_number":phno,
          "wallet_number_confirmation":phno
        },

      );

      paymentupiResponse getupiResponse =
      paymentupiResponse.fromJson(response.data);
      print("response->${getupiResponse}");
      taxid = getupiResponse.data!.txnTblId!;

      // Check if the API call was successful before launching the URL
      if (getupiResponse != null && getupiResponse.statusCode==200) {
        // Replace 'your_url_here' with the actual URL you want to launch
        String url = 'your_url_here';

        // Launch the URL
        await launch("${getupiResponse.data!.paymentLink}");


      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

  Future<UpiSucess?> getupistatus() async {
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
          '${Apis.upistatus}',
          data:
          {
            "txn_tbl_id": taxid,
            "entity_id":_walletBloc.walletDetailsData!.entityId!,
            "type":"self"

          }

      );

      UpiSucess getupiResponse =
      UpiSucess.fromJson(response.data);
      print("response->${getupiResponse}");



      // Check if the API call was successful before launching the URL
      if (getupiResponse.message=="SUCCESS") {

        showStatusAlert("${getupiResponse.message}",getamount);


      }else{
        showStatusAlertpending("${getupiResponse.message}");
      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
  Future<UpiSucess?> getupistatus1() async {
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upistatus}',
        data:
        {
          "txn_tbl_id": taxid,
          "wallet_number": "${_textEditingControllerReceiverWalletNo.text}",
          "wallet_number_confirmation":_textEditingControllerConfrimReceiverWalletNo.text,
          "type":"others"
        },
      );

      UpiSucess getupiResponse =
      UpiSucess.fromJson(response.data);
      print("response->${getupiResponse}");



      // Check if the API call was successful before launching the URL
      if (getupiResponse.message=="SUCCESS") {

        showStatusAlertpending("${getupiResponse.message}",);


      }else{
        showStatusAlertpending("${getupiResponse.message}");
      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
  // Future<UpiSucess?> getupisucess(String amount) async {
  //   try {
  //
  //     final response = await ApiProviderPrepaidCards().getJsonInstancecard().post('${Apis.upistatusucsess}',
  //
  //       data: {
  //         "txn_tbl_id": taxid,
  //         "entityId": _walletBloc.walletDetailsData!.entityId!,
  //         "amount":amount
  //          },
  //
  //     );
  //
  //     UpiSucess getupiResponse =
  //     UpiSucess.fromJson(response.data);
  //     print("response->${getupiResponse}");
  //
  //
  //
  //     // Check if the API call was successful before launching the URL
  //     if (getupiResponse != null && getupiResponse.statusCode==200) {
  //       // Replace 'your_url_here' with the actual URL you want to launch
  //       showStatusAlert("${getupiResponse.message}",5);
  //
  //     }
  //
  //     else{
  //       showStatusAlert("${getupiResponse.message}","");
  //     }
  //
  //     return getupiResponse;
  //   } catch (e, s) {
  //     Get.back();
  //     Completer().completeError(e, s);
  //     toastMessage(ApiErrorMessage.getNetworkError(e));
  //   }
  //   return null;
  // }
  // Future<UpiSucess?> getupiotherssucess(String amount) async {
  //   try {
  //
  //     final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
  //       '${Apis.upitransferamount}',
  //       data:
  //            {
  //           "wallet_number":   "${_textEditingControllerReceiverWalletNo.text}",
  //           "wallet_number_confirmation":_textEditingControllerConfrimReceiverWalletNo.text,
  //           "amount":amount,
  //           "txn_tbl_id":taxid
  //           }
  //     );
  //
  //     UpiSucess getupiResponse =
  //     UpiSucess.fromJson(response.data);
  //     print("response->${getupiResponse}");
  //
  //
  //
  //     // Check if the API call was successful before launching the URL
  //     if (getupiResponse != null && getupiResponse.statusCode==200) {
  //       // Replace 'your_url_here' with the actual URL you want to launch
  //       showStatusAlert("${getupiResponse.message}",amount);
  //
  //     }
  //
  //     else{
  //       showStatusAlert("${getupiResponse.message}","");
  //     }
  //
  //     return getupiResponse;
  //   } catch (e, s) {
  //     Get.back();
  //     Completer().completeError(e, s);
  //     toastMessage(ApiErrorMessage.getNetworkError(e));
  //   }
  //   return null;
  // }
  void showStatusAlert(String message,amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                Get.to(WalletHomeScreen());
                // await  getupisucess(getamount);
              },
              child: Text('OK'),
            ),
          ],
        );
      },);
  }
  void showStatusAlert1(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                Get.to(WalletHomeScreen());
                // await  getupiotherssucess(getamount);
              },
              child: Text('OK'),
            ),
          ],
        );
      },);
  }
  void showStatusAlertpending(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Text(message+ "Try Again"),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                Get.offAll(WalletHomeScreen());
              },
              child: Text('OK'),
            ),
          ],
        );
      },);
  }
}