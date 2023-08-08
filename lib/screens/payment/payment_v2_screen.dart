import 'dart:async';
import 'dart:convert';

import 'package:event_app/bloc/payment_bloc.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/screens/EventDeeplink/event_invite_details_screen.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/screens/event/send_food_create_order_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main_screen.dart';
import '../woohoo/woohoo_voucher_list_screen.dart';

class PaymentV2Screen extends StatefulWidget {
  final PaymentData paymentData;
  final RedeemData? redeemData;

  const PaymentV2Screen({Key? key, required this.paymentData, this.redeemData})
      : super(key: key);

  @override
  _PaymentV2ScreenState createState() => _PaymentV2ScreenState();
}

class _PaymentV2ScreenState extends State<PaymentV2Screen> {
  PaymentBloc _bloc = PaymentBloc();
  CountdownTimerController? controller;
  int endTime = 0;

  @override
  void initState() {
    super.initState();

    print(widget.paymentData.paymentType.toString());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.paymentData.paymentType == PaymentType.GIFT) {
        String s = await _bloc.getPaymentUpiLink(widget.paymentData);
        if (s.isEmpty) {
          _startTimer();
        } else {
          Get.back();
          _showPaymentFailedDialog(msg: s);
        }
      } else if (widget.paymentData.paymentType == PaymentType.FOOD) {
        if (widget.redeemData == null) {
          toastMessage('Redeem data not found');
          Get.back();
          return;
        }
        String s = await _bloc.getPaymentUpiLink(widget.paymentData);
        if (s.isEmpty) {
          _startTimer();
        } else {
          Get.back();
          _showPaymentFailedDialog(msg: s);
        }
      } else {
        toastMessage('Invalid payment type');
        Get.back();
      }
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
                    child: controller == null ||
                            widget.paymentData.paymentType == PaymentType.REDEEM
                        ? CommonApiLoader()
                        : Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text('Pay by UPI',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 30,
                              ),
                               Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 8, bottom: 8, right: 8),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/phonepe_upi.png'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, top: 8, bottom: 8, right: 8),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 60,
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
                                    radius: 30,
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/paytm.png'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, top: 8, bottom: 8, right: 8),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/bhim_upi.JPG'),
                                    ),
                                  ),
                                ),
                              ]),
                              // ClipRRect(
                              //     borderRadius: BorderRadius.circular(12),
                              //     child: Image.memory(base64Decode(_bloc
                              //         .paymentCreateUpiLinkResponse!
                              //         .detail!
                              //         .encodedDynamicQrCode!))),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                height:60,
                                width:150,
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
                                     
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                         onPressed: () async {
                                    String url = _bloc
                                            .paymentCreateUpiLinkResponse!
                                            .detail!
                                            .upiUri ??
                                        '';

                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      launchUrl(Uri.parse(url));
                                    } else {
                                      toastMessage('Unable to open apps');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Text(
                                        'Pay $rupeeSymbol${widget.paymentData.amount}',
                                        style: TextStyle(
                                          color:Colors.white
                                        ),
                                        ),
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

    _checkPaymentStatus();
  }

  // _createOrder()async{
  //   try {
  //     WoohooCreateOrderResponse? response = await _woohooBloc.createOrder( widget.woohooBody!,upiTransactionId: _bloc.paymentCreateUpiLinkResponse!.detail!.id!);
  //
  //     if (response == null) {
  //       _showDialog();
  //       return;
  //     }
  //
  //     if((response.success??false) && response.data!.status == 'COMPLETE' || response.data!.status == 'PROCESSING') {
  //       if(widget.paymentData.paymentType == PaymentType.FOOD){
  //         Get.offAll(()=>MainScreen());
  //         _showPaymentSuccessDialog(msg: 'Food voucher sent successfully');
  //       } else {
  //         Get.offAll(() => WoohooVoucherListScreen( redeemData: RedeemData.buyVoucher(), showBackButton: false));
  //         _showPaymentSuccessDialog(
  //             msg:
  //                 'Redeem successful.\nYour voucher will be shared to your email address');
  //       }
  //     } else{
  //       AppDialogs.message(response.data!.message??'Unable to create order');
  //       Get.offAll(()=>WoohooVoucherListScreen(redeemData: RedeemData.buyVoucher(),showBackButton:false));
  //     }
  //
  //   } catch (e, s) {
  //     _showDialog();
  //     Completer().completeError(e, s);
  //     toastMessage('Unable to create order');
  //   }
  // }

  // _showDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         content: Text('Unable to create order. Try again?'),
  //         actions: [
  //           OutlinedButton(
  //             child: Text('No'),
  //             onPressed: () {
  //               Get.back();
  //             },
  //           ),
  //           ElevatedButton(
  //             child: Text('Yes'),
  //             onPressed: () {
  //               Get.back();
  //               _createOrder();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  _checkPaymentStatus() {
    if (mounted) {
      Future.delayed(Duration(seconds: 3), () async {
        try {
          bool b = await _bloc.getPaymentStatus();

          if (b) {
            if (widget.paymentData.paymentType == PaymentType.GIFT) {
              Get.offAll(() => EventInviteDetailsScreen(
                  eventId: widget.paymentData.eventId));
              _showPaymentSuccessDialog(
                  msg: 'Your gift amount sent successfully');
            } 
            // else if (widget.paymentData.paymentType == PaymentType.FOOD) {
            //   toastMessage('Payment successful');

            //   Get.off(() => SendFoodCreateOrderScreen(
            //         redeemData: widget.redeemData!,
            //         upiTransactionId:
            //             _bloc.paymentCreateUpiLinkResponse!.detail!.id!,
            //       ));
            // }
          } else {
            _checkPaymentStatus();
          }
        } catch (e, s) {
          Completer().completeError(e, s);
          _checkPaymentStatus();
        }
      });
    }
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
                if (widget.paymentData.paymentType == PaymentType.GIFT) {
                  Get.offAll(() => EventInviteDetailsScreen(
                      eventId: widget.paymentData.eventId));
                } else if (widget.paymentData.paymentType == PaymentType.FOOD) {
                  Get.offAll(() => MainScreen());
                  Get.to(
                      () => MyEventScreen(eventId: widget.paymentData.eventId));
                }
              },
            ),
          ],
        );
      },
    );
  }
}

showTaxBottomSheet(
    BuildContext context, PaymentTaxResponse taxResponse, Function onTap) {
  bool isAgreed = false;
  String state = 'Kerala';
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (builder) {
        return StatefulBuilder(
            builder: (BuildContext context, setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Payment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Divider(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: taxResponse.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          taxResponse.data![index].key ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${taxResponse.data![index].value}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'State',
                            style: TextStyle(color: Colors.black54),
                          ),
                          DropdownButton<String>(
                            value: state,
                            isExpanded: true,
                            menuMaxHeight: 300,
                            underline: SizedBox(),
                            onChanged: (String? data) {
                              setState(() {
                                state = data!;
                              });
                            },
                            items:
                                states.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Checkbox(
                          value: isAgreed,
                          onChanged: (value) {
                            setState(() {
                              isAgreed = value ?? false;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(
                             left:2),
                        child: Text(
                          "I agree ",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(termsAndConditionsCardUrl))) {
                              await launchUrl(Uri.parse(termsAndConditionsCardUrl),mode: LaunchMode.externalApplication);
                            } else {
                              toastMessage(
                                  'Unable to open url $termsAndConditionsUrl');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left:5),
                            child: Text(
                              'Terms and Conditions',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if(isAgreed){
                         onTap(state);
                          }
                          else{
                         toastMessage("Please agree to Terms & Conditions to continue");
                          }
                          
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                              'Pay  $rupeeSymbol${taxResponse.amount ?? 0}'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ));
      });
}

class PaymentData {
  String amount;
  String account = '';
  String purpose;
  int eventId;
  String? userId;
  int? participantId;
  PaymentType? paymentType;
  String state = '';

  PaymentData.gift(
      {required this.amount,
      required this.account,
      required this.purpose,
      required this.participantId,
      required this.eventId}) {
    this.paymentType = PaymentType.GIFT;
  }

  PaymentData.food(
      {required this.amount,
      required this.account,
      required this.purpose,
      required this.userId,
      required this.eventId,
      required this.state}) {
    this.paymentType = PaymentType.FOOD;
  }
}
