import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/app_helper.dart';

class LoadMoneyWaitScreen extends StatefulWidget {
  const LoadMoneyWaitScreen({Key? key}) : super(key: key);

  @override
  State<LoadMoneyWaitScreen> createState() => _LoadMoneyWaitScreenState();
}

class _LoadMoneyWaitScreenState extends State<LoadMoneyWaitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWidget(image: User.userImageUrl,
      onPressedFunction: (){
        Get.to(() => MainScreen());
      },),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: Column(children: [
        Padding(padding: const EdgeInsets.only(top: 250,left: 10,right: 10),
        child: Text("Time Out !!",
        style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 25),),),
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 10,right: 10),
            child: Text(
              "Any debited amount will be credited to your wallet after 2-3 hours.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "RobotoMono-Regular",
                  fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 10,right: 10),
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
      ],),
    );
  }
}