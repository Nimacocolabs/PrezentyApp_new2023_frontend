import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/authenticate_login_mpin_model.dart';
import 'package:event_app/models/forgot_login_mpin_model.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/login/login_screen.dart';

import 'package:event_app/screens/login/set_login_mpin_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../util/user.dart';

class LoginMPINScreen extends StatefulWidget {
  const LoginMPINScreen({Key? key,}) : super(key: key);

  @override
  State<LoginMPINScreen> createState() => _LoginMPINScreenState();
}

class _LoginMPINScreenState extends State<LoginMPINScreen> {
  ProfileBloc _profileBloc = ProfileBloc();
  AuthBloc _authBloc = AuthBloc();
   String? loginMPIN;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
       _profileBloc.getProfileInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
             decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/login_mpin_bg.jpg'),
              fit: BoxFit.fill)
            ),
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: primaryColor,
              onRefresh: () {
                return _profileBloc.getProfileInfo();
              },
              child: StreamBuilder<ApiResponse<dynamic>>(
                  stream: _profileBloc.profileStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data?.status != null) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return CommonApiLoader();
                        case Status.COMPLETED:
                          UserSignUpResponse resp = snapshot.data?.data;
                          return headerWidget(resp);
                        case Status.ERROR:
                          return CommonApiResultsEmptyWidget(
                              "${snapshot.data?.message ?? ""}",
                              textColorReceived: Colors.black);
                        default:
                          print("");
                      }
                    }
                    return Container(
                      child: Center(
                        child: Text(""),
                      ),
                    );
                  }),
            ),
          )
        ],
      )),
    );
  }

  Widget headerWidget(UserSignUpResponse data) {
    return Column(
      
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 210, left: 20, right: 20,bottom: 50),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors:  [
                        Color.fromRGBO(49, 249, 152, 0.8),
                        Color.fromRGBO(159, 20, 211, 0.9)
                      ],),
              borderRadius: BorderRadius.all(
                Radius.elliptical(20, 20),
              ),
              // color: Colors.grey.shade400,
            ),
            // padding: EdgeInsets.all(15),
            width: double.infinity,
            height: screenHeight * 0.69,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 105, right: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 50,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          '${data.baseUrl}${data.userDetails?.imageUrl}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Center(
                        child: Image(
                          image: AssetImage(
                            'assets/images/ic_avatar.png',
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20, right: 10,left: 15, bottom: 10),
                  child: Text("Welcome,",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10,left: 15, bottom: 10),
                  child: SizedBox(
                    child: Text('${data.userDetails?.name}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
               
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10,left: 15, bottom: 10),
                  child: Text(
                    "Enter the 4 digit Login MPIN to continue",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,),
                  ),
                ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: PinCodeTextField(
                  obscureText: true,
                  cursorColor:primaryColor,
                  cursorWidth:2,
                 autoFocus: true,
                
                  autoDismissKeyboard: true,
                  keyboardType: TextInputType.number,
                  appContext: context,
                   length: 4,
                    onChanged: (enterdPin){},
                    onCompleted: (enterdPin){
                     loginMPIN = enterdPin;
                    },
                    pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    selectedColor: Colors.blue,
                    activeColor: Colors.green,
                    inactiveColor: Colors.red,
                    ),
                    ),
               ),
               Center(child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: secondaryColor
                  ),
                  onPressed: (){
                loginMPIN != null ?
                loginMPIN!.length != 4 
                ? toastMessage("Enter a 4 digit PIN")
                : authLoginMpin(loginMPIN!)
                :toastMessage("Enter PIN");
                  }, 
                  child: Text("Submit")),
               )),
               Center(child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextButton(
                  style: TextButton.styleFrom(
                    primary: secondaryColor
                  ),
                  onPressed: (){
                  forgotLoginMpin();
                  }, child: Text("Forgot Login MPIN?")),
               )),
                Center(child: Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: TextButton(
                  style: TextButton.styleFrom(
                    primary: secondaryColor
                  ),
                  onPressed: (){
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                  }, child: Text("Login with an another account.")),
               ))
                
              ],
            ),
          ),
        ),
      ],
    );
  }

 Future authLoginMpin(String loginMPIN) async {
try {
  AuthenticateLoginMpinModel response = await _authBloc.authLoginMPIN(User.userId, loginMPIN);
  if(response.statusCode == 200){
    Get.to(() => MainScreen());
  }
  else{
    toastMessage("Invalid MPIN");
  }
}
catch (e, s) {
      Completer().completeError(e, s);
      Get.back();

      toastMessage('Something went wrong. Please try again');
    }
  }
  Future forgotLoginMpin() async{

    String accountId = User.userId;
     AppDialogs.loading();
    try{
      ForgotLoginMpinModel response = await _authBloc.forgotLoginMPIN(accountId);
    Get.back();
   if(response.success ?? false) {
    toastMessage("OTP generated successfully.Please wait");
    Get.offAll(() => SetLoginMPINScreen(
      isResetMPIN:true,
      otpReferenceId: response.data!.referenceId,));
   }
   else{
    toastMessage("invalid OTP");
   }
   
    }
    catch (e, s) {
      Completer().completeError(e, s);
      Get.back();

      toastMessage('Something went wrong.Please try again later');
    }

  }
}
