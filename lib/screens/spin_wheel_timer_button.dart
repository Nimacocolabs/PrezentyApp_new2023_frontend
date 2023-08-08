import 'dart:async';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/spin_user_input_model.dart';
import 'package:event_app/screens/spin_and_win_screen.dart';
import 'package:event_app/screens/spin_gifts_won_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/string_validator.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SpinWheelTimerButton extends StatefulWidget {
  const SpinWheelTimerButton({Key? key});

  @override
  State<SpinWheelTimerButton> createState() => SpinWheelTimerButtonState();
}

class SpinWheelTimerButtonState extends State<SpinWheelTimerButton> {
  final _formKey = GlobalKey<FormState>();
  final TextFieldControl emailController = TextFieldControl();
  final TextFieldControl phoneController = TextFieldControl();
  ProfileBloc _profileBloc = ProfileBloc();

  @override
  void initState() {
    super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
    });
  }

  // Future<String?> _getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else if (Platform.isAndroid) {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.androidId; // unique ID on Android
  //   }
  // }

 getUserDataBottomSheet() async {
    emailController.controller.text = '';
    phoneController.controller.text = '';
    await Get.bottomSheet(
        Container(
            padding: EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Email address',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  AppTextBox(
                    textFieldControl: emailController,
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  AppTextBox(
                    textFieldControl: phoneController,
                    prefixIcon: Icon(Icons.phone_android),
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    textInputAction: TextInputAction.done,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(Get.context!).unfocus();
                        String email = emailController.controller.text.trim();
                        String phone = phoneController.controller.text;

                        if (!email.isValidEmail()) {
                          toastMessage('Please provide a valid email address');
                          emailController.focusNode.requestFocus();
                        } else if (!phone.isValidMobileNumber()) {
                          toastMessage('Please provide a valid phone number');
                          phoneController.focusNode.requestFocus();
                        } else {
                          _spinWheelAttempt(email, phone);
                        }
                      },
                      child: Text('Submit')),
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "May be later",
                    ),
                  )
                ],
              ),
            )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (User.apiToken.isEmpty) {
            getUserDataBottomSheet();
          } else {
            _spinWheelAttempt(User.userEmail, User.userMobile);
          }
        },
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(49, 249, 152, 0.8),
                    Color.fromRGBO(159, 20, 211, 0.9)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Don't Forget your spin!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Grab your deal !",
                        style: TextStyle(fontSize: 15),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Deal ends within",
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      StreamBuilder(
                          stream:
                              Stream.periodic(Duration(seconds: 1), (i) => i)
                                  .asBroadcastStream(),
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            DateTime today = DateTime.now();
                            DateTime tomorrow = today.add(Duration(days: 1));
                            int estimateTs = DateTime(tomorrow.year,
                                    tomorrow.month, tomorrow.day, 00)
                                .millisecondsSinceEpoch;
                            String strDigits(int n) =>
                                n.toString().padLeft(2, '0');
                            int now = today.millisecondsSinceEpoch;
                            Duration remaining =
                                Duration(milliseconds: estimateTs - now);
                            var dateString =
                                '${strDigits(remaining.inHours.remainder(24))}:${strDigits(remaining.inMinutes.remainder(60))}:${strDigits(remaining.inSeconds.remainder(60))}';
                            // print(dateString);
                            List splittedDate = dateString.split('').toList();
                            // final timeWidgets = splittedDate.map((x) {
                            //   return Row(children: [
                            //     Container(
                            //         decoration: BoxDecoration(
                            //             color: Color(0xfffea83e),
                            //             borderRadius: BorderRadius.circular(5)),
                            //         padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                            //         child: Text(
                            //           x,
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 20,
                            //               color: Colors.white),
                            //         )),
                            //     SizedBox(
                            //       width: 8,
                            //     )
                            //   ]);
                            // });
                            // return Row(children: timeWidgets.toList());
                            return Text(
                              dateString,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            );
                          }),
                      
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/spin_and_win.gif',
                  width: 90,
                  height: 90,
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _spinWheelAttempt(String email, String phone) async {
    try {
      SpinUserInputModel? response =
          await _profileBloc.insertSpinUserAttempt(email, phone);
      Get.back();
      if (response!.screen == "spin") {
      
        bool? b = await Get.to(() => SpinAndWinScreen(
            instTableID: response.data!.insTableId ?? 0,
            spinList: response.data?.spinList ?? []));
        if (b ?? false) {
          _spinWheelAttempt(email, phone);
        }
      } else if (response.screen == "details") {
        Get.to(() => SpinGiftsWonScreen(
              currentDate: response.data!.currentDate.toString(),
              email: email,
              phone: phone,
              insTableId: response.data!.insTableId ?? 0,
              spinData: response.data!.spinData!,
              spinDate: response.data!.spinDate!,
            ));
      } else {
        toastMessage('${response.message}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }
}
