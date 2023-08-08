import 'dart:async';

import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/forgot_pass_update_pass_response.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/string_validator.dart';
import '../main_screen.dart';

class ResetPasswordUpdatePasswordScreen extends StatefulWidget {
  final int accountId;
  final String passwordResetToken;
  final bool isFromProfile;

  const ResetPasswordUpdatePasswordScreen(
      {Key? key, required this.accountId, required this.passwordResetToken, this.isFromProfile=false})
      : super(key: key);

  @override
  _ResetPasswordUpdatePasswordScreenState createState() =>
      _ResetPasswordUpdatePasswordScreenState();
}

class _ResetPasswordUpdatePasswordScreenState
    extends State<ResetPasswordUpdatePasswordScreen> {
  AuthBloc _authBloc = AuthBloc();
  TextFieldControl _textFieldControlPassword = TextFieldControl();
  TextFieldControl _textFieldControlRetypePassword = TextFieldControl();

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
              'Password',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            AppTextBox(
              textFieldControl: _textFieldControlPassword,
              prefixIcon: Icon(Icons.lock_outlined),
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Retype Password',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            AppTextBox(
              textFieldControl: _textFieldControlRetypePassword,
              prefixIcon: Icon(Icons.lock_outlined),
              hintText: 'Password',
              obscureText: true,
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
                      'Reset Password',
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
    String password = _textFieldControlPassword.controller.text;
    String password2 = _textFieldControlRetypePassword.controller.text;
    if (!password.isValidPassword()['isValid']) {
      toastMessage(password.isValidPassword()['message']);
      _textFieldControlPassword.focusNode.requestFocus();
    } else if (!password2.isValidPassword()['isValid']) {
      toastMessage(password.isValidPassword()['message']);
      _textFieldControlRetypePassword.focusNode.requestFocus();
    } else if (password != password2) {
      toastMessage('Password mismatch');
      _textFieldControlRetypePassword.focusNode.requestFocus();
    } else {
      _updatePassword(password);
    }
  }

  _updatePassword(String password) async {
    AppDialogs.loading();

    try {
      ForgotPassUpdatePassResponse response =
          await _authBloc.resetPasswordUpdatePassword(
              widget.accountId, widget.passwordResetToken, password);
      Get.back();
      if (response.result?[0].accountId == widget.accountId) {
        toastMessage(response.message ?? 'Password updated');
        if(widget.isFromProfile){
          Get.offAll(() =>
              MainScreen(
                showTab: 1,
              ));
        }else {
          Get.offAll(() =>
              LoginScreen(
                isFromWoohoo: false,
              ));
        }
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
