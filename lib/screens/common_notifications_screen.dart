import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class CommonNotificationScreen extends StatefulWidget {
  final String? notificationContent;
  const CommonNotificationScreen({this.notificationContent});

  @override
  State<CommonNotificationScreen> createState() => _CommonNotificationScreenState();
}

class _CommonNotificationScreenState extends State<CommonNotificationScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: CommonAppBarWidget(image: User.userImageUrl,onPressedFunction: (){
           Get.back();
    }),
    bottomNavigationBar: CommonBottomNavigationWidget(),
    body: SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
          Padding(
            padding: const EdgeInsets.only(top: 100,bottom: 20,left: 15,right: 10),
            child: Center(
              child: Text(
                "${widget.notificationContent ?? ""}",
               
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: "RobotoMono-Regular",
                    fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20,left: 10,right: 10),
            child: InkWell(
              onTap:(){
Get.to(() => MainScreen());
              },
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    )),
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
    ],)),
   );
   
  }
}