import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HowToEarnTouchPointScreen extends StatefulWidget {
  const HowToEarnTouchPointScreen();

  @override
  State<HowToEarnTouchPointScreen> createState() =>
      _HowToEarnTouchPointScreenState();
}

class _HowToEarnTouchPointScreenState extends State<HowToEarnTouchPointScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Text("How to earn Touch points [TP]",
style: TextStyle(color: Colors.black54,
fontSize: 16,
fontWeight: FontWeight.w600),),
            ),
Divider(
thickness: 2,
),
SizedBox(
  height: 5,
),
            contentWidget("Earn Prezenty Touch points for every referral and transactions!",Icons.looks_one_outlined),
            SizedBox(
              height:2 ,
            ),
            contentWidget("Earn one or more Touch Point(s)  for every 100 Rupees Transaction by using the Prezenty Rupay Prepaid card.",Icons.looks_two_outlined),
            SizedBox(
              height:2,
            ),
            contentWidget("Earn one or more Touch points along with brand/merchant offers.", Icons.looks_3_outlined),
           SizedBox(
              height:2,
            ),
            contentWidget("Daily challenges, contests, games and other ways of rewards , may include the joining bonus.", Icons.looks_4_outlined),
          SizedBox(
              height:2,
            ),
            contentWidget("Create an event with us and to share with your loved ones; each acceptance you will be granted one or more touch points.", Icons.looks_5_outlined),
            SizedBox(
              height:2,
            ),
            contentWidget("Refer the Prezenty prepaid card to your friends and family and to get maximum up to 100 touch points.", Icons.looks_6_outlined),
SizedBox(
              height:13,
            ),
Padding(
  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
  child:   Text("How to redeem Touch points [TP]",
  
  style: TextStyle(color: Colors.black54,
  
  fontSize: 16,
  
  fontWeight: FontWeight.w600),),
  
),
Divider(
thickness: 2,
),
SizedBox(
  height:5,
),
contentWidget("The secured TP can be utilized fully or partially to buy the branded gift cards available in the Prezenty portal.", Icons.looks_one_outlined),
SizedBox(
  height: 2,
),
contentWidget("The TP shall not be transferable and the encashment of TP is no longer available in our portal.", Icons.looks_two_outlined)
          ],
        )));
  }

  Widget contentWidget(String? content,IconData icon) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          elevation: 1,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 20, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Icon(
                 icon,
                  color: primaryColor,
                  size: 23,
                ),
                SizedBox(
                  width: 10,
                  height:10,
                ),
                Expanded(
                  child: Text(
                    content!,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
