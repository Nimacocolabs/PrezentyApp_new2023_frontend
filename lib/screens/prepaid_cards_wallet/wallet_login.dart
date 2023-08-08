import 'dart:async';
import 'dart:convert';
import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletAuth extends StatefulWidget {
  WalletAuth({Key? key, this.isFromHome = false}) : super(key: key);
  static final RegExp emailRegExp = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  final isFromHome;
  @override
  State<WalletAuth> createState() => _WalletAuthState();
}

class _WalletAuthState extends State<WalletAuth> {
  AuthBloc _authBloc = AuthBloc();

  final TextEditingController _emailControl = TextEditingController();

  final TextEditingController _mPinControl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(color: secondaryColor),
          actions: [


    GestureDetector(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(image: AssetImage("assets/images/ic_home.png")),
            )),
          ]),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: screenHeight / 6,
            ),
            Text(
              "Login",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // widget.isFromHome
                  //     ? Container()
                  //     :
                  Text(
                    "Email Address",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // widget.isFromHome!
                  //     ? Container()
                  //     :
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [],
                    validator: (value) {
                      return value!.isEmpty ||
                              !WalletAuth.emailRegExp.hasMatch(value)
                          ? "Enter valid email address"
                          : null;
                    },
                    controller: _emailControl,
                    keyboardType: TextInputType.emailAddress,
                    cursorHeight: 24,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                            image: AssetImage("assets/images/ic_email.png")),
                      ),
                      prefixIconConstraints: BoxConstraints(
                          minHeight: 40,
                          maxHeight: 50,
                          minWidth: 40,
                          maxWidth: 50),
                      hintText: "name@gmail.com",
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      enabledBorder: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 2, color: primaryColor)),
                      border: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 2, color: primaryColor)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value!.isEmpty
                          ? "Enter Passsword"
                          : value.contains(" ")
                              ? "Password must not contain space"
                              : value.length >= 6
                                  ? "Password length must be > 6"
                                  : null;
                    },
                    obscureText: true,
                    controller: _mPinControl,
                    keyboardType: TextInputType.text,
                    cursorHeight: 24,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                            image: AssetImage("assets/images/ic_email.png")),
                      ),
                      prefixIconConstraints: BoxConstraints(
                          minHeight: 40,
                          maxHeight: 50,
                          minWidth: 40,
                          maxWidth: 50),
                      //isDense: true,
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _mPinControl.text = "";
                          }),
                      hintText: "*********",
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      enabledBorder: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 2, color: primaryColor)),
                      border: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 2, color: primaryColor)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // print(widget.isFromHome);
                if (widget.isFromHome != true) {
                  if (_formKey.currentState!.validate()) {
                    Get.to(WalletHomeScreen(isToLoadMoney: false,));
                    //_setMPin(_emailControl.text, _mPinControl.text);
                  }
                } else {
                  if (_formKey.currentState!.validate()) {
                    toastMessage("You need to sign up");
                    //_setMPin(_emailControl.text, _mPinControl.text);

                  }
                }
              },
              child: Text(
                "Log in",
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
          ]),
        ),
      ),
    );
  }

  Future _validateMPin(String mPin) async {
    AppDialogs.loading();

    Map<String, dynamic> body = {};
    body["email"] = User.userEmail;
    body["m_pin"] = mPin;

    try {
      UserSignUpResponse response = await _authBloc.login(json.encode(body));
      Get.back();
      if (response.success!) {
        await SharedPrefs.logIn(true, response);

        Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  Future _setMPin(String email, String mPin) async {
    AppDialogs.loading();

    Map<String, dynamic> body = {};
    body["email"] = email;
    body["m_pin"] = mPin;

    try {
      UserSignUpResponse response = await _authBloc.login(json.encode(body));
      Get.back();
      if (response.success!) {
        await SharedPrefs.logIn(true, response);

        Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
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

  //   try {
  //     name = name.replaceAll('.', ' ');

  //     UserSignUpResponse response = await _authBloc.socialLogin(email, name);
  //     if (response.success!) {
  //       await SharedPrefs.logIn(true, response);
  //       Get.offAll(() => MyCardsAndWallet());
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

  //   if (_googleSignIn.currentUser != null) {
  //     await _googleSignIn.signOut().then((_) {
  //       _googleSignIn.signOut();
  //     });
  //   }

  //   GoogleSignInAccount? acc = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication auth = await acc!.authentication;

  //   if (_googleSignIn.currentUser != null) {
  //     await _googleSignIn.signOut().then((_) {
  //       _googleSignIn.signOut();
  //     });
  //   }

  //   _googleSignUp(acc, auth);
  // }

  // _googleSignUp(GoogleSignInAccount account,
  //     GoogleSignInAuthentication authentication) async {
  //   String name = account.displayName!;
  //   String email = account.email;

  //   _socialLogin(email, name);
  // }

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

  // _isIosVersionAbove12() async {
  //   try {
  //     //todo check in ios
  //     var iosInfo = await DeviceInfoPlugin().iosInfo;
  //     String version = iosInfo.systemVersion;

  //     if (version.contains('.')) {
  //       int i = version.indexOf('.');
  //       version = version.substring(0, i);
  //     }

  //     print(version);
  //     int i = int.parse(version);
  //     return i > 12;
  //   } catch (e, s) {
  //     Completer().completeError(e, s);
  //   }
  //   return true;
  // }
}
// _sendOtp() async {
//     FocusScope.of(context).requestFocus(FocusNode());

//     String? otp = await _bloc.sendOtp(
//         true, country.phoneCode, _textFieldControl.controller.text);
//     if (otp != null) {
//       String? str = await Get.to(() => LoginVerifyOtpScreen(
//             isFromLogin: true,
//             countryCode: country.phoneCode,
//             mobile: _textFieldControl.controller.text,
//             otp: otp,
//             name: '',
//           ));

//       if (str == 'resend') {
//         _sendOtp();
//       } else if (str == 'edit') {
//         _textFieldControl.focusNode.requestFocus();
//       }
//     }
//   }


