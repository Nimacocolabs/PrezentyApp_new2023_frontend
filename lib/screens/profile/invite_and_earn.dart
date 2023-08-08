import 'package:dotted_border/dotted_border.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';

import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/referral_code_model.dart';
import '../../widgets/CommonApiResultsEmptyWidget.dart';

class InviteAndEarnScreen extends StatefulWidget {
  const InviteAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<InviteAndEarnScreen> createState() => _InviteAndEarnScreenState();
}

class _InviteAndEarnScreenState extends State<InviteAndEarnScreen> {
  ProfileBloc _profileBloc = ProfileBloc();



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _profileBloc.getReferralCode(User.userId);

    });
  }



 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
        bottomNavigationBar: CommonBottomNavigationWidget(),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SizedBox(
            child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _profileBloc.referalCodeStream,
          builder: (context, snapshot) {
            print("aaaa");
            if (snapshot.hasData && snapshot.data?.status != null) {
              print("bbbbb");
              switch (snapshot.data!.status!) {
                case Status.LOADING:
            print("ccccc");
            return CommonApiLoader();
                case Status.COMPLETED:
            print("dddd");
            ReferralCodeModel?  response = snapshot.data!.data!;

            

            return screenWidgets(response);

                case Status.ERROR:
            print("eeee");
            return CommonApiResultsEmptyWidget(
                "${snapshot.data?.message ?? ""}",
                textColorReceived: Colors.black);
                default:
            print("");
              }
            }
            return SizedBox();
          }),
          ),
          
        )));
        
  }
screenWidgets(ReferralCodeModel? referralResponse){
  return ListView(
    children: [
SizedBox(
                  height: 20,
                ),
                Text("${referralResponse?.title ?? "" }",
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(
                  height: 5,
                ),
                _imageSection(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "UNLOCK TOUCH POINTS IN 4 EASY STEPS:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  
                  "1. Go to the dashboard and find your referral link.\n2. Send an invitation to a friend who doesn’t have Prezenty Prepaid card.\n3. Have them sign up and complete their KYC.\n4. ${referralResponse?.message ?? ""} ",
                  
                ),
                SizedBox(
                  height: 7,
                ),
                Text("* Terms and Conditions apply. ",
                    style: TextStyle(
                        color: Colors.black)),
                SizedBox(
                  height: 5,
                ),
                Text("Refer Now!",
                    style: TextStyle(
                        color: Colors.black)),
                SizedBox(
                  height: 20,
                ),
                 Column(
                  children: [
                    DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.pink,
                      radius: Radius.circular(8),
                      // padding: EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          width: screenWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                             referralResponse?.referealCode ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                String text =
                                "Here’s is my code ${referralResponse?.referealCode ?? ""} for Prezenty- Rupay platinum prepaid card ! Use my code and earn ${referralResponse?.referalTouchpoint ?? 0} bonus touch points instantly in your account after the successful signup! \nHurry! Signup Now!\nDownload from Playstore  : https://play.google.com/store/apps/details?id=com.cocoalabs.event_app\nDownload from Appstore : https://apps.apple.com/in/app/prezenty/id1589909513 ";
                                  
                                Share.share(text);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.share),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Share"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: '${referralResponse?.referealCode ?? ""}'));
                                toastMessage(
                                    'Referral code copied to clipboard');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.copy),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Copy"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  
                                ],
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
    ],
    ),
    ]);
}

   _imageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image(
        image: AssetImage("assets/cards/prepaid_card_complete_blank.png"),
        width: double.infinity,
        height: screenHeight * 0.3,
        fit: BoxFit.fill,
      ),
    );
  }
  }

