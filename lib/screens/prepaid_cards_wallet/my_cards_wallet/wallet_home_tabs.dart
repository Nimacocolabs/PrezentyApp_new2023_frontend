import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/touchpoint_wallet_balance_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoints_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/check_physical_card_exists_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/fetch_cvv_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/set_card_pin_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_details_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/fetch_cvv.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/merchants_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/set_pin.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/touch_points_history_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_date_editor_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

import 'wallet_home_statement.dart';

class WalletHomeTabs extends StatefulWidget {
  final WalletDetails? walletDetails;
  final CardDetails cardDetail;

  WalletHomeTabs({
    Key? key,
    required this.walletDetails,
    required this.cardDetail,
  }) : super(key: key);

  // String balance = '0';

  @override
  State<WalletHomeTabs> createState() => _WalletHomeTabsState();
}

class _WalletHomeTabsState extends State<WalletHomeTabs> {
   WalletBloc _walletBloc = WalletBloc();
  ProfileBloc _profileBloc = ProfileBloc();
  // int? tabCategory = 0;
  late bool showSetPinButton = false;
  final _setPinControl = TextEditingController();
  final _confirmPinControl = TextEditingController();
  final _resetPinControl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? fromDate;
  String? toDate;
  late DateTime toD; //= DateTime.now();
  late DateTime fromD; //= DateTime.now().subtract(Duration(days: 30));
  bool isFromDateSelected = false;
  bool isToDateSelected = false;
  late TextEditingController fromDateControl; // = TextEditingController();
  late TextEditingController toDateControl; // = TextEditingController();
  static final RegExp _dateRedExp =
      RegExp('^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])');
  String accountId = User.userId;

  final Rx<TextFieldControl> _textFieldControlTouchPointsEntered =
      TextFieldControl().obs;
           TouchPointWalletBalanceData? touchpointsData;
            CommonResponse? CardTypeResponse;

  @override
  void initState() {
       super.initState();
        fromDateControl = TextEditingController();
    toDateControl = TextEditingController();
    toD = DateTime.now();
    fromD = DateTime.now().subtract(Duration(days: 30));
    fromDateControl.text = _dateToString(fromD);
    toDateControl.text = _dateToString(toD);
       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _walletBloc = WalletBloc();
    _profileBloc = ProfileBloc();
    checkPhysicalCardExists(User.userId, widget.cardDetail.cardNumber);
   
   _walletBloc.getTouchPoints(accountId);
    getTPDetails();
       });
  
  }

  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _walletBloc.dispose();
  // }

  getCVV() async {
    String? url;
    FetchCardCvvResponse response =
        await _walletBloc.getCardCVV(User.userId, widget.walletDetails!.kitNo);
    url = response.data!.url;
    return url;
  }

  setCardPin() async {
    String? url;
    SetCardPinResponse response =
        await _walletBloc.setCardPin(User.userId, widget.walletDetails!.kitNo);
    url = response.data!.url;
    return url;
  }

  checkPhysicalCardExists(String? userId, String? cardNumber) async {
    CheckPhysicalCardExistsResponse response =
        await _walletBloc.checkPhysicalCardExists(userId, cardNumber);
    setState(() {
      showSetPinButton = response.success!;
      print("show set pin -->$showSetPinButton");
    });
  }
  getTPDetails() async {
    touchpointsData = await _walletBloc.getTouchPointWalletBalance(accountId);
    print("ghshgshshshs ${touchpointsData?.touchPoints}");
 setState(() {});
  }
//  touchPoints(String accountId) async{
//   CommonResponse touchPointsResponse = await _walletBloc.getTouchPoints(accountId);
//   return touchPointsResponse;
//  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  // onTap: (() => setState(() {
                  //       tabCategory = 0;
                  //     })),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    // width: (screenWidth / 4) - 5,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color:
                                    // tabCategory == 0
                                    //     ?
                                    primaryColor,
                                // : Colors.transparent,
                                style: BorderStyle.solid))),
                    child: Text(
                      "Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              // tabCategory == 0 ?
                              Colors.black87
                          // : Colors.grey,
                          ),
                    ),
                  ),
                ),
              ),
              showSetPinButton
                  ? Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          // setState(() {
                          //   tabCategory = 1;
                          // });
                          String url = await setCardPin();
                          Get.to(() => SetCardPin(url: url));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          // width: (screenWidth / 4) - 5,
                          // decoration: BoxDecoration(
                          //     border: Border(
                          //         bottom: BorderSide(
                          //             width: 2,
                          //             color: tabCategory == 1
                          //                 ? primaryColor
                          //                 : Colors.transparent,
                          //             style: BorderStyle.solid))),
                          child: Text(
                            "Set PIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  // tabCategory == 1 ? Colors.black87 :
                                  Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    // setState(() {
                    //   tabCategory = 2;
                    // });

                    String url = await getCVV();
                    Get.to(() => FetchCVVScreen(url: url));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    // width: (screenWidth / 4) - 5,
                    // decoration: BoxDecoration(
                    // border: Border(
                    //     bottom: BorderSide(
                    //         width: 2,
                    //         color: tabCategory == 2
                    //             ? primaryColor
                    //             : Colors.transparent,
                    //         style: BorderStyle.solid))
                    // ),
                    child: Text(
                      "CVV",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            // tabCategory == 2 ? Colors.black87 :
                            Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(10),
              //     onTap: () async {
              //       String currentBalance =widget.walletDetails!.balance.toString();
              //        String? value = await AppDialogs.inputAmountBottomSheet(
              //         "", "Enter the amount to be loaded into your wallet");
              //     if (value != null) {
                   
              //       Get.to(WalletPaymentScreen(
              //           accountid: User.userId, amount: value,availableWalletBalance: currentBalance,));
              //                          }


              //       // Get.to(() =>
              //       //     LoadWalletScreen(walletDetails: widget.walletDetails!));

              //       // setState(() {
              //       //   tabCategory = 3;
              //       // });
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(vertical: 17),
              //       // width: (screenWidth / 4) - 5,
              //       // decoration: BoxDecoration(
              //       // border: Border(
              //       // bottom: BorderSide(
              //       //     width: 2,
              //       //     color: tabCategory == 3
              //       //         ? primaryColor
              //       //         : Colors.transparent,
              //       //     style: BorderStyle.solid)
              //       // )
              //       // ),
              //       child: Text(
              //         "Load Money",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color:
              //               // tabCategory == 3 ? Colors.black87 :
              //               Colors.grey,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ]),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        _walletDetails(),
        // tabCategory == 0
        //     ? _walletDetails()
        // : tabCategory == 1
        //     ? Container()
        //     : tabCategory == 2
        //         ? Container() //_resetPin()
        //         : Container() //LoadMoney(),
      ],
    );
  }

  // Widget _setPinField() {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Form(
  //       key: _formKey,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "New 4 Digit PIN",
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black54),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           TextFormField(
  //             obscureText: true,
  //             controller: _setPinControl,
  //             inputFormatters: [
  //               LengthLimitingTextInputFormatter(4),
  //               FilteringTextInputFormatter.digitsOnly
  //             ],
  //             validator: (value) {
  //               return value!.isEmpty || value.length != 4
  //                   ? "Enter 4 Digit PIN"
  //                   : null;
  //             },
  //             keyboardType: TextInputType.number,
  //             cursorHeight: 24,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //             decoration: InputDecoration(
  //               hintText: "****",
  //               contentPadding: EdgeInsets.only(left: 10, right: 10),
  //               enabledBorder: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //               border: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 30,
  //           ),
  //           Text(
  //             "Confirm 4 Digit PIN",
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black54),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           TextFormField(
  //             obscureText: true,
  //             controller: _confirmPinControl,
  //             inputFormatters: [
  //               LengthLimitingTextInputFormatter(4),
  //               FilteringTextInputFormatter.digitsOnly
  //             ],
  //             validator: (value) {
  //               return value!.isEmpty || value.length != 4
  //                   ? "Enter 4 Digit PIN"
  //                   : value != _setPinControl.text
  //                       ? "PIN does'nt match"
  //                       : null;
  //             },
  //             keyboardType: TextInputType.number,
  //             cursorHeight: 24,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //             decoration: InputDecoration(
  //               hintText: "****",
  //               contentPadding: EdgeInsets.only(left: 10, right: 10),
  //               enabledBorder: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //               border: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 30,
  //           ),
  //           Center(
  //               child: TextButton(
  //             onPressed: () async {
  //               if (_setPinControl.text != _confirmPinControl.text) {
  //                 toastMessage("Pin doen't match");
  //                 return;
  //               }
  //               if (_formKey.currentState!.validate()) {
  //                 await _walletBloc.setCardPin(
  //                     User.userId, widget.cardDetail.kitNumber);
  //               }
  //             },
  //             child: Text(
  //               "Set PIN",
  //               style: TextStyle(fontSize: 16),
  //             ),
  //             style: TextButton.styleFrom(
  //               backgroundColor: secondaryColor,
  //               fixedSize: Size(screenWidth, 50),
  //             ),
  //           ))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _resetPin() {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Form(
  //       key: _formKey,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Old PIN",
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black54),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           TextFormField(
  //             controller: _resetPinControl,
  //             inputFormatters: [
  //               LengthLimitingTextInputFormatter(6),
  //               FilteringTextInputFormatter.digitsOnly
  //             ],
  //             validator: (value) {
  //               return value!.isEmpty || value.length != 6
  //                   ? "Enter Old 6 Digit PIN"
  //                   : null;
  //             },
  //             keyboardType: TextInputType.number,
  //             cursorHeight: 24,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //             decoration: InputDecoration(
  //               hintText: "******",
  //               contentPadding: EdgeInsets.only(left: 10, right: 10),
  //               enabledBorder: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //               border: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(),
  //               TextButton(
  //                   onPressed: () {},
  //                   child: Text(
  //                     "Forget PIN?",
  //                     style: TextStyle(
  //                         color: secondaryColor,
  //                         fontSize: 15,
  //                         fontWeight: FontWeight.bold),
  //                   ))
  //             ],
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Text(
  //             "New 6 Digit PIN",
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black54),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           TextFormField(
  //             controller: _setPinControl,
  //             inputFormatters: [
  //               LengthLimitingTextInputFormatter(6),
  //               FilteringTextInputFormatter.digitsOnly
  //             ],
  //             validator: (value) {
  //               return value!.isEmpty || value.length != 6
  //                   ? "Enter 6 Digit PIN"
  //                   : null;
  //             },
  //             keyboardType: TextInputType.number,
  //             cursorHeight: 24,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //             decoration: InputDecoration(
  //               hintText: "******",
  //               contentPadding: EdgeInsets.only(left: 10, right: 10),
  //               enabledBorder: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //               border: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 30,
  //           ),
  //           Text(
  //             "Confirm 6 Digit PIN",
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black54),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           TextFormField(
  //             controller: _confirmPinControl,
  //             inputFormatters: [
  //               LengthLimitingTextInputFormatter(6),
  //               FilteringTextInputFormatter.digitsOnly
  //             ],
  //             validator: (value) {
  //               return value!.isEmpty || value.length != 6
  //                   ? "Enter 6 Digit PIN"
  //                   : value != _setPinControl.text
  //                       ? "PIN does'nt match"
  //                       : null;
  //             },
  //             keyboardType: TextInputType.number,
  //             cursorHeight: 24,
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //             decoration: InputDecoration(
  //               hintText: "******",
  //               contentPadding: EdgeInsets.only(left: 10, right: 10),
  //               enabledBorder: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //               border: OutlineInputBorder(
  //                   gapPadding: 0,
  //                   borderRadius: BorderRadius.circular(10),
  //                   borderSide: BorderSide(width: 2, color: primaryColor)),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 30,
  //           ),
  //           Center(
  //               child: TextButton(
  //             onPressed: () {
  //               if (_formKey.currentState!.validate()) {}
  //             },
  //             child: Text(
  //               "Submit",
  //               style: TextStyle(fontSize: 16),
  //             ),
  //             style: TextButton.styleFrom(
  //               backgroundColor: secondaryColor,
  //               fixedSize: Size(screenWidth, 50),
  //             ),
  //           ))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _walletDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          width: screenWidth - 20,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(screenWidth)),
                  child: Center(
                    child: Text(
                      rupeeSymbol + widget.walletDetails!.balanceInfo!.balance.toString(),
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Available Balance",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
    //     Padding(
    //   padding: const EdgeInsets.all(5.0),
    //   child: Card(
    //     elevation: 2,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //     child: InkWell(
    //       onTap: (){
    //         Get.to(() => Wallet2WalletScreen());
    //       },
    //       child: Container(
    //         decoration: BoxDecoration(
    //           gradient: LinearGradient(colors: [
    //             primaryColor,secondaryColor
    //           ]),
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //         height: 60,
    //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
    //         child: Row(
    //           children: [
    //             SizedBox(
    //               width: 5,
    //             ),
    //             Text(
    //               "W2W Transfer",
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 18,
    //                 fontFamily: "KaushanScript-Regular",
    //               ),
    //             ),
    //             Spacer(),
    //             Container(
    //               height: 45,
    //               width: 150,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(15),
    //                   color: Colors.white),
    //               child: OutlinedButton(
    //                   style: OutlinedButton.styleFrom(
    //                       shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(12))),
    //                   onPressed: () {
    //                      Get.to(() => Wallet2WalletScreen());
    //                   },
    //                   child: Text(
    //                     "Transfer",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(fontSize: 16, color: Colors.black),
    //                   )),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //     Padding (
              //       padding: EdgeInsets.all(12),
              //       child:  Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Image(
              //         image: AssetImage('assets/images/trans prupee.png'),
              //         height: 30,
              //         width: 30,
              //       ),
              //       SizedBox(width: 8,),
              //       Expanded(
              //         child: Text(
              //           "Touch points",
              //           style: TextStyle(
              //             color: Colors.black87,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w500
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              StreamBuilder<ApiResponse<dynamic>>(
                  stream: _walletBloc.TouchPointStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return CommonApiLoader();
                        case Status.COMPLETED:
                          TouchPointsModel response = snapshot.data!.data!;
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/trans prupee.png'),
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${response.touchpoints}',
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Touch points",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Center(
                              //   child:Padding (
                              //     padding: EdgeInsets.all(14),
                              //     child: Text('${response.touchpoints}',
                              //     style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 18),),
                              //   ),
                              // ),
                              // SizedBox(height: 12,),
                              // Divider(height: 1),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Get.to(
                                              () => TouchPointsHistoryScreen());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("View History"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                         

                                                   CardTypeResponse =   await _walletBloc.getCustomerCardType(accountId);
                                                    if(CardTypeResponse?.statusCode == 500){
                                           transferTPBottomSheet();
                                                    }
                                                    else{
                                                      Get.to(() => MerchantListScreen() );
                                                    }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Transfer Touchpoints"),
                                             
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        case Status.ERROR:
                          return SizedBox(
                            height: 100,
                            child: Text(
                              "${snapshot.data!.message!}",
                            ),
                          );
                      }
                    }
                    return SizedBox();
                  }),
            ],
          )),
        ),
   
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            "Statement",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CommonDateEditorWidget(
                  field: "from",
                  labelText: _dateToString(fromD),
                  control: fromDateControl,
                  suffixWid: _calenderDatePick(
                      fromDate, fromD, isFromDateSelected, fromDateControl)),
            ),
            Expanded(
              child: CommonDateEditorWidget(
                  field: "to",
                  labelText: _dateToString(toD),
                  control: toDateControl,
                  suffixWid: _calenderDatePick(
                      toDate, toD, isToDateSelected, toDateControl)),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    refreshWalletStatement = true;
                  });
                  Future.delayed(Duration(milliseconds: 500), () {
                    setState(() {
                      refreshWalletStatement = false;
                    });
                  });
                },
                icon: Icon(
                  Icons.refresh_outlined,
                  color: primaryColor,
                ))
          ],
        ),
        refreshWalletStatement
            ? SizedBox(
                height: screenHeight - 320,
                child: Center(child: CommonApiLoader()))
            : WalletStatementList(
                fromDate: fromDateControl.text,
                toDate: toDateControl.text,
              ),
      ],
    );
  }

  transferTPBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          num eqValue = (int.tryParse(_textFieldControlTouchPointsEntered
                      .value.controller.text
                      .trim()) ??
                  0) /
              100;
       
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
                                              "Enter the touchpoints to be transferred ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800),
                                            )),
                                            Divider(
                                              thickness: 2,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Enter the touchpoints",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(height: 5,),
                                            Text("Mimimum touchpoints:100",
                                            style: TextStyle(color: Colors.black)),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            AppTextBox(
                                              enabled: true,
                                              textFieldControl:
                                                  _textFieldControlTouchPointsEntered
                                                      .value,
                                              hintText: 'Enter the touchpoints',
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (v) {
                                                setState(() {
                                                  eqValue =
                                                      (int.tryParse(v)! / 100);
                                                  print(
                                                      "setstate value =  ${eqValue}");
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Equivalent H! Rewards ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            AppTextBox(
                                              enabled: false,
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  "$rupeeSymbol: ${eqValue}",
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 65, right: 65),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    String enteredTP =
                                                        _textFieldControlTouchPointsEntered
                                                            .value
                                                            .controller
                                                            .text
                                                            .trim();

                                                    validation(
                                                        typedTP: enteredTP,equivalentAmount:eqValue );
                                                   

                                                    // String typedAmount =
                                                    //     _textFieldControlAmountEntered
                                                    //         .value
                                                    //         .controller
                                                    //         .text
                                                    //         .trim();
                                                    // validateAmount(typedAmount);
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

  validation({String? typedTP,num? equivalentAmount}) async {
  int? touchPointsGiven = int.tryParse(typedTP!);
   
    int? availableTp = int.tryParse(touchpointsData!.touchPoints);
   
if(typedTP.isEmpty){
  toastMessage("Please enter a valid touchpoint");
} else if(touchPointsGiven!< 100){
  toastMessage("Please enter the touchpoints greater than hundred");
}
     else if(touchPointsGiven > availableTp!){
      toastMessage("You dont have enough touchpoints to transfer");
    } else if(touchPointsGiven.isEqual(0)){
      toastMessage("Please enter touchpoints greater than zero");
    } else {
 CommonResponse? transferTPcata =
                                                        await _profileBloc
                                                            .transferTouchpointsToHicard(
                                                                accountId:
                                                                    User.userId,
                                                                touchPoints:
                                                                    typedTP,
                                                                amount: equivalentAmount
                                                                    .toString());
                                                    
                                                    if (transferTPcata
                                                            ?.statusCode ==
                                                        200) {
                                                      toastMessage(
                                                          "You have successfully sent the amount");
                                                      await Get.offAll(() =>
                                                          WalletHomeScreen(isToLoadMoney: false,));
                                                    } else if (transferTPcata
                                                            ?.statusCode ==
                                                        500) {
                                                      toastMessage(
                                                          "Something went wrong.Please try again later.");
                                                      await Get.offAll(() =>
                                                          WalletHomeScreen(isToLoadMoney: false,));
                                                    }
    }
    
    
  }

  bool refreshWalletStatement = false;

  String _dateToString(DateTime date) {
    String dateToString = "${date.year}-${date.month}-${date.day}";
    return dateToString;
  }



  _calenderDatePick(String? dateToString, DateTime? date, bool? isDateSelected,
      TextEditingController dateControl) {
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
              dateControl.text = dateToString!;
            });
            FocusManager.instance.primaryFocus!.unfocus();
          }
        });
  }
}
