import 'dart:async';

import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/auth_mpin_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/forget_mpin_send_otp_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/set_wallet_pin_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class AuthMPinScreen extends StatefulWidget {
  const AuthMPinScreen({Key? key}) : super(key: key);

  @override
  State<AuthMPinScreen> createState() => _AuthMPinScreenState();
}

class _AuthMPinScreenState extends State<AuthMPinScreen> {
  WalletBloc _walletBloc = WalletBloc();

  String? mPin;

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
                SizedBox(
                  height: screenHeight * .1,
                ),
                Text(
                  "Enter Wallet PIN",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Wallet PIN",
                  style: TextStyle(
                      fontSize: 18,
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
                    onChanged:(pin){},
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    TextButton(
                      onPressed: () {
                        _forgetMPin();
                      },
                      child: Text(
                        "Forget PIN ?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      mPin != null
                          ? mPin!.length != 4
                              ? toastMessage("Enter full PIN")
                              : _authMPin(mPin!)
                          : toastMessage('Enter PIN');
                    },
                    child: Text(
                      "Authenticate",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

  Future _authMPin(String mPin) async {
    String accountId = User.userId;

    try {
      AuthMPinResponse response =
          await _walletBloc.authWalletPin(accountId, mPin);
           CommonResponse navigateResponse = await _walletBloc.walletNavigation(accountId);

      if (response.success! && navigateResponse.success!) {
        //await SharedPrefs.logIn(true, response);
        Get.to(() => WalletHomeScreen(isToLoadMoney: false,));
       // Get.offAll(() => ApplyPrepaidCardListScreen(isUpgrade: false,));
      } 
      else if(response.success! && !(navigateResponse.success!)){
Get.offAll(() => ApplyPrepaidCardListScreen(isUpgrade: false,));
      }
      else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();

      toastMessage('Something went wrong. Please try again');
    }
  }

  Future _forgetMPin() async {
    String accountId = User.userId;

    try {
      ForgetMPinSendOtpResponse response =
          await _walletBloc.forgetWalletPinSendOtp(accountId);

      if (response.success!) {
        toastMessage(response.message);

        Get.off(() => SetWalletPin(
              fromReset: true,
              otpReferenceId: response.data!.otp_reference_id,
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
}
