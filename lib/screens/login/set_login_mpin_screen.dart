import 'dart:async';

import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/screens/login/login_mpin_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../models/set_login_mpin_model.dart';
import '../../util/user.dart';

class SetLoginMPINScreen extends StatefulWidget {
  SetLoginMPINScreen({Key? key, this.isResetMPIN = false, this.otpReferenceId})
      : super(key: key);
  final bool? isResetMPIN;
  final int? otpReferenceId;

  @override
  State<SetLoginMPINScreen> createState() => _SetLoginMPINScreenState();
}

class _SetLoginMPINScreenState extends State<SetLoginMPINScreen> {
  AuthBloc _authBloc = AuthBloc();
  String? loginMPIN;
  String? confirmLoginMPin;
  String? loginMPINOtp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login_mpin_bg.jpg'),
                    fit: BoxFit.fill)),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 230, left: 20, right: 20, bottom: 50),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors:  [
                        Color.fromRGBO(49, 249, 152, 0.8),
                        Color.fromRGBO(159, 20, 211, 0.9)
                      ],),
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(20, 20),
                      ),
                     
                    ),
                    // padding: EdgeInsets.all(15),
                    width: double.infinity,
                    height: screenHeight * 0.69,
                    child: Column(
                      children: [
                        widget.isResetMPIN!
                        ?  Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20, right: 20),
                                    child: Text(
                                      "Enter OTP",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    child: Text(
                                      "Please enter the OTP that you receive on your phone.",
                                      style: TextStyle(color:Colors.black,fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 40, top: 20),
                                    child: OTPTextField(
                                      width: screenWidth - 80,
                                      length: 4,
                                      fieldWidth: 50,
                                      style: TextStyle(fontSize: 16),
                                      textFieldAlignment:
                                          MainAxisAlignment.center,
                                      fieldStyle: FieldStyle.box,
                                      onCompleted: (pin) {
                                        loginMPINOtp = pin;
                                      },
                                    ),
                                  ),
                                ],
                              )
                              : Padding(
                                padding: const EdgeInsets.only(
                                    top: 60, left: 20, right: 20),
                                child: Text(
                                  "Set 4 digit Login MPIN",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),

                              widget.isResetMPIN!
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    child: Text(
                                      "New MPIN",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PinCodeTextField(
                                       obscureText: true,
                                      autoFocus: true,
                                     cursorWidth:2,
                                      cursorColor: primaryColor,
                                      autoDismissKeyboard: true,
                                      keyboardType: TextInputType.number,
                                      appContext: context,
                                      length: 4,
                                       onChanged: (enteredPin) {},
                                  onCompleted: (enteredPin) {
                                    loginMPIN = enteredPin;
                                  },
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.underline,
                                        selectedColor: Colors.blue,
                                        activeColor: Colors.green,
                                        inactiveColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PinCodeTextField(
                                   obscureText: true,
                               cursorWidth:2,
                                  cursorColor: primaryColor,
                                  autoFocus: true,
                                  autoDismissKeyboard: true,
                                  keyboardType: TextInputType.number,
                                  appContext: context,
                                  length: 4,
                                  onChanged: (enteredPin) {},
                                  onCompleted: (enteredPin) {
                                    loginMPIN = enteredPin;
                                  },
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.underline,
                                    selectedColor: Colors.blue,
                                    activeColor: Colors.green,
                                    inactiveColor: Colors.red,
                                  ),
                                ),
                              ),

                              widget.isResetMPIN!
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20, right: 20),
                                    child: Text(
                                      "Confirm new MPIN",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                     Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: PinCodeTextField(
                                       obscureText: true,
                                     cursorWidth:2,
                                      cursorColor: primaryColor,
                                      autoFocus: true,
                                      autoDismissKeyboard: true,
                                      keyboardType: TextInputType.number,
                                      appContext: context,
                                       length: 4,
                                        onChanged: (pin){},
                                        onCompleted: (pin) {
                                          confirmLoginMPin = pin;
                                        },
                                        pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.underline,
                                        selectedColor: Colors.blue,
                                        activeColor: Colors.green,
                                        inactiveColor: Colors.red,
                                        ),
                                        ),
                                   ),
                                ],
                              )
                              : Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 80, left: 20, right: 20),
                                    child: Text(
                                      "Confirm Login MPIN",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                   Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PinCodeTextField(
                             obscureText: true,
                            autoFocus: true,
                          cursorWidth:2,
                            cursorColor:primaryColor,
                            autoDismissKeyboard: true,
                            keyboardType: TextInputType.number,
                            appContext: context,
                            length: 4,
                            onChanged: (pin) {},
                            onCompleted: (pin) {
                              confirmLoginMPin = pin;
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              selectedColor: Colors.blue,
                              activeColor: Colors.green,
                              inactiveColor: Colors.red,
                            ),
                          ),
                        ),
                        

                              ],
                            ),

                          
                              Column(
                                children: [
                                   Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                  ),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: secondaryColor,
                                      ),
                                      onPressed: () {
                                        loginMPIN != confirmLoginMPin
                                            ? toastMessage("MPIN doesn't match")
                                            
                                     :  widget.isResetMPIN!
                                      
                                            ? resetLoginMPIN(loginMPIN!)
                                            : setMpin(loginMPIN!);
                                      },
                                      child: Text("Confirm")),
                                ),
                              ),
                              widget.isResetMPIN!
                              ? Container()
                              : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: primaryColor,
                                ),
                                onPressed: () {
                                  Get.offAll(()=> MainScreen());
                                 
                                
                                },
                                child: Text("Not now")),
                          ),
                        )
                                ],
                              )
                       
                      ],
                    )
              ),),
            ]),
          ),
        ]),
      ),
    );
  }

  Future setMpin(String newLoginMPIN) async {
    AppDialogs.loading();
    try {
      SetLoginMpinModel response =
          await _authBloc.setLoginMPIN(User.userId, newLoginMPIN);
      Get.back();
      if (response.success ?? false) {
        toastMessage("MPIN set successfully");
        Get.to(() => LoginMPINScreen());
      } else {
        toastMessage("This account already has a MPIN");
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  Future resetLoginMPIN(String loginMPIN) async {
    AppDialogs.loading();
    try {
      CommonResponse response = await _authBloc.resetLoginMPIN(
        User.userId,
        loginMPIN,
        otpReferenceId: widget.otpReferenceId,
        otp: loginMPINOtp,
      );
      Get.back();
      if (response.success ?? false) {
        toastMessage("MPIN updated successfully");
        Get.offAll(() => LoginMPINScreen());
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
