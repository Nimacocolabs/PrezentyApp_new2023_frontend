import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessOrFailedScreen extends StatefulWidget {
  final bool? isSuccess;
  final String? content;
  const SuccessOrFailedScreen({this.isSuccess, this.content});

  @override
  State<SuccessOrFailedScreen> createState() => _SuccessOrFailedScreenState();
}

class _SuccessOrFailedScreenState extends State<SuccessOrFailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWidget(
          image: User.userImageUrl,
          onPressedFunction: () {
            Get.to(() => MainScreen());
          }),
          bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SafeArea(
          child: Column(
        children: [
          widget.isSuccess ?? false
              ? Image(image: AssetImage("assets/images/success_image.png"))
              : Image(image: AssetImage("assets/images/failed_image.png")),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "${widget.isSuccess ?? false ? "Success" : "Failed"}",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.content}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "RobotoMono-Regular",
                  fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
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
        ],
      )),
    );
  }
}
