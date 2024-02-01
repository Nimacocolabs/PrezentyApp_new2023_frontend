import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/gateway_key_response.dart';
import 'package:event_app/models/hi_card/check_hi_card_balance_model.dart';
import 'package:event_app/models/hi_card/hi_card_earning_history_model.dart';
import 'package:event_app/models/hi_card/hi_card_redemption_history_model.dart';
import 'package:event_app/models/hi_card/hi_card_balance_model.dart';
import 'package:event_app/models/touchpoint_wallet_balance_response.dart';
import 'package:event_app/models/coin_transfer_history_model.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/screens/hi_card/hi_reward_info_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/getsucessupi.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/string_validator.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:event_app/widgets/common_date_editor_widget.dart';
import 'package:event_app/widgets/succes_or_failed_common_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/profile_bloc.dart';
import '../../models/coin_statement_response.dart';
import '../../models/hi_card/gift_hi_card_model.dart';
import '../../models/wallet&prepaid_cards/wallet_payment_order_details.dart';
import '../../network/api_response.dart';
import '../../util/user.dart';
import '../../widgets/CommonApiErrorWidget.dart';
import '../../widgets/CommonApiLoader.dart';
import 'package:dio/dio.dart' as dio;

import '../prepaid_cards_wallet/my_cards_wallet/Component/upiresponse.dart';

class HappyMomentsScreen extends StatefulWidget {
  const HappyMomentsScreen({Key? key}) : super(key: key);

  @override
  State<HappyMomentsScreen> createState() => _HappyMomentsScreenState();
}

class _HappyMomentsScreenState extends State<HappyMomentsScreen> {
  ProfileBloc _profileBloc = ProfileBloc();
  WalletBloc _walletBloc = WalletBloc();
  String? virtualAccountBalance;

  //List<CoinStatementModel>? coinStatement;
  final Rx<TextFieldControl> _textFieldControlFirstName =
      TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlLastName = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlPhoneNumber =
      TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlEmail = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlAmount = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlMessage = TextFieldControl().obs;
  int _tabIndex = 0;

  TouchPointWalletBalanceData? walletBalanceAmount;
  HiCardBalanceModel? hiCardDetails;
  bool? isPrepaidUser;
  bool isLoading = true;
  String accountId = User.userId;
  List<CoinStatementModel>? filteredStatementModel = [];
  final Rx<TextFieldControl> _textFieldControlAmountEntered =
      TextFieldControl().obs;
  late Razorpay _razorPay;
  WalletPaymentOrderDetails? paymentOrderDetails;

  bool refreshStatement = false;

  DateTime? fromD;
  DateTime? toD;
  String? fromDate;
  String? toDate;
  TextEditingController fromDateControl = TextEditingController();
  TextEditingController toDateControl = TextEditingController();
  bool isFromDateSelected = false;
  bool isToDateSelected = false;
  String? startDateValue;
  String? endDateValue;

  @override
  void initState() {
    super.initState();
    toD = DateTime.now();
    fromD = DateTime.now().subtract(Duration(days: 30));
    fromDateControl.text = _dateToString(fromD!);
    toDateControl.text = _dateToString(toD!);
    startDateValue = fromDateControl.value.text.trim();
    endDateValue = toDateControl.value.text.trim();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getHiCardData();
      _profileBloc = ProfileBloc();
      _walletBloc = WalletBloc();

      // _profileBloc.getCoinStatement(User.userId);
      // _profileBloc.coinTransferHistory(User.userId);
      _profileBloc.getHICardRedemptionHistory(
          User.userHiCardNo, User.userHiCardPin);
      _profileBloc.getHICardEarningHistory(
          User.userHiCardNo, User.userHiCardPin);
      _profileBloc.checkHiCardDetails(User.userHiCardNo, User.userHiCardPin);
      // getVirtualAccountBalance();
      //getWalletBalance();
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        if (msg == "AppLifecycleState.resumed") {
          // The app has resumed from the background
          // Call your API for status check here
         // String key = await _getGatewayKey();
          await getupcardsucess();
        }
        return null;
      });
    });
  }

  // getVirtualAccountBalance() async {
  //   virtualAccountBalance = await _profileBloc.getVirtualBalance(User.userId);
  //   setState(() {});
  // }

  // getWalletBalance() async {
  //   walletBalanceAmount =
  //       await _walletBloc.getTouchPointWalletBalance(accountId);
  //   setState(() {});
  // }

  getHiCardData() async {
    hiCardDetails = await _profileBloc.getHICardBalance(accountId);
    setState(() {});
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    _profileBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      //  AppBar(
      //   leading: BackButton(onPressed: () {
      //     Get.to(() => MainScreen());
      //   }),
      // ),
      appBar: CommonAppBarWidget(
          title: "",
          onPressedFunction: () {
            Get.back();
          },
          image: User.userImageUrl),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    image: AssetImage("assets/cards/hi_card.jpeg"),
                    width: double.infinity,
                    height: screenHeight * 0.3,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),

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
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(212, 228, 253, 3),
                            Color.fromRGBO(241, 206, 228, 3)
                          ]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6.0),
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
                                        borderRadius:
                                            BorderRadius.circular(12))),
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage("assets/images/hi_icon.png"),
                        fit: BoxFit.contain,
                        opacity: 0.4),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 120, bottom: 10),
                        child: Center(
                            child: Row(
                          children: [
                            Text(
                              "H! Rewards",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.to(() => HiRewardInfoScreen());
                                },
                                icon: Icon(Icons.info_outline_rounded)),
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(colors: [
                              Color.fromRGBO(122, 21, 71, 1),
                              Color.fromRGBO(171, 24, 99, 0.7)
                            ]),
                            border: Border.all(color: Colors.brown),
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            children: [
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(35.0),
                                child: Text(
                                  "${User.userHiCardBalance}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("1 H! Reward = ${rupeeSymbol}1",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontFamily: "Play",
                            )),
                      )
                    ],
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Card(
                //     elevation: 2,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20)),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       height: 60,
                //       padding:
                //           const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
                //       child: Row(
                //         children: [
                //           SizedBox(
                //             width: 5,
                //           ),
                //           Text(
                //             "Gift H! Card",
                //             style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 18,
                //               fontFamily: "KaushanScript-Regular",
                //             ),
                //           ),
                //           Spacer(),
                //           Container(
                //     height: 45,
                //     width: 150,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       gradient: LinearGradient(
                //         colors: [primaryColor,secondaryColor],
                //         begin: Alignment.centerLeft,
                //         end: Alignment.centerRight,
                //       ),
                //     ),
                //     child: OutlinedButton(
                //         style: OutlinedButton.styleFrom(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(12))),
                //         onPressed: () {
                //           detailsForm();
                //         },
                //         child: Text(
                //           "Gift Now!",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(fontSize: 16, color: Colors.white),
                //         )),
                //   ),

                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            if (_tabIndex == 0) return;
                            setState(() {
                              _tabIndex = 0;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: _tabIndex == 0
                                    ? Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: primaryColor,
                                            style: BorderStyle.solid))
                                    : null),
                            height: 70,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  'Earned',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (_tabIndex == 1) return;
                          setState(() {
                            _tabIndex = 1;
                          });
                        },
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              border: _tabIndex == 1
                                  ? Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: primaryColor,
                                          style: BorderStyle.solid))
                                  : null),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'Redeemed',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if (_tabIndex == 2) return;
                          setState(() {
                            _tabIndex = 2;
                          });
                        },
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              border: _tabIndex == 2
                                  ? Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: primaryColor,
                                          style: BorderStyle.solid))
                                  : null),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          // if (_tabIndex == 3) return;
                          // setState(() {
                          //   _tabIndex = 3;
                          // });
                          loadMoneyToHiCard();
                        },
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              border: _tabIndex == 3
                                  ? Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: primaryColor,
                                          style: BorderStyle.solid))
                                  : null),
                          child: Padding(
                            padding: EdgeInsets.all(13),
                            child: Center(
                              child: Text(
                                '     Buy\nRewards',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_tabIndex == 0 || _tabIndex == 1)
                  Row(
                    children: [
                      Expanded(
                          child: CommonDateEditorWidget(
                        field: "From",
                        labelText: _dateToString(fromD!),
                        control: fromDateControl,
                        suffixWid: _calenderDatePick(fromDate, fromD,
                            isFromDateSelected, fromDateControl),
                      )),
                      Expanded(
                        child: CommonDateEditorWidget(
                            field: "To",
                            labelText: _dateToString(toD!),
                            control: toDateControl,
                            suffixWid: _calenderDatePick(
                                toDate, toD, isToDateSelected, toDateControl)),
                      ),
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              refreshStatement = true;
                            });
                            _tabIndex == 0
                                ? await _profileBloc.getHICardEarningHistory(
                                    User.userHiCardNo,
                                    User.userHiCardPin,
                                    fromDate: fromDateControl.value.text
                                        .trim()
                                        .toString(),
                                    toDate: toDateControl.value.text
                                        .trim()
                                        .toString(),
                                  )
                                : await _profileBloc.getHICardRedemptionHistory(
                                    User.userHiCardNo,
                                    User.userHiCardPin,
                                    fromDate: fromDateControl.value.text
                                        .trim()
                                        .toString(),
                                    toDate: toDateControl.value.text
                                        .trim()
                                        .toString(),
                                  );

                            Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                refreshStatement = false;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.refresh_outlined,
                            color: primaryColor,
                          ))
                    ],
                  ),

                refreshStatement
                    ? SizedBox(
                        height: screenHeight - 320,
                        child: Center(child: CommonApiLoader()))
                    : Container(),

                IndexedStack(index: _tabIndex, children: [
                  SizedBox(
                    width: screenWidth,
                    child: StreamBuilder<ApiResponse<dynamic>>(
                        stream: _profileBloc.hiCardEarningHistoryStream,
                        builder: (context, snapshot) {
                          print("aaaa");
                          if (snapshot.hasData &&
                              snapshot.data?.status != null) {
                            switch (snapshot.data!.status!) {
                              case Status.LOADING:
                                print("ccccc");
                                return CommonApiLoader();
                              case Status.COMPLETED:
                                print("dddd");
                                HiCardEarningHistoryModel response =
                                    snapshot.data!.data!;

                                final productsResponse = response.data;

                                return Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10, bottom: 5),
                                        child: Text(
                                          "Earning Statement",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19,
                                          ),
                                        )),
                                    hiCardEarningHistoryTable(
                                        productsResponse!),
                                  ],
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
                  ),
                  // StreamBuilder<ApiResponse<dynamic>>(
                  //     stream: _profileBloc.coinStatementStream,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         switch (snapshot.data!.status!) {
                  //           case Status.LOADING:
                  //             return CommonApiLoader();
                  //           case Status.COMPLETED:
                  //             CoinStatementResponse? response =
                  //                 snapshot.data!.data;
                  //             return _buildTable(response!.statementModel);
                  //           case Status.ERROR:
                  //             return CommonApiErrorWidget(
                  //                 "${snapshot.data!.message!}", () {
                  //               _profileBloc.getCoinStatement(User.userId);
                  //             });
                  //         }
                  //       }
                  //       return SizedBox();
                  //     }),
                  // StreamBuilder<ApiResponse<dynamic>>(
                  //     stream: _profileBloc.coinTransferHistoryStream,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         switch (snapshot.data!.status!) {
                  //           case Status.LOADING:
                  //             return CommonApiLoader();
                  //           case Status.COMPLETED:
                  //             CoinTransferHistoryModel? response =
                  //                 snapshot.data!.data;
                  //             return coinTransferHistoryWidget(response!.data);
                  //           case Status.ERROR:
                  //             return CommonApiErrorWidget(
                  //                 "${snapshot.data!.message!}", () {
                  //               _profileBloc.coinTransferHistory(User.userId);
                  //             });
                  //         }
                  //       }
                  //       return SizedBox();
                  //     }),
                  SizedBox(
                    width: screenWidth,
                    child: StreamBuilder<ApiResponse<dynamic>>(
                        stream: _profileBloc.hiCardRedemptionHistoryStream,
                        builder: (context, snapshot) {
                          print("aaaa");

                          if (snapshot.hasData &&
                              snapshot.data?.status != null) {
                            switch (snapshot.data!.status!) {
                              case Status.LOADING:
                                print("ccccc");
                                return CommonApiLoader();
                              case Status.COMPLETED:
                                print("dddd");
                                HiCardRedemptionHistoryModel response =
                                    snapshot.data!.data!;

                                final productsResponse = response.data;

                                return Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10, bottom: 5),
                                        child: Text(
                                          "Redemption Statement",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19,
                                          ),
                                        )),
                                    hiCardRedemptionHistoryTable(
                                        productsResponse!)
                                  ],
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
                  ),
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: StreamBuilder<ApiResponse<dynamic>>(
                        stream: _profileBloc.hiCardDetailsStream,
                        builder: (context, snapshot) {
                          print("aaaa");
                          if (snapshot.hasData &&
                              snapshot.data?.status != null) {
                            switch (snapshot.data!.status!) {
                              case Status.LOADING:
                                print("ccccc");
                                return CommonApiLoader();
                              case Status.COMPLETED:
                                print("dddd");
                                CheckHiCardBalanceModel response =
                                    snapshot.data!.data!;

                                final productsResponse = response.data;

                                return cardDetailsWidget();
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
                  ),

                  // ] _tabIndex == 0
                  // ?
                  //     : _tabIndex == 1
                  //         ?

                  //             : Center(
                  //                 child: Text("Undefined"),
                  //               ),
                  // flex: 1,
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  cardDetailsWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(122, 21, 71, 1),
                  Color.fromRGBO(171, 24, 99, 0.7)
                ],
              ),
              borderRadius: BorderRadius.all(
                Radius.elliptical(20, 20),
              ),
              // color: Colors.grey.shade400,
            ),
            // padding: EdgeInsets.all(15),
            width: double.infinity,
            height: 250,
          ),
          Positioned(
              top: 30,
              left: 20,
              child: Text(
                "Card Number:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Positioned(
              top: 60,
              left: 20,
              child: Text(
                "${User.userHiCardNo}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Positioned(
              top: 100,
              left: 20,
              child: Text(
                "Card PIN:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Positioned(
              top: 130,
              left: 20,
              child: Text(
                "${User.userHiCardPin}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Positioned(
              top: 170,
              left: 20,
              child: Text(
                "H! Rewards:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
          Positioned(
              top: 200,
              left: 20,
              child: Text(
                "${User.userHiCardBalance}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ]),
      ),
    );
  }

  hiCardEarningHistoryTable(List<HiCardEarningHistoryData>? earningData) {
    if (earningData == null) {
      return CommonApiErrorWidget(
          "Something went wrong ", hiCardEarningHistoryTable);
    } else if (earningData.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Color.fromRGBO(122, 21, 71, 0.9)),
            dataRowColor: MaterialStateColor.resolveWith(
                (states) => Color.fromRGBO(171, 24, 99, 0.2)),
            columnSpacing: 15.0,
            columns: [
              DataColumn(
                label: Text(
                  "Sl.No",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "DESCRIPTION",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "REWARDS",
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "DATE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            rows: earningData
                .map(
                  (e) => DataRow(cells: [
                    DataCell(Container(
                      width: screenWidth * .1,
                      child: Text(
                        e.id.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    )),
                    DataCell(Container(
                      width: screenWidth * .3,
                      child: Text(
                        e.description ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    )),
                    DataCell(Container(
                      width: screenWidth * .1,
                      child: Text(
                        e.amount ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    )),
                    DataCell(
                      Container(
                        height: 40,
                        width: screenWidth * .2,
                        child: Center(
                          child: Text(
                            DateHelper.formatDateTime(
                                DateHelper.getDateTime(e.createdAt ?? ""),
                                'dd-MMM-yyyy hh:mm a'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  hiCardRedemptionHistoryTable(
      List<HiCardRedemptionHistoryData>? redemptionData) {
    if (redemptionData == null) {
      return CommonApiErrorWidget(
          "Something went wrong ", hiCardRedemptionHistoryTable);
    } else if (redemptionData.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    }

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
              (states) => Color.fromRGBO(122, 21, 71, 0.9)),
          dataRowColor: MaterialStateColor.resolveWith(
              (states) => Color.fromRGBO(171, 24, 99, 0.2)),
          columnSpacing: 15.0,
          columns: [
            DataColumn(
              label: Text(
                "Sl.No",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "DESCRIPTION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "REWARDS",
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "DATE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          rows: redemptionData
              .map(
                (e) => DataRow(cells: [
                  DataCell(Container(
                    width: screenWidth * .1,
                    child: Text(
                      e.id.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(Container(
                    width: screenWidth * .3,
                    child: Text(
                      e.description ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(Container(
                    width: screenWidth * .1,
                    child: Text(
                      e.amount ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(
                    Container(
                      height: 40,
                      width: screenWidth * .2,
                      child: Center(
                        child: Text(
                          DateHelper.formatDateTime(
                              DateHelper.getDateTime(e.createdAt ?? ""),
                              'dd-MMM-yyyy hh:mm a'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  detailsForm() {
    _textFieldControlFirstName.value.controller.clear();
    _textFieldControlLastName.value.controller.clear();
    _textFieldControlAmount.value.controller.clear();
    _textFieldControlEmail.value.controller.clear();
    _textFieldControlMessage.value.controller.clear();
    _textFieldControlPhoneNumber.value.controller.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: StatefulBuilder(
                builder: ((context, setState) => SafeArea(
                        child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: CloseButton()),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                        child: Text(
                                      "Enter the details",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    )),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Receiver\'s first name',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      enabled: true,
                                      textFieldControl:
                                          _textFieldControlFirstName.value,
                                      hintText: ' Receiver\'sFirst Name',
                                      keyboardType: TextInputType.name,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Receiver\'s last name',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      enabled: true,
                                      textFieldControl:
                                          _textFieldControlLastName.value,
                                      hintText: 'Receiver\'s last Name',
                                      keyboardType: TextInputType.name,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      ' Receiver\'s phone number',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      enabled: true,
                                      textFieldControl:
                                          _textFieldControlPhoneNumber.value,
                                      hintText: 'Receiver\'s phone number',
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      ' Receiver\'s  email address',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      enabled: true,
                                      textFieldControl:
                                          _textFieldControlEmail.value,
                                      hintText: 'Receiver\'s  email address',
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Amount',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      enabled: true,
                                      textFieldControl:
                                          _textFieldControlAmount.value,
                                      hintText: 'Amount',
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Message',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      enabled: true,
                                      textFieldControl:
                                          _textFieldControlMessage.value,
                                      hintText: 'Message',
                                      keyboardType: TextInputType.name,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 65, right: 65),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            validateDetails();

                                            //
                                          },
                                          child: Text("Submit")),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )))),
          );
        });
  }

  validateDetails() async {
    FocusScope.of(context).unfocus();
    String firstName = _textFieldControlFirstName.value.controller.text.trim();
    String lastName = _textFieldControlLastName.value.controller.text.trim();
    String email = _textFieldControlEmail.value.controller.text.trim();
    String phoneNumber =
        _textFieldControlPhoneNumber.value.controller.text.trim();
    String message = _textFieldControlMessage.value.controller.text.trim();
    String amountTyped = _textFieldControlAmount.value.controller.text.trim();
    if (firstName.isEmpty ||
        !firstName.isAlphabetOnly ||
        !firstName.isValidName()) {
      toastMessage("Enter your first name");
    } else if (lastName.isEmpty ||
        !lastName.isAlphabetOnly ||
        !lastName.isValidName()) {
      toastMessage("Enter your last name");
    } else if (!email.isValidEmail()) {
      toastMessage('Please provide a valid email address');
    } else if (!phoneNumber.isValidMobileNumber()) {
      toastMessage("Please provide a valid phone number");
    } else if (message.isEmpty) {
      toastMessage("Please provide a message");
    } else if (amountTyped.isEmpty) {
      toastMessage("Please provide an amount");
    } else if (amountTyped.characters.characterAt(0) == Characters("0")) {
      toastMessage("Please enter an amount greater than zero");
    } else if (int.tryParse(amountTyped)! < 100) {
      toastMessage("Please enter an amount greater than hundred");
    } else {
      GiftHiCardModel? giftHiCardData = await _profileBloc.giftHICard(
        accountId: User.userId,
        firstName: _textFieldControlFirstName.value.controller.text.trim(),
        lastName: _textFieldControlLastName.value.controller.text.trim(),
        phoneNumber: _textFieldControlPhoneNumber.value.controller.text.trim(),
        email: _textFieldControlEmail.value.controller.text.trim(),
        amount: _textFieldControlAmount.value.controller.text.trim(),
        message: _textFieldControlMessage.value.controller.text.trim(),
      );
      int? insTableId = giftHiCardData?.insTableId;

      if (giftHiCardData!.statusCode == 200) {
        String typedAmount =
            _textFieldControlAmount.value.controller.text.trim();
        requestPayment(
            accountId: User.userId,
            amount: typedAmount,
            insTableIdPassed: insTableId);
      }
    }
  }

  loadMoneyToHiCard() async {
    _textFieldControlAmountEntered.value.controller.clear();
    String typedHiAmount =
        _textFieldControlAmountEntered.value.controller.text.trim();

    await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: StatefulBuilder(
              builder: ((BuildContext context, setState) => SafeArea(
                    child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 2,
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: CloseButton()),
                              Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Center(
                                                child: Text(
                                              "Enter the amount to add to your H! card ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800),
                                            )),
                                            Divider(
                                              thickness: 2,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Minimum amount: ${rupeeSymbol} 100\nMaximum amount : ${rupeeSymbol} 10,000",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            AppTextBox(
                                              enabled: true,
                                              textFieldControl:
                                                  _textFieldControlAmountEntered
                                                      .value,
                                              hintText: 'Enter the amount',
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (v) {
                                                setState(() {
                                                  typedHiAmount = v;
                                                  print(
                                                      "setstate value =  ${typedHiAmount}");
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Equivalent rewards",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            AppTextBox(
                                              enabled: false,
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  "${typedHiAmount}",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (val) {
                                                setState(() {});
                                              },
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 65, right: 65),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    String typedAmount =
                                                        _textFieldControlAmountEntered
                                                            .value
                                                            .controller
                                                            .text
                                                            .trim();
                                                    validateAmount(typedAmount);
                                                  },
                                                  child: Text("Continue")),
                                            )
                                          ])))
                            ]),
                      ),
                    ),
                  )),
            ),
          );
        });
  }

  validateAmount(String typedAmount) async {
    FocusScope.of(context).unfocus();

    if (typedAmount.isEmpty) {
      toastMessage("Please enter an amount");
    } else if (int.tryParse(typedAmount)! < 100) {
      toastMessage("Please enter an amount greater than hundred");
    } else if (int.tryParse(typedAmount)! > 10000) {
      toastMessage("Please enter an amount less than ten thousand");
    } else {
      GiftHiCardModel? hiCardData = await _profileBloc.hiCardLoadMoney(
          accountId: User.userId,
          hiCardId: User.happyMomentId,
          amount: typedAmount);

      int? insTableId = hiCardData?.insTableId;
      String? decentro_txn_id = hiCardData?.decentro_txn_id;

      if (hiCardData?.statusCode == 200) {
        startLoadingMoney(
            accountId: User.userId,
            amount: typedAmount,
            insTableIdPassed: insTableId,
            dectaxid:decentro_txn_id,
        );
      }
    }
  }

  requestPayment(
      {String? accountId, String? amount, int? insTableIdPassed}) async {
    String amountEntered = amount!;
    String key = await getGatewayKey();
    if (key.isEmpty) {
      toastMessage('Unable to get payment key');
    } else {
      paymentOrderDetails = await _getGatewayOrderId(amountEntered);
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
            Get.offAll(() => MainScreen());
            _showSuccessDialog();
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
              "type": "HICARDGIFT",
              "user_id": User.userId,
              "ins_table_id": insTableIdPassed,
              // 'order_id': paymentOrderDetails?.orderId,
              //"gift_amount":amountEntered,
              "gift_amount": amountEntered,
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

  Future<UpiSucess?> getupcardsucess() async {
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upistatus}',
        data: {
          "txn_tbl_id": taxid,
        },
      );

      UpiSucess getupiResponse =
      UpiSucess.fromJson(response.data);



      // Check if the API call was successful before launching the URL
      if (getupiResponse.message=="SUCCESS") {
        showStatusAlertpending("${getupiResponse.message}");
        // Future.delayed(Duration(milliseconds: 500), () {
        //
        // });
        // Replace 'your_url_here' with the actual URL you want to launch
        // showStatusAlert("${getupiResponse.message}");
        // Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));

      }else{
        _showOrderRetryDialog();
      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
  void showStatusAlertpending(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },);
  }
  _showOrderRetryDialog() {
    //goToHomeScreen();
    Get.to(() => SuccessOrFailedScreen(isSuccess: false,content: "Unable to create happy moments.Please try again later.",));}
int? taxid;
  startLoadingMoney(
      {String? accountId, String? amount,dectaxid, int? insTableIdPassed}) async {
    String amountEntered = amount!;
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upilink}',
        options: Options(
          followRedirects: true,
        ),
        data: {
          "amount": amount,
          "type": "hi",
          "decentro_txn_id":dectaxid
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
    // //String key = await getGatewayKey();
    // if (key.isEmpty) {
    //   toastMessage('Unable to get payment key');
    // } else {
    //   print("the amount entered is ${amountEntered}");
    //   paymentOrderDetails = await _getGatewayOrderId(amountEntered);
    //   String orderId = paymentOrderDetails?.orderId ?? "";
    //
    //   if (orderId.isEmpty) {
    //     toastMessage('Unable to get order');
    //   } else {
    //     try {
    //       _razorPay = Razorpay();
    //       _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
    //           (PaymentSuccessResponse paymentSuccessResponse) {
    //         toastMessage('Payment successful');
    //         Get.close(2);
    //         Get.back();
    //         Get.to(() => SuccessOrFailedScreen(
    //             isSuccess: true,
    //             content:
    //                 "You have successfully loaded money to your H! card.\nEnjoy more features of H! card."));
    //
    //         Future.delayed(Duration(milliseconds: 100), () async {});
    //       });
    //       _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
    //           (PaymentFailureResponse paymentFailureResponse) {
    //         _onPaymentErrorFn(paymentFailureResponse);
    //       });
    //
    //       _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});
    //
    //       var options = {
    //         'key': key,
    //         "amount": paymentOrderDetails?.convertedAmount,
    //         'order_id': paymentOrderDetails?.orderId,
    //         'currency': "INR",
    //         'name': 'Prezenty',
    //         'description': 'Payment',
    //         'prefill': {
    //           'name': '${User.userName}',
    //           'contact': '${User.userMobile}',
    //           'email': '${User.userEmail}'
    //         },
    //         'notes': {
    //           "type": "LOADHICARD",
    //           "user_id": User.userId,
    //           "ins_table_id": insTableIdPassed,
    //           // 'order_id': paymentOrderDetails?.orderId,
    //           //"gift_amount":amountEntered,
    //           "load_amount": amountEntered,
    //           // 'state_code': permanentAddress ? permanentStateCode :stateCode ,
    //           // 'address': permanentAddress ? permanentAddressValue : addressControl.text,
    //         }
    //       };
    //
    //       debugPrint('options:' + jsonEncode(options));
    //
    //       _razorPay.open(options);
          return true;

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
    print("the amount dfd ${amountEntered}");
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

  _fetchFilteredCoinModel(
      String value, List<CoinStatementModel>? originalList) {
    List<CoinStatementModel>? results = [];
    if (value.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        results = filteredStatementModel;
      });
    } else {
      results = originalList!
          .where((data) =>
              data.id.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      filteredStatementModel = results;
    });
  }

  checkTransferPossible(CoinStatementModel coinData) async {
    if (coinData.redeemAmt == coinData.receivedAmt) {
      toastMessage("You dont have sufficient balance to transfer! ");
    } else if ((int.parse(coinData.redeemAmt!)) <
        ((int.parse(coinData.receivedAmt!)))) {
      FocusManager.instance.primaryFocus!.unfocus();
      await showTransferBottomSheet(coinData);

      // if (value != null) {
      //   if (int.parse(value) > int.parse(coinData.receivedAmt!))
      //     toastMessage("You dont have sufficient balance to transfer! ");
      //   else
      //     toastMessage("Success");
      // }
      // }
    }
  }

  Future showTransferBottomSheet(CoinStatementModel coinData) async {
    String _amount = '';
    String _pin = '';
    await Get.bottomSheet(
      Container(
        padding: MediaQuery.of(Get.context!).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 12,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: secondaryColor.shade200)),
                width: screenWidth * .7,
                child: TextField(
                  // autofocus: true,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+'), //users can't type 0 at 1st position
                    ),
                  ],
                  onChanged: (val) => _amount = val,
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
                    hintText: 'Enter the amount to transfer',
                    counterText: '',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                      child: Text(
                        '$rupeeSymbol',
                        style: TextStyle(
                            fontSize: 20, color: primaryColor.shade300),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: secondaryColor.shade200)),
                width: screenWidth * .7,
                child: TextField(
                  // autofocus: true,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (val) => _pin = val,
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
                      hintText: 'Enter Your Wallet Pin',
                      counterText: '',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 5)),
                ),
              ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            try {
                              double d = double.parse(_amount);

                              if (d < 0) {
                                toastMessage("Please provide a valid amount");
                              } else if (_pin == '') {
                                toastMessage("Please provide your wallet pin");
                              } else {
                                if (d >
                                    double.parse(
                                        coinData.balanceEvent.toString())) {
                                  toastMessage(
                                      "You dont have sufficient balance to transfer! ");
                                } else {
                                  AppDialogs.loading();
                                  try {
                                    String userid = User.userId.toString();
                                    String currentBalance =
                                        coinData.balanceEvent.toString();
                                    String eventId = coinData.id.toString();
                                    Map<String, dynamic> body = {
                                      'account_id': '$userid',
                                      'amount': '$d',
                                      'mpin': '$_pin',
                                      'current_balance': '$currentBalance',
                                      'event_id': '$eventId'
                                    };

                                    dio.FormData formData =
                                        dio.FormData.fromMap(body);

                                    CommonResponse response = await _profileBloc
                                        .transferCoinsToPrepaidCard(formData);

                                    print(response);
                                    print("25660");
                                    print(walletBalanceAmount!.walletBalance
                                        .toString());

                                    if (response.success!) {
                                      //  AppDialogs.closeDialog();
                                      //  Get.back();
                                      // _profileBloc
                                      //     .getCoinStatement(User.userId);
                                      //     _profileBloc.coinTransferHistory(User.userId);
                                      //     await _profileBloc.getVirtualBalance(User.userId);
                                      //      setState(()  {

                                      //      });
                                      toastMessage('${response.message}');
                                      Get.close(3);
                                      Get.to(HappyMomentsScreen());
                                    } else if (response.statusCode == 500) {
                                      toastMessage('${response.message}');

                                      setState(() {});
                                      AppDialogs.closeDialog();
                                      // Get.back();
                                    }
                                  } catch (e, s) {
                                    Completer().completeError(e, s);
                                    AppDialogs.closeDialog();
                                    Get.back();
                                    toastMessage(
                                        'Something went wrong. Please try again');
                                  }
                                  // toastMessage("Success");
                                }
                              }
                            } catch (e) {
                              toastMessage("Please provide valid details");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Transfer'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
    );
  }

  _buildTable(List<CoinStatementModel>? statementModel) {
    if (statementModel == null) {
      return CommonApiErrorWidget("Statement not available", () {
        _profileBloc.getCoinStatement(User.userId);
      });
    }

    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TextField(
              onChanged: (value) =>
                  _fetchFilteredCoinModel(value, statementModel),
              decoration: const InputDecoration(
                  labelText: 'Search by Event id ',
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(height: 8),
          filteredStatementModel!.isNotEmpty
              ? coinStatementListView(filteredStatementModel!)
              : coinStatementListView(statementModel)
        ],
      ),
    );
  }

  Widget coinStatementListView(List<CoinStatementModel> coinModelList) {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: coinModelList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Event Id : " +
                              (coinModelList[index].id ?? 0).toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Received : " +
                              (coinModelList[index].receivedAmt ?? "")
                                  .toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Redeemed : " +
                              (coinModelList[index].redeemAmt ?? "").toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Coin Transferred : " +
                              (coinModelList[index].coinTransferred ?? "")
                                  .toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Balance : " +
                              (coinModelList[index].balanceEvent ?? 0)
                                  .toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      coinModelList[index].balanceEvent == null ||
                              coinModelList[index].balanceEvent == 0
                          ? Container()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: () {
                                Get.to(() => WoohooVoucherListScreen(
                                      redeemData: RedeemData.giftRedeem(
                                          coinModelList[index].id,
                                          double.parse(coinModelList[index]
                                              .balanceEvent
                                              .toString())),
                                      showBackButton: true,
                                      showAppBar: true,
                                    ));
                              },
                              child: Text("Redeem")),
                      isPrepaidUser == true &&
                              (coinModelList[index].balanceEvent != null &&
                                  coinModelList[index].balanceEvent != 0)
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: () {
                                checkTransferPossible(coinModelList[index]);
                              },
                              child: Text("Transfer"))
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget coinTransferHistoryWidget(
      List<CoinTransferHistoryData>? transferHistoryModel) {
    if (transferHistoryModel == null) {
      return CommonApiErrorWidget("No transaction history to show.", () {
        _profileBloc.coinTransferHistory(accountId);
      });
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 8),
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: transferHistoryModel.length,
          itemBuilder: (context, index) {
            CoinTransferHistoryData transferData =
                transferHistoryModel[index] as CoinTransferHistoryData;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event Id : " + transferData.eventId.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Amount : " + transferData.amount.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Comment : " + transferData.comment.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Status : " + transferData.status.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Transferred date : " +
                                '${DateHelper.formatDateTime(DateHelper.getDateTime(transferData.createdAt.toString()), 'dd-MMM-yyyy  hh:mm a')}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
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
                    'You have successfully loaded money to your H! card.\nEnjoy more features of H! card.',
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

  String _dateToString(DateTime date) {
    String dateToString = "${date.year}-${date.month}-${date.day}";
    return dateToString;
  }

  _calenderDatePick(String? dateToString, DateTime? date, bool? isDateSelected,
      TextEditingController? dateControl) {
    return IconButton(
        icon: Icon(Icons.event, color: primaryColor),
        onPressed: () async {
          final datePick = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(1900),
              lastDate: new DateTime(2100));
          if (datePick != null && datePick != date) {
            setState(() {
              date = datePick;
              isDateSelected = true;

              // put it here
              dateToString =
                  "${date!.year}-${date!.month}-${date!.day}"; // 08/14/2019
              dateControl!.text = dateToString!;
            });
            FocusManager.instance.primaryFocus!.unfocus();
          }
        });
  }
}
