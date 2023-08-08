import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/string_validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextFieldControl _textFieldControlOldPassword = TextFieldControl();
  TextFieldControl _textFieldControlNewPassword = TextFieldControl();
  TextFieldControl _textFieldControlConfirmPassword = TextFieldControl();

  ProfileBloc _bloc = ProfileBloc();

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userTypedCurrentPassword = '';
  String _userTypedNewPassword = '';
  String _userTypedConfirmPassword = '';

  // bool _showPassword = false;
  bool _autoValidate = false;

  bool _obscureCurrentPasswordText = true;
  bool _obscureNewPasswordText = true;
  bool _obscureConfirmPasswordText = true;

  // @override
  // ignore: must_call_super

  void _toggleCurrentPassword() {
    setState(() {
      _obscureCurrentPasswordText = !_obscureCurrentPasswordText;
    });
  }

  void _toggleNewPassword() {
    setState(() {
      _obscureNewPasswordText = !_obscureNewPasswordText;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPasswordText = !_obscureConfirmPasswordText;
    });
  }

  _validateUserCurrentPassword(String passsword) {
    if (passsword.length == 0) {
      return 'Current password can\'t be empty';
    } else if (passsword.length > 0 && passsword.length < 6) {
      return 'Current password must contain atleast 6 characters';
    }
    return null;
  }

  _validateUserNewPassword(String newPasssword) {
    if (newPasssword.length == 0) {
      return 'New password can\'t be empty';
    } else if (newPasssword.length > 0 && newPasssword.length < 6) {
      return 'New password must contain atleast 6 characters';
    } else if (_userTypedCurrentPassword != null &&
        _userTypedCurrentPassword.length > 0) {
      if (_userTypedCurrentPassword == newPasssword) {
        return 'New and current password must not be same';
      }
    } else if (_userTypedConfirmPassword != null &&
        _userTypedConfirmPassword.length > 0) {
      if (_userTypedConfirmPassword != newPasssword) {
        return 'New and Confirm password must be same';
      }
    }
    return null;
  }

  _validateUserConfirmPassword(String confirmPasssword) {
    if (confirmPasssword.length == 0) {
      return 'Confirm password can\'t be empty';
    } else if (confirmPasssword.length > 0 && confirmPasssword.length < 6) {
      return 'Confirm password must contain atleast 6 characters';
    } else if (_userTypedNewPassword != null &&
        _userTypedNewPassword.length > 0) {
      if (_userTypedNewPassword != confirmPasssword) {
        return 'New and Confirm password must be same';
      }
    }
    return null;
  }

  void callApiToChangePassword() async {
    if (_userTypedConfirmPassword.length == 0) {
      toastMessage('password can\'t be empty');
    } else if (_userTypedConfirmPassword.length > 0 &&
        _userTypedConfirmPassword.length < 6) {
      toastMessage('password must contain atleast 6 characters');
    } else if (_userTypedNewPassword != null &&
        _userTypedNewPassword.length > 0) {
      if (_userTypedNewPassword != _userTypedConfirmPassword) {
        toastMessage('New and Confirm password must be same');
      } else {
        AppDialogs.loading();
        try {
          Map<String, dynamic> body = {
            'old_password': '$_userTypedCurrentPassword',
            'password': '$_userTypedConfirmPassword',
          };

          dio.FormData formData = dio.FormData.fromMap(body);

          CommonResponse response = await _bloc.changePassword(formData);

          if (response.success!) {
            toastMessage('${response.message}');
            Get.back();
            Get.back();
          } else {
            toastMessage('${response.message!}');
            Get.back();
          }
        } catch (e, s) {
          Completer().completeError(e, s);
          Get.back();
          toastMessage('Something went wrong. Please try again');
        }
      }
    }
  }

  _validate() {
    FocusScope.of(context).unfocus();
    String oldPassword = _userTypedCurrentPassword;
    String newPassword = _userTypedNewPassword;
    String rePassword = _userTypedConfirmPassword;

    if (oldPassword.isEmpty) {
      toastMessage('Please enter old password');
      _textFieldControlOldPassword.focusNode.requestFocus();
    } else if (!oldPassword.isValidPassword()['isValid']) {
      toastMessage(oldPassword.isValidPassword()['message']);
      _textFieldControlOldPassword.focusNode.requestFocus();
    } else if (newPassword.isEmpty) {
      toastMessage('Please enter new password');
      _textFieldControlNewPassword.focusNode.requestFocus();
    } else if (!newPassword.isValidPassword()['isValid']) {
      toastMessage(newPassword.isValidPassword()['message']);
      _textFieldControlNewPassword.focusNode.requestFocus();
    } else if (rePassword.isEmpty) {
      toastMessage('Please re-enter new password');
      _textFieldControlConfirmPassword.focusNode.requestFocus();
    } else if (!rePassword.isValidPassword()['isValid']) {
      toastMessage(rePassword.isValidPassword()['message']);
      _textFieldControlConfirmPassword.focusNode.requestFocus();
    } else if (newPassword != rePassword) {
      toastMessage('New password and confirm password must be same');
    } else {
      callApiToChangePassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    // var _blankFocusNode = new FocusNode();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: CommonBottomNavigationWidget(),
          body: GestureDetector(
            child: Form(
              key: _formKey,
              // autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TitleWithSeeAllButton(title: 'Update Password'),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Old Password',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              obscureText: _obscureCurrentPasswordText,
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Old Password',
                                hintStyle: TextStyle(fontSize: 14),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _toggleCurrentPassword();
                                  },
                                  icon: Icon(
                                    _obscureCurrentPasswordText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                              ),
                              controller:
                                  _textFieldControlOldPassword.controller,
                              focusNode: _textFieldControlOldPassword.focusNode,
                              onChanged: (val) =>
                                  _userTypedCurrentPassword = val,
                              validator: (val) {
                                _validateUserCurrentPassword(val!);
                              }),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'New Password',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              obscureText: _obscureNewPasswordText,
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'New Password',
                                hintStyle: TextStyle(fontSize: 14),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _toggleNewPassword();
                                  },
                                  icon: Icon(
                                    _obscureNewPasswordText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                              ),
                              controller:
                                  _textFieldControlNewPassword.controller,
                              focusNode: _textFieldControlNewPassword.focusNode,
                              onChanged: (val) => _userTypedNewPassword = val,
                              validator: (val) {
                                _validateUserNewPassword(val!);
                              }),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              obscureText: _obscureConfirmPasswordText,
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(fontSize: 14),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _toggleConfirmPassword();
                                  },
                                  icon: Icon(
                                    _obscureConfirmPasswordText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                              ),
                              controller:
                                  _textFieldControlConfirmPassword.controller,
                              focusNode:
                                  _textFieldControlConfirmPassword.focusNode,
                              onChanged: (val) =>
                                  _userTypedConfirmPassword = val,
                              validator: (val) {
                                _validateUserConfirmPassword(val!);
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: secondaryColor,
                        child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: _validate),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
