import 'dart:convert';

import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/delete_account_otp_model.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class DeleteAccountScreen extends StatefulWidget {
  DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late ProfileBloc _profileBloc;
  DeleteAccountOtpData? deleteData;
  String accountId = User.userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileBloc = ProfileBloc();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Confirm It\'s You',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      // color: color2,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text(
                    'To secure your account, we\'ll send you a security code. Please confirm it to receive your code',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Card(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 11,
                                  )),
                              Text(User.userEmail,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ))
                            ]))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: secondaryColor,
                  ),
                  onPressed: () => accountDeleteOtp(),
                  child: Text('Confirm Now')),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: secondaryColor),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child:
                      Text('Not Now', style: TextStyle(color: secondaryColor))),
            ]),
      ),
    ));
  }

  accountDeleteOtp() async {
    AppDialogs.loading();
    var data = await _profileBloc.deleteAccountOtp(accountId);

    print(data);
    Map map = jsonDecode(data.data);
    if (map['statusCode'] == 200) {
      AppDialogs.closeDialog();
      deleteData = DeleteAccountOtpData.fromJson(map['data']);
      await otpBottomSheet();
    } else if (map['statusCode'] == 500) {
      AppDialogs.closeDialog();
      toastMessage("User has already requested for account deletion.");
    }
  }

  otpBottomSheet() async {
    String deleteotp = "";
    return Get.bottomSheet(
      WillPopScope(
        onWillPop: () async => true,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 12.0)),
            Text("Verify OTP",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 30,
            ),
            Text("Enter the OTP received in your email.",
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
                  deleteotp = value;
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
                  if (deleteData!.mailToken.toString() == deleteotp) {
                    {
                      bool? b =
                          await _profileBloc.confirmAccountDelete(accountId);

                      if (b == true) {
                        Get.back();
                        AppDialogs.message(
                            "Your request has been received.The account will be deleted within 30 days.");
                        //Get.back();
                      }
                    }
                  } else {
                    toastMessage('Invalid OTP');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Verify OTP'),
                )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
