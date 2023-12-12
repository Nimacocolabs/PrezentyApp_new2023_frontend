import 'dart:async';
import 'dart:developer';

import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/forgot_pass_verify_otp_response.dart';
import 'package:event_app/screens/login/reset_password_update_password.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';


class ResetPasswordOtpScreen extends StatefulWidget {
  final bool isFromProfile;

  const ResetPasswordOtpScreen({Key? key, this.isFromProfile=false}) : super(key: key);

  @override
  _ResetPasswordOtpScreenState createState() => _ResetPasswordOtpScreenState();
}

class _ResetPasswordOtpScreenState extends State<ResetPasswordOtpScreen> {
  AuthBloc _authBloc = AuthBloc();
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: secondaryColor,),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                'Reset\nPassword',
                style: TextStyle(
                    // color: color1,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 11,
            ),
            Text(
              'OTP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            OTPTextField(
              length: 4,
              fieldWidth: 50,
              style: TextStyle(fontSize: 16),
              textFieldAlignment: MainAxisAlignment.center,
              fieldStyle: FieldStyle.box,
              onCompleted: (pin) {
                otp = pin;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Material(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: secondaryColor,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  padding: EdgeInsets.all(14),
                  child: Center(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                onTap: _validate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validate() {
    FocusScope.of(context).unfocus();
    log('otp:$otp');
    if (otp.length != 4) {
      toastMessage('Input valid OTP');
    } else {
      _verifyOtp();
    }
  }

  _verifyOtp() async {
    try {
      ForgotPassVerifyOtpResponse response = await _authBloc.resetPasswordVerifyOtp(otp);
      if ((response.result?.otpVerified ?? 0) == 1) {
        Get.off(() => ResetPasswordUpdatePasswordScreen(
            accountId: (response.result?.accountId ?? 0),
            passwordResetToken: (response.result?.passwordResetToken ?? ''),
          isFromProfile: widget.isFromProfile,
          ),
        );
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
       Completer().completeError(e, s);
      toastMessage('Something went wrong. Please try again');
    }
  }
}
