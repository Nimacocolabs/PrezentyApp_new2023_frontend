import 'dart:async';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_verify_otp.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

// ignore: must_be_immutable
class ApplyKycVerifyOtpScreen extends StatefulWidget {
  ApplyKycVerifyOtpScreen({required this.verifyToken, Key? key}) : super(key: key);
  String verifyToken;

  @override
  State<ApplyKycVerifyOtpScreen> createState() => _ApplyKycVerifyOtpScreenState();
}

class _ApplyKycVerifyOtpScreenState extends State<ApplyKycVerifyOtpScreen> {
  final OtpFieldController otpControl = OtpFieldController();
  WalletBloc _walletBloc = WalletBloc();
  String? otp;
  bool visibleResendOtp = false;

  int _start = 180;
  int _countDown = 10;
  CountdownTimer? countDownTimer;

  void startTimer() {
    countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer!.listen(null);
    sub.onData((duration) {
      setState(() {
        _countDown = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      visibleResendOtp = true;
      sub.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    countDownTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight / 4,
            ),
            Text(
              "Enter OTP",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            VerticalDivider(width: screenWidth),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: screenWidth / 1.5,
              child: Text(
                "Please enter 6 digit code send on your Phone number or Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: screenWidth,

              /// 1.5,
              child: OTPTextField(
                //width: 10,
                keyboardType: TextInputType.number,
                fieldWidth: 50,
                style: TextStyle(fontSize: 18),
                outlineBorderRadius: 8,
                length: 6,

                onCompleted: (value) {
                  otp = value;
                },
                otpFieldStyle: OtpFieldStyle(
                    enabledBorderColor: primaryColor,
                    focusBorderColor: primaryColor,
                    borderColor: primaryColor,
                    disabledBorderColor: primaryColor),
                fieldStyle: FieldStyle.box,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                otp!.length != 6
                    ? toastMessage("Enter 6 digit OTP")
                    : _verifyOtp(otp: otp);
              },
              child: Text(
                "Verify",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: TextButton.styleFrom(
                backgroundColor: secondaryColor,
                fixedSize: Size(screenWidth, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                side: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: secondaryColor.withOpacity(.8)),
                primary: primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: !visibleResendOtp,
              child: Text(
                "Resend OTP in ${_countDown} sec..",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Visibility(
              visible: visibleResendOtp,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive the OTP?",
                      style: TextStyle(
                        height: 0,
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      )),
                  TextButton(
                    onPressed: () {
                      visibleResendOtp = false;
                      otp = "";
                      setState(() {});
                      startTimer();
                      _resendOtp();
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(" Resend",
                        style: TextStyle(
                          height: 0,
                          fontSize: 14,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  _resendOtp() async {
    try {
      AppDialogs.loading();
      RegisterWalletResponse response = await _walletBloc
          .registerWalletResendOtp(User.userId, widget.verifyToken);
      Get.back();
      if (response.success!) {
        toastMessage(response.message);
        print(response.data);
        Get.offAll(ApplyKycVerifyOtpScreen(
          verifyToken: response.data!.kycReferenceId!.toString(),
        ));
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  Future _verifyOtp({
    String? otp,
  }) async {
    Map<String, dynamic> body = {};
    body["account_id"] = User.userId;
    body["min_kyc_reference_id"] = widget.verifyToken;
    body["otp"] = otp;

    try {
      AppDialogs.loading();
      RegisterWalletVerifyOtp response =
          await _walletBloc.registerWalletVerifyOtp(body);
      Get.back();
      if (response.success??false) {
        countDownTimer?.cancel();
        Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
      } else {
        toastMessage(response.message??'Request failed');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }
}
