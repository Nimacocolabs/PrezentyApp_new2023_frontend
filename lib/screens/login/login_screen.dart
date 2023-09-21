import 'dart:async';
import 'dart:convert';
import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/util/notifications.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/string_constants.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/app_helper.dart';
import '../../util/string_validator.dart';
import '../../widgets/app_text_box.dart';
import 'reset_password_email_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isFromWoohoo;

  const LoginScreen({Key? key, required this.isFromWoohoo}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRememberMeChecked = true;
  TextFieldControl _textFieldControlEmail = TextFieldControl();
  TextFieldControl _textFieldControlPassword = TextFieldControl();

  AuthBloc _authBloc = AuthBloc();
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    Notifications.removeUserId();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: StringConstants.doubleBackExit);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [primaryColor, secondaryColor],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.white),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.topLeft,
                        colors: [primaryColor, secondaryColor],
                      ),
                    ),
                    padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                    width: screenWidth,
                    height: screenHeight * 0.2,
                  ),
                  Positioned(
                    left: 80,
                    top: 20,
                    child: Text("PREZENTY APP",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30)),
                  ),
                  Positioned(
                      left: 150,
                      bottom: -15,
                      child: Container(
                        child: Image(
                          image: AssetImage("assets/images/ic_logo.png"),
                          width: 60,
                          height: 60,
                        ),
                      ))
                ],
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Welcome back!',
                        style: TextStyle(
                            // color: color1,
                            fontSize: 20,
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
                    ),
                    SizedBox(
                      height: 8,
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
                      textInputAction: TextInputAction.done,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: _isRememberMeChecked,
                            onChanged: (b) {
                              setState(() {
                                _isRememberMeChecked = !_isRememberMeChecked;
                              });
                            }),
                        Expanded(
                          child: Text(
                            'Remember me',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  // color: color2.withOpacity(0.6),
                                  ),
                            ),
                          ),
                          onTap: () {
                            String email =
                                _textFieldControlEmail.controller.text.trim();
                            Get.to(() => ResetPasswordEmailScreen(
                                  email: email.isValidEmail() ? email : null,
                                ));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
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
                              'Log In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        onTap: _validate,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            if (await canLaunchUrl(
                                Uri.parse(termsAndConditionsCardUrl))) {
                              await launchUrl(
                                  Uri.parse(termsAndConditionsCardUrl),
                                  mode: LaunchMode.externalApplication);
                            } else {
                              toastMessage(
                                  'Unable to open url $termsAndConditionsUrl');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'By clicking Log In, you are agreed the\nTerms and Conditions',
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
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       InkWell(
                    //           borderRadius:
                    //               const BorderRadius.all(Radius.circular(30)),
                    //           child: Container(
                    //               padding: const EdgeInsets.all(8.0),
                    //               decoration: BoxDecoration(
                    //                   borderRadius: const BorderRadius.all(
                    //                       Radius.circular(30)),
                    //                   border: Border.all(color: primaryColor)),
                    //               child: ClipRRect(
                    //                   borderRadius: const BorderRadius.all(
                    //                       Radius.circular(30)),
                    //                   child: Image.asset(
                    //                     'assets/images/ic_google.png',
                    //                     height: 30,
                    //                     width: 30,
                    //                   ))),
                    //           onTap: _googleAuth),
                    //       if (Platform.isIOS) SizedBox(width: 24),
                    //       if (Platform.isIOS)
                    //         InkWell(
                    //             borderRadius:
                    //                 const BorderRadius.all(Radius.circular(30)),
                    //             child: Container(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: const BorderRadius.all(
                    //                         Radius.circular(30)),
                    //                     border:
                    //                         Border.all(color: primaryColor)),
                    //                 child: ClipRRect(
                    //                   borderRadius: const BorderRadius.all(
                    //                       Radius.circular(30)),
                    //                   child: Image.asset(
                    //                     'assets/images/ic_apple.png',
                    //                     height: 30,
                    //                     width: 30,
                    //                   ),
                    //                 )),
                    //             onTap: _appleLogin),
                    //     ],
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         primary: Colors.black,
                    //       ),
                    //       onPressed: _googleAuth,
                    //       child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 8.0, vertical: 11),
                    //               child: Image.asset(
                    //                   'assets/images/ic_google.png',
                    //                   width: 20),
                    //             ),
                    //             // SizedBox(width:8),
                    //             Text('Sign in with Google',
                    //                 style: TextStyle(color: Colors.white))
                    //           ])),
                    // ),
                    // if (Platform.isIOS)
                    //   Padding(
                    //     padding: const EdgeInsets.only(bottom: 8.0),
                    //     child: ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           primary: Colors.black,
                    //         ),
                    //         onPressed: _appleLogin,
                    //         child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Image.asset('assets/images/ic_apple.png'),
                    //               Text('Sign in with Apple',
                    //                   style: TextStyle(color: Colors.white))
                    //             ])),
                    //   ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    // color: color1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                    ),
                                    child: Icon(Icons.arrow_forward_ios_rounded,
                                        color: Colors.white))
                              ],
                            ),
                          ),
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            String? b = await Get.to(() => SignUpScreen(
                                  isFromWoohoo: widget.isFromWoohoo,
                                ));

                            // if ((b ?? '') == 'google') {
                            //   _googleAuth();
                            // } else if ((b ?? '') == 'apple') {
                            //   _appleLogin();
                            // }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validate() {
    FocusScope.of(context).unfocus();
    String email = _textFieldControlEmail.controller.text.trim();
    String password = _textFieldControlPassword.controller.text;

    if (!email.isValidEmail()) {
      toastMessage('Please provide a valid email address');
      _textFieldControlEmail.focusNode.requestFocus();
    } else if (!password.isValidPassword()['isValid']) {
      toastMessage(password.isValidPassword()['message']);
      _textFieldControlPassword.focusNode.requestFocus();
    } else {
      _login(email, password);
    }
  }

  Future _login(String email, String password) async {
    AppDialogs.loading();

    Map<String, dynamic> body = {};
    body["email"] = email;
    body["password"] = password;

    try {
      UserSignUpResponse response = await _authBloc.login(json.encode(body));
      Get.back();
      if (response.success!) {
        await SharedPrefs.logIn(_isRememberMeChecked, response);
        if (widget.isFromWoohoo) {
          Get.close(1);
        } else {
          goToHomeScreen(showCheckMpin: false);
          // Get.offAll(() => MainScreen());
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

  // Future _socialLogin(String email, String name) async {
  //   AppDialogs.loading();
  //
  //   try {
  //     name = name.replaceAll('.', ' ');
  //
  //     UserSignUpResponse response = await _authBloc.socialLogin(email, name);
  //     if (response.success!) {
  //       await SharedPrefs.logIn(true, response);
  //       Get.offAll(() => MainScreen());
  //     } else {
  //       toastMessage('${response.message!}');
  //     }
  //     Get.back();
  //   } catch (e, s) {
  //     Completer().completeError(e, s);
  //     Get.back();
  //     toastMessage('Something went wrong. Please try again');
  //   }
  // }

  // _googleAuth() async {
  //   GoogleSignIn _googleSignIn = GoogleSignIn(
  //     scopes: [
  //       'email',
  //     ],
  //   );
  //
  //   if (_googleSignIn.currentUser != null) {
  //     await _googleSignIn.signOut().then((_) {
  //       _googleSignIn.signOut();
  //     });
  //   }
  //
  //   GoogleSignInAccount? acc = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication auth = await acc!.authentication;
  //
  //   if (_googleSignIn.currentUser != null) {
  //     await _googleSignIn.signOut().then((_) {
  //       _googleSignIn.signOut();
  //     });
  //   }
  //
  //   _googleSignUp(acc, auth);
  // }
  //
  // _googleSignUp(GoogleSignInAccount account,
  //     GoogleSignInAuthentication authentication) async {
  //   String name = account.displayName!;
  //   String email = account.email;
  //
  //   _socialLogin(email, name);
  // }
  //
  // _appleLogin() async {
  //   //todo check version in ios
  //   if (!(await _isIosVersionAbove12())) {
  //     toastMessage('Apple sign in requires ios 13 and above');
  //     return;
  //   }
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );
  //   if ((credential.email ?? '').isEmpty) {
  //     toastMessage('Unable to get email');
  //   } else {
  //     _socialLogin(credential.email!, credential.givenName ?? '');
  //   }
  // }
  //
  // _isIosVersionAbove12() async {
  //   try {
  //     //todo check in ios
  //     var iosInfo = await DeviceInfoPlugin().iosInfo;
  //     String version = iosInfo.systemVersion;
  //
  //     if (version.contains('.')) {
  //       int i = version.indexOf('.');
  //       version = version.substring(0, i);
  //     }
  //
  //     print(version);
  //     int i = int.parse(version);
  //     return i > 12;
  //   } catch (e, s) {
  //     Completer().completeError(e, s);
  //   }
  //   return true;
  // }
}
