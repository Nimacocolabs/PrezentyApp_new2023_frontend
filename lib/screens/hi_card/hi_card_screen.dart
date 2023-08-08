import 'dart:async';
import 'dart:convert';


import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/gateway_key_response.dart';
import 'package:event_app/models/hi_card/check_hi_card_balance_model.dart';
import 'package:event_app/models/hi_card/gift_hi_card_model.dart';
import 'package:event_app/models/hi_card/hi_card_earning_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_payment_order_details.dart';
import 'package:event_app/network/api_error_message.dart';

import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';

import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/string_validator.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../network/api_response.dart';
import '../../util/user.dart';
import '../../widgets/CommonApiLoader.dart';
import '../../widgets/CommonApiResultsEmptyWidget.dart';

class HICardScreen extends StatefulWidget {
  const HICardScreen({Key? key}) : super(key: key);

  @override
  State<HICardScreen> createState() => _HICardScreenState();
}

class _HICardScreenState extends State<HICardScreen> {
  ProfileBloc _profileBloc = ProfileBloc();
  final Rx<TextFieldControl> _textFieldControlFirstName =
      TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlLastName = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlPhoneNumber =
      TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlEmail = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlAmount = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlMessage = TextFieldControl().obs;
  WalletPaymentOrderDetails? paymentOrderDetails;
  late Razorpay _razorPay;
   int _selectedTab=0;
    bool isDetailsScreen =true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _profileBloc = ProfileBloc();
        _profileBloc.checkHiCardDetails( User.userHiCardNo, User.userHiCardPin);
     _profileBloc.getHICardEarningHistory(
          User.userHiCardNo, User.userHiCardPin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () {
              Get.to(() => MainScreen());
            },
            color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: AssetImage("assets/cards/hi_card.jpeg"),
                  width: double.infinity,
                  height: screenHeight * 0.3,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Gift H! Card",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "KaushanScript-Regular",
                        ),
                      ),
                      Spacer(),
                      Container(
                height: 45,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Color.fromRGBO(122,21, 71, 1),Color.fromRGBO(171, 24, 99, 0.7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      detailsForm();
                    },
                    child: Text(
                      "Gift Now!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ),
              
                  
                   
                   
                    ],
                  ),
                ),
              ),
            ),
           
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
            height: 70,
            child:  Row(children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                  setState(() {
                    _selectedTab =0;
                    isDetailsScreen = true;
                  });
                    cardDetailsWidget();
                  },
                  borderRadius: BorderRadius.circular(10),
                  
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color:
                                    
                                    primaryColor,
                                
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
               Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                       onTap:(){
setState(() {
  _selectedTab=1;
});
print("theselected iS ${_selectedTab}");
                       },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                       
                          child: Text(
                            "Earnings",
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
                    ),
             
              Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                      onTap: (){
                        setState(() {
                          _selectedTab=2;
                        });
                      },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                        
                          child: Text(
                            "Redeemed",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                               
                                  Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                     Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                           setState(() {
                          _selectedTab=3;
                        });
                         loadMoneyToHiCard();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                         
                          child: Text(
                            "Top Up",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                 
                                  Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],)


            )),
        ),
        SizedBox(
          height: 20,
        ),
        // isDetailsScreen ?
        // cardDetailsWidget():Container(),
        IndexedStack(index: _selectedTab,children: [
           SizedBox(
                    width: screenWidth,
                    height: screenHeight,
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

                                return hiCardEarningHistoryTable(
                                    productsResponse!);

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
        ],)
      
       
          ],
        ),
      ),
    );
  }
cardDetailsWidget(){
  return  Padding(
          padding: const EdgeInsets.only(top: 0, left: 20, right: 20,bottom: 0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors:  [
                        Color.fromRGBO(49, 249, 152, 0.8),
                        Color.fromRGBO(159, 20, 211, 0.9)
                      ],),
              borderRadius: BorderRadius.all(
                Radius.elliptical(20, 20),
              ),
              // color: Colors.grey.shade400,
            ),
            // padding: EdgeInsets.all(15),
            width: double.infinity,
            height: screenHeight * 0.69,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
             
                
              ],
            ),
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
                "AMOUNT",
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
  loadMoneyToHiCard() async {
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
                                            Text("Minimum amount: ${rupeeSymbol} 100\nMaximum amount : ${rupeeSymbol} 10,000",
                                            style: TextStyle(color: Colors.red),
                                            ),
                                            AppTextBox(
                                              enabled: true,
                                              // textFieldControl:
                                              //     _textFieldControlAmountEntered
                                              //         .value,
                                              hintText: 'Enter the amount',
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 65, right: 65),
                                              child: ElevatedButton(
                                                  onPressed: () {
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
            Get.offAll(() => HICardScreen());
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
                    'Your gifting  completed successfully.\nAnd the card details will be sent to the provided email shortly.',
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
}
