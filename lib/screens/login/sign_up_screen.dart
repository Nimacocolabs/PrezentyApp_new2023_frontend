import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/string_validator.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/profile_bloc.dart';
import '../../models/send_sms_email_account_verification_signup_model.dart';
import '../../models/user_details.dart';
import '../../models/send_mobile_email_otp_response.dart';
import '../profile/edit_profile_screen.dart';
import 'select_country_dialog_screen.dart';

class SignUpScreen extends StatefulWidget {
  final bool isFromWoohoo;

  const SignUpScreen({Key? key, required this.isFromWoohoo}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextFieldControl _textFieldControlEmail = TextFieldControl();
  TextFieldControl _textFieldControlFirstName = TextFieldControl();
  TextFieldControl _textFieldControlLastName = TextFieldControl();
  TextFieldControl _textFieldControlPhone = TextFieldControl();
  TextFieldControl _textFieldControlAddress = TextFieldControl();
  TextFieldControl _textFieldControlPassword = TextFieldControl();
  TextFieldControl _textFieldControlRePassword = TextFieldControl();
  TextFieldControl _textFieldControlSalesPersonName = TextFieldControl();
  static final RegExp _addressRegExp = RegExp(r'^[a-zA-Z0-9\.\-\s\,\/]+$');

  String _countryCode = '+91';

  AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: secondaryColor,
          ),
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
                  'Create\nAccount',
                  style: TextStyle(
                      // color: blueGrey7xx,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'First Name',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            textFieldControl: _textFieldControlFirstName,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            hintText: 'First Name',
                            keyboardType: TextInputType.name,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Last Name',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            textFieldControl: _textFieldControlLastName,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            hintText: 'Last Name',
                            keyboardType: TextInputType.name,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    // AppTextBox(
                    //   textFieldControl: _textFieldControlPhone,
                    //   prefixIcon: Icons.phone_outlined,
                    //   hintText: 'Phone',
                    //   keyboardType: TextInputType.phone,
                    // ),

                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _textFieldControlPhone.focusNode.hasFocus
                                  ? primaryColor
                                  : Colors.black26),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.phone_outlined,
                                color: Colors.black45,
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                  child: Container(
                                margin: EdgeInsets.only(right: 1),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '$_countryCode -',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    //Icon(Icons.keyboard_arrow_down_rounded)
                                  ],
                                ),
                              )),
                              onTap: true
                                  ? null
                                  : () async {
                                      Country? country = await Navigator.of(
                                              context)
                                          .push(PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (_, __, ___) =>
                                                  SelectCountryDialogScreen()));
                                      if (country != null) {
                                        setState(() {
                                          _countryCode =
                                              '+${country.phoneCode}';
                                        });
                                      }
                                    },
                            ),
                            // SizedBox(width: 8,),

                            Expanded(
                              child: TextField(
                                scrollPhysics: BouncingScrollPhysics(),
                                controller: _textFieldControlPhone.controller,
                                keyboardType: TextInputType.number,
                                focusNode: _textFieldControlPhone.focusNode,
                                minLines: 1,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                maxLength: 12,
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  hintText: 'Phone',
                                  hintStyle: TextStyle(fontSize: 14),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                                "Once updated, you can't change the mobile number later.",
                                style: TextStyle(color: Colors.red.shade300))),
                        IconButton(
                          onPressed: () {
                            AppDialogs.message(
                                "On creating an event, a virtual account will be created for you to receive gift amount. It will be linked with your mobile number. And it can't be changed later.");
                          },
                          icon: Icon(Icons.info_outline_rounded),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            textFieldControl: _textFieldControlAddress,
                            prefixIcon: Icon(Icons.location_on_outlined),
                            hintText: 'Address',
                            maxLines: 3,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                              "Please prevent the following special characters while you enter your address.\n @,#,%,\$,\&,+,=,*,"
                              ",!",
                              style: TextStyle(color: Colors.red.shade300)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Retype Password',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            textFieldControl: _textFieldControlRePassword,
                            prefixIcon: Icon(Icons.lock_outlined),
                            hintText: 'Password',
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 6),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [
                    //       Text(
                    //         'Referred sales person name',
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //       AppTextBox(
                    //         textFieldControl: _textFieldControlSalesPersonName,
                    //         prefixIcon: Icon(Icons.person_outline_rounded),
                    //         hintText: 'Name (optional)',
                    //         keyboardType: TextInputType.name,
                    //         textInputAction: TextInputAction.done,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            if (await canLaunchUrl(
                                Uri.parse(termsAndConditionsCardUrl))) {
                              await launchUrl(
                                  Uri.parse(termsAndConditionsCardUrl),
                                  mode:
                                      LaunchMode.externalNonBrowserApplication);
                            } else {
                              toastMessage(
                                  'Unable to open url $termsAndConditionsUrl');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'By clicking Sign Up, you are agreed the\nTerms and Conditions',
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

                    Material(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: secondaryColor,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        onTap: _validate,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 8),
                    //         child: ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               primary: Colors.black,
                    //             ),
                    //             onPressed: () {
                    //               Get.back(result: 'google');
                    //             },
                    //             child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 8.0, vertical: 11),
                    //                     child: Image.asset(
                    //                         'assets/images/ic_google.png',
                    //                         width: 20),
                    //                   ),
                    //                   // SizedBox(width:8),
                    //                   Text('Sign in with Google',
                    //                       style: TextStyle(color: Colors.white))
                    //                 ])),
                    //       ),
                    //       if (Platform.isIOS)
                    //         Padding(
                    //           padding: const EdgeInsets.only(bottom: 8.0),
                    //           child: ElevatedButton(
                    //               style: ElevatedButton.styleFrom(
                    //                 primary: Colors.black,
                    //               ),
                    //               onPressed: () {
                    //                 Get.back(result: 'apple');
                    //               },
                    //               child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Image.asset(
                    //                         'assets/images/ic_apple.png'),
                    //                     Text('Sign in with Apple',
                    //                         style:
                    //                             TextStyle(color: Colors.white))
                    //                   ])),
                    //         ),
                    //     ],
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Log In')),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              )
            ])));
  }

  _validate() async {
    FocusScope.of(context).unfocus();
    String email = _textFieldControlEmail.controller.text.trim();
    String firstName = _textFieldControlFirstName.controller.text.trim();
    String lastName = _textFieldControlLastName.controller.text.trim();
    String phone = _textFieldControlPhone.controller.text.trim();
    String address = _textFieldControlAddress.controller.text.trim();
    String password = _textFieldControlPassword.controller.text;
    String rePassword = _textFieldControlRePassword.controller.text;
    String salesPersonName =
        _textFieldControlSalesPersonName.controller.text.trim();
    FilteringTextInputFormatter.allow(_addressRegExp);

    if (!email.isValidEmail()) {
      _validationFailed(
          'Please provide a valid email address', _textFieldControlEmail);
    } else if (firstName.isEmpty) {
      _validationFailed(
          'Please provide your first name', _textFieldControlFirstName);
    } else if (!firstName.isAlphabetOnly) {
      _validationFailed('First name should contain only alphabets',
          _textFieldControlFirstName);
    } else if (lastName.isEmpty) {
      _validationFailed(
          'Please provide your last name', _textFieldControlLastName);
    } else if (!lastName.isAlphabetOnly) {
      _validationFailed(
          'Last name should contain only alphabets', _textFieldControlLastName);
    } else if (!phone.isValidMobileNumber()) {
      _validationFailed(
          'Please provide a valid phone number', _textFieldControlPhone);
    } else if (address.isEmpty) {
      _validationFailed(
          'Please provide your address', _textFieldControlAddress);
    } else if (!_addressRegExp.hasMatch(address)) {
      _validationFailed(
          'Please prevent @,#,%,\$,\&,+,=,*,"",! while entering your address',
          _textFieldControlAddress);
    } else if (!password.isValidPassword()['isValid']) {
      _validationFailed(
          password.isValidPassword()['message'], _textFieldControlPassword);
    } else if (!rePassword.isValidPassword()['isValid']) {
      _validationFailed(
          rePassword.isValidPassword()['message'], _textFieldControlRePassword);
    } else if (password != rePassword) {
      _validationFailed('Password mismatch', _textFieldControlRePassword);
    } else {
      dynamic b = await initVerifyMobileEmail(email, phone, false);
      if (b != null) {
        _signUp(
          email,
          '$firstName  $lastName',
          phone,
          address,
          password,
          salesPersonName,
          isEmail: b["emailOtp"],
          isMobile: b["mobileOtp"],
        );
      }
    }
  }

  _validationFailed(
    String msg,
    TextFieldControl textFieldControl,
  ) {
    toastMessage(msg);
    textFieldControl.focusNode.requestFocus();
  }

  Future _signUp(String email, String name, String phone, String address,
      String password, String salesPersonName,
      {bool? isEmail, bool? isMobile}) async {
    AppDialogs.loading();

    Map<String, dynamic> body = {};
    body["name"] = name;
    body["email"] = email;
    body["country_code"] = _countryCode.replaceAll('+', '');
    body["phone_number"] = phone;
    body["address"] = address;
    body["password"] = password;
    body["sales_person"] = salesPersonName;
    body["mobile_otp"] = (isMobile ?? false) ? "yes" : "no";
    body["email_otp"] = (isEmail ?? false) ? "yes" : "no";

    try {
      UserSignUpResponse response =
          await _authBloc.userRegistration(json.encode(body));
      Get.back();
      if (response.success!) {
        await SharedPrefs.logIn(true, response);
        if (widget.isFromWoohoo) {
          Get.back();
          Get.back();
        } else {
          String? imgUrl = await AuthBloc().getPopupImage();
          Get.offAll(() => MainScreen(
                fromSignUp: true,
              ));
          if (imgUrl != null) {
            AppDialogs.homePopupImage(imgUrl);
          }
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

Future<dynamic> initVerifyMobileEmail(
    String email, String phone, bool skippable) async {
  AuthBloc authBloc = AuthBloc();

  SendMobileEmailOtpData? data =
      await authBloc.sendMobileEmailOtp(email, phone, !skippable);

  String mobileOtp = '';
  String emailOtp = '';

  if (data != null) {
    return await Get.bottomSheet(
      WillPopScope(
        onWillPop: () async {
          if (!skippable) {
            toastMessage('Please complete mobile and email verification');
          }
          return skippable;
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Verify OTP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            Text(
                'We have sent OTPs to your email and mobile number. Verify either Email OTP  or Moile OTP to continue.',
                style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 30,
            ),
            Text('Enter your OTP received in +91-$phone',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * .15, 16, screenWidth * .15, 12),
              child: OTPTextField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                fieldWidth: 50,
                style: TextStyle(fontSize: 18),
                outlineBorderRadius: 8,
                length: 4,
                onChanged: (value) {},
                onCompleted: (value) {
                  mobileOtp = value;
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
              height: 20,
            ),
            Text(
              "OR",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Enter your OTP received in $email',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * .15, 16, screenWidth * .15, 12),
              child: OTPTextField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                fieldWidth: 50,
                style: TextStyle(fontSize: 18),
                outlineBorderRadius: 8,
                length: 4,
                onChanged: (value) {},
                onCompleted: (value) {
                  emailOtp = value;
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
              height: 24,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (data.mailToken.toString() == emailOtp ||
                      data.otpToken.toString() == mobileOtp) {
                    if (skippable) {
                      await authBloc
                          .updateMobileEmailVerifyComplete(User.userId);
                    } else {
                      toastMessage('Mobile and Email id verified');
                    }
                    Map<String, dynamic> resultData = {
                      "emailOtp": data.mailToken.toString() == emailOtp,
                      "mobileOtp": data.otpToken.toString() == mobileOtp,
                      "value": true
                    };
                    Get.back(result: resultData);
                  } else {
                    toastMessage('Invalid OTP');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Verify OTP'),
                )),
            SizedBox(
              height: 10,
            ),
            if (skippable)
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: secondaryColor),
                onPressed: () => Get.back(),
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Verify later")),
              ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                initVerifyMobileEmail(email, phone, skippable);
              },
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Resend OTP")),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      isDismissible: skippable,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      enableDrag: false,
    );
  } else {
    if (skippable) {
      return true;
    }
  }
  return null;
}

mobileOrEmailOtpNotCompleted({bool? isMobileOtpMissing}) {
  AuthBloc authBloc = AuthBloc();

  Get.bottomSheet(
    ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Verify OTP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Text(
            'You have not completed your ${isMobileOtpMissing! ? "mobile verification" : "email verification"}.Verify to continue.',
            style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () {
              verifyOtpNow(isOtpMissing: isMobileOtpMissing);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Verify Now"),
            )),
             SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: secondaryColor,
          ),
            onPressed: () {
           Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Verify Later"),
            )),
        SizedBox(
          height: 10,
        ),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    enableDrag: false,
  );
}

verifyOtpNow({bool? isOtpMissing}) async {
  String loginMissingOtp = '';
  AuthBloc authBloc = AuthBloc();
  SendSmsEmailAccountVerificationSignupModel? otpDataValue =
      await authBloc.sendSmsEmailAccountVerificationSignup(User.userId);


  return Get.bottomSheet(
    ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Verify OTP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Text(
            'Enter your OTP received in your  ${isOtpMissing! ? "mobile number" : "email"} ',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        Padding(
          padding:
              EdgeInsets.fromLTRB(screenWidth * .15, 16, screenWidth * .15, 12),
          child: OTPTextField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            fieldWidth: 50,
            style: TextStyle(fontSize: 18),
            outlineBorderRadius: 8,
            length: 4,
            onChanged: (value) {},
            onCompleted: (value) {
              loginMissingOtp = value;
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
          height: 20,
        ),
        ElevatedButton(
            onPressed: () async {
            
              if (loginMissingOtp == otpDataValue?.data?.mailToken.toString() ||loginMissingOtp == otpDataValue?.data?.otpToken.toString()  ) {
                await authBloc.updateMobileEmailVerifyComplete(User.userId);
                Get.close(2);
              } else {
                
                toastMessage('Something went wrong. Please try again later');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Verify OTP'),
            )),
        SizedBox(
          height: 10,
        ),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    enableDrag: false,
  );
}

Future<bool> checkUserInfo() async {
  UserDetails? userDetails = await ProfileBloc().checkUserInfo();

  if (userDetails != null) {
    String name = userDetails.name ?? '';
    String phone = userDetails.phoneNumber ?? '';
    String address = userDetails.address ?? '';

    if (!name.contains('  ') || phone.isEmpty || address.isEmpty) {
      toastMessage('Update your profile to continue');
      Get.offAll(
          () => EditProfileScreen(
                userDetails: userDetails,
                baseUrl: '',
                isCompleteProfile: true,
              ),
          opaque: false);
      return true;
    }
  }
  return false;
}
