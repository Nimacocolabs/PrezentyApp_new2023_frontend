import 'dart:async';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/auth_mpin_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class SetWalletPin extends StatefulWidget {
  SetWalletPin({Key? key, this.fromReset = false, this.otpReferenceId})
      : super(key: key);
  final bool? fromReset;
  final int? otpReferenceId;

  @override
  State<SetWalletPin> createState() => _SetWalletPinState();
}

class _SetWalletPinState extends State<SetWalletPin> {
  WalletBloc _walletBloc = WalletBloc();

  String? mPin;
  String? confirmMPin;
  String? otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.fromReset!
                    ? Text(
                        "Reset Wallet PIN",
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        "Enter Wallet PIN",
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                SizedBox(
                  height: 70,
                ),
                widget.fromReset!
                    ? Column(
                        children: [
                          Text(
                            "Enter OTP",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                          VerticalDivider(width: screenWidth),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: screenWidth / 1.5,
                            child: Text(
                              "Please enter 4 digit code send on your Phone number or Email",
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
                            width: screenWidth / 1.5,
                            child: OTPTextField(
                              //width: 10,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false, decimal: false),
                              fieldWidth: 50,
                              style: TextStyle(fontSize: 18),
                              outlineBorderRadius: 8,
                              length: 4,
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
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Wallet PIN",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: OTPTextField(
                    obscureText: true,

                    width: screenWidth - 80,
                    keyboardType: TextInputType.number,
                    fieldWidth: 60,
                    style: TextStyle(fontSize: 18),
                    outlineBorderRadius: 8,
                    length: 4,
                    onCompleted: (pin) {
                      mPin = pin;
                    },
                    //controller: setMPinControl,
                    otpFieldStyle: OtpFieldStyle(
                        enabledBorderColor: primaryColor,
                        focusBorderColor: primaryColor,
                        borderColor: primaryColor,
                        disabledBorderColor: primaryColor),
                    fieldStyle: FieldStyle.box,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Confirm Wallet PIN",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: OTPTextField(
                    obscureText: true,
                    width: screenWidth - 80,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),

                    fieldWidth: 60,
                    style: TextStyle(fontSize: 18),
                    outlineBorderRadius: 8,
                    length: 4,
                    onCompleted: (pin) {
                      confirmMPin = pin;
                    },
                    //  controller: setMPinControl,
                    otpFieldStyle: OtpFieldStyle(
                        enabledBorderColor: primaryColor,
                        focusBorderColor: primaryColor,
                        borderColor: primaryColor,
                        disabledBorderColor: primaryColor),
                    fieldStyle: FieldStyle.box,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 70,
                  child: TextButton(
                    onPressed: () {
                      mPin != confirmMPin
                          ? toastMessage("PIN doesn't match")
                          : widget.fromReset!
                              ? _resetMPin(mPin!)
                              : _setMPin(mPin!);
                    },
                    child: Text(
                      "Set PIN",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _setMPin(String mPin) async {
    AppDialogs.loading();

    String accountId = User.userId;

    try {
      CommonResponse response = await _walletBloc.setWalletPin(accountId, mPin);

      Get.back();
      if (response.success??false) {
        // SharedPrefs.setBool(SharedPrefs.spMPin, true);
        Get.offAll(() => AuthMPinScreen());
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  Future _resetMPin(String mPin) async {
    AppDialogs.loading();

    String accountId = User.userId;

    try {
      CommonResponse response = await _walletBloc.resetWalletPinUpdateWalletPin(
        accountId,
        mPin,
        status: 1,
        otpReferenceId: widget.otpReferenceId!,
        otp: otp,
      );

      Get.back();
      if (response.success??false) {
        // SharedPrefs.setBool(SharedPrefs.spMPin, true);
        Get.offAll(() => AuthMPinScreen());
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }
}
