import 'dart:async';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/bloc/wallet_payment_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/qr_code_model.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/load_money_wait_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/succes_or_failed_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

import 'wallet_home_screen.dart';

class WalletPaymentScreen extends StatefulWidget {
  final String accountid;
  final String amount;
  String? availableWalletBalance;
  String? walletNumber;
  String? type;
  String? eventId;

  WalletPaymentScreen({
    Key? key,
    required this.accountid,
    required this.amount,
    this.availableWalletBalance,
    this.walletNumber,
    this.type,
    this.eventId,
  }) : super(key: key);

  @override
  State<WalletPaymentScreen> createState() => _WalletPaymentScreenState();
}

class _WalletPaymentScreenState extends State<WalletPaymentScreen> {
  WalletPaymentBloc _bloc = WalletPaymentBloc();
  WalletBloc _walletBloc = WalletBloc();
  CountdownTimerController? controller;
  WalletPaymentUpiResponse? walletPaymentUpiResponse;
  CommonResponse? transactionStatusData;
  QrCodeModel? upiDetails;

  DateTime? buttonClickedTime;

  int endTime = 0;
  Duration? diffTime;
  bool isPayButtonClicked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //  getTransactionStatusDetails();
      // String? upiData = await _walletBloc.walletUPIPayment(
      //     accountId: widget.accountid,
      //     amount: widget.amount,
      //     walletNumber: widget.walletNumber,
      //     type: widget.type);
      // if (upiData!.isEmpty) {
      //   _startTimer();
      // } else {
      //   Get.back();
      //   _showPaymentFailedDialog(msg: upiData);
      // }

      upiDetails = await _walletBloc.testWallet(
        accountId: widget.accountid,
        amount: widget.amount,
        walletNumber: widget.walletNumber,
        type: widget.type,
        eventId: widget.eventId,
      );
      if (upiDetails!.data!.upiUri!.isEmpty) {
        Get.back();
        _showPaymentFailedDialog(msg: upiDetails?.message ?? "");
      } else {
        _startTimer();
      }
      //await _bloc.getPaymentUpiLink(widget.accountid, widget.amount);
      // String s = await _bloc.getPaymentUpiLink(widget.accountid, widget.amount);
      // if (s.isEmpty) {
      //   _startTimer();
      // } else {
      //   Get.back();
      //   _showPaymentFailedDialog(msg: s);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: CloseButton(
            color: Colors.black54,
            // onPressed: (){},
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/ic_logo.png',
                height: 26,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Payment',
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(
                  height: 1,
                ),
                Expanded(
                  child: Center(
                    child: controller == null
                        ? CommonApiLoader()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text('Pay by UPI ',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60,
                                          top: 8,
                                          bottom: 8,
                                          right: 8),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 20,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/images/phonepe_upi.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 8, bottom: 8, right: 8),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 40,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/gpay_upi.jpg'),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 8, bottom: 8, right: 8),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 20,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/paytm.png'),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5,
                                          top: 8,
                                          bottom: 8,
                                          right: 15),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 20,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/bhim_upi.JPG'),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                              //  QrImage(
                              //   data: "${_bloc.walletPaymentUpiResponse?.upiUri ?? ""}",
                              //   version: QrVersions.auto,
                              //   size:300,
                              //   gapless: false,),
                              //  ClipRRect(
                              //      borderRadius: BorderRadius.circular(12),
                              //      child: Image.memory(base64Decode(_bloc.walletPaymentUpiResponse!.encodedDynamicQrCode!))),
                              //
                              // SizedBox(
                              //   height: 50,
                              // ),


                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 180,
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
                                        onPressed: () async {
                                          buttonClickedTime = DateTime.now();
                                          print("time == ${buttonClickedTime}");
                                          // String url = _bloc
                                          //         .walletPaymentUpiResponse
                                          //         ?.upiUri ??
                                          //     '';

                                          // String url = _walletBloc
                                          //         .walletPaymentUpiResponse
                                          //         ?.upiUri ??
                                          //     '';
                                          String url = upiDetails!.data!.upiUri
                                              .toString();

                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            launchUrl(Uri.parse(url),
                                                mode: LaunchMode
                                                    .externalNonBrowserApplication);

                                            checkTransactionStatus();
                                          } else {
                                            toastMessage('Unable to open apps');
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14.0, horizontal: 20),
                                          child: Text(
                                              'Pay  $rupeeSymbol${widget.amount}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                        )),
                                  ),
                                  SizedBox(height: 30),
                                  Text('Expires in'),
                                  CountdownTimer(
                                    controller: controller,
                                    endTime: endTime,
                                    widgetBuilder: (context, remainingTime) {
                                      if (remainingTime?.sec == null) {
                                        return Text('00 : 00',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500));
                                      }
                                      return Text(
                                        '${twoDigits(remainingTime?.min ?? 0)} : ${twoDigits(remainingTime?.sec ?? 0)}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: Get.height * .3,
                                child: isPayButtonClicked
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              height: 20,
                                              child: CommonApiLoader()),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Text(
                                            'Please do not press back or close the app',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  _startTimer() {
    endTime = DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch;
    controller = CountdownTimerController(endTime: endTime, onEnd: _onTimerEnd);
    setState(() {});

    //_checkPaymentStatus();
    // checkTransactionStatus();
  }

  checkTransactionStatus() async {
    setState(() {
      isPayButtonClicked = true;
    });

    bool? b = await checkTransactionStatus1();
    if (b != null) {
      if (mounted) {
        if (b) {
          Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
          Get.to(() => SuccessOrFailedScreen(
                isSuccess: true,
                content: "Payment completed successfully",
              ));
          //  _showPaymentSuccessDialog();
        } else {
          toastMessage(errorMsg);
          Get.off(() => SuccessOrFailedScreen(
                isSuccess: false,
                content: "${errorMsg}",
              ));
          //Get.offAll(() => WalletHomeScreen());
        }
      }
    }
  }

  String errorMsg = '';

  Future<bool?> checkTransactionStatus1() async {
    bool? status;
    try {
      CommonResponse transactionStatusData =
          await _walletBloc.walletLoadTransactionStatusCheck(
              accountId: widget.accountid,
              insTableId: upiDetails!.data!.insTableId.toString());

      if (transactionStatusData.statusCode == 200) {
        status = true;
      } else if (transactionStatusData.statusCode == 101) {
        status = false;
        errorMsg = "${transactionStatusData.message}";
      } else {
        await Future.delayed(Duration(seconds: 5));

        int diff = DateTime.now().difference(buttonClickedTime!).inMinutes;

       // int diff = buttonClickedTime!.difference(DateTime.now()).inSeconds;
print("time diff  =${diff}");
        if (diff >= 3) {
          Get.offAll(() => LoadMoneyWaitScreen());
          return null;
        } else {
          status = await checkTransactionStatus1();
        }
      }
    } catch (e, s) {
      Completer().completeError(e, s);

      //int diff = buttonClickedTime!.difference(DateTime.now()).inSeconds;
        int diff = DateTime.now().difference(buttonClickedTime!).inMinutes;

      if (diff >= 3) {
        Get.offAll(() => LoadMoneyWaitScreen());
        return false;
      } else {
        status = await checkTransactionStatus1();
      }
    }
    return status;
  }

  _checkPaymentStatus() {
    if (mounted) {
      Future.delayed(Duration(seconds: 10), () async {
        try {
          CommonApiLoader();
          toastMessage("Please wait .Donot close the window or click the back");
          //AppDialogs.loading();
          // bool b = await _bloc.getPaymentStatus(widget.accountid,widget.availableWalletBalance ?? "");
          //AppDialogs.closeDialog();
          // if (b) {

          // Get.offAll(() => WalletHomeScreen());
          // _showPaymentSuccessDialog();
          // } else {
          //  // AppDialogs.closeDialog();
          //   _checkPaymentStatus();
          // }
        } catch (e, s) {
          Completer().completeError(e, s);
          _checkPaymentStatus();
        }
      });
    }
  }

  _showPaymentFailedDialog({String msg = 'Payment failed'}) {
    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: Colors.red.shade300,
                    size: 70,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '$msg',
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

  _onTimerEnd() {
    Get.back();
    _showPaymentFailedDialog(
        msg: 'Payment timed out.\nContact PreZenty team for any support');
  }

  @override
  void dispose() {
    if (controller != null) {
      if (controller!.isRunning) controller!.disposeTimer();

      controller!.dispose();
    }
    super.dispose();
  }

  _showPaymentSuccessDialog({String msg = 'Payment completed successfully'}) {
    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                    msg,
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

  _onBack() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Are you sure want to cancel the payment?'),
          actions: [
            OutlinedButton(
              child: Text('No'),
              onPressed: () {
                Get.back();
              },
            ),
            SizedBox(
              width: 8,
            ),
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () async {
                Get.close(2);
              },
            ),
          ],
        );
      },
    );
  }
}