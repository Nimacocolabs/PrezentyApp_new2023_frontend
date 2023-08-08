import 'dart:async';

import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/forgot_pass_send_otp_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/string_validator.dart';
import 'reset_password_otp_screen.dart';

class ResetPasswordEmailScreen extends StatefulWidget {
  final String? email;
  final bool isFromProfile;

  const ResetPasswordEmailScreen({Key? key, this.email, this.isFromProfile = false}) : super(key: key);

  @override
  _ResetPasswordEmailScreenState createState() =>
      _ResetPasswordEmailScreenState();
}

class _ResetPasswordEmailScreenState extends State<ResetPasswordEmailScreen> {
  AuthBloc _authBloc = AuthBloc();
  TextFieldControl _textFieldControlEmail = TextFieldControl();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _textFieldControlEmail.controller.text = widget.email!;
    }
  }

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
              height: 12,
            ),
            Text(
              'Email address',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            AppTextBox(
              textFieldControl: _textFieldControlEmail,
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
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
                      'Send OTP',
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
    String email = _textFieldControlEmail.controller.text.trim();
    if (!email.isValidEmail()) {
      toastMessage('Please provide a valid email address');
      _textFieldControlEmail.focusNode.requestFocus();
    } else {
      _sendOtp(email);
    }
  }

  _sendOtp(String email) async {
    AppDialogs.loading();

    try {
      ForgotPassSendOtpResponse response =
          await _authBloc.resetPasswordSendOtp(email);
      Get.back();
      if (response.success!) {
        Get.off(
            () => ResetPasswordOtpScreen(isFromProfile:widget.isFromProfile));
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage('Something went wrong. Please try again');
    }
  }
}
