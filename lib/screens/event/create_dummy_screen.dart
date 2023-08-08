import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_event_preview_screen.dart';

class CreateDummyScreen extends StatefulWidget {
  final bool isEdit;
  final bool isCharity;
  const CreateDummyScreen({Key? key, this.isEdit=false, this.isCharity = false}) : super(key: key);

  @override
  _CreateDummyScreenState createState() => _CreateDummyScreenState();
}

class _CreateDummyScreenState extends State<CreateDummyScreen> {
   bool isGift=true ;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(widget.isCharity){
          return true;
        }
        if(isGift){
          return true;
        }else{
          setState(() {
            isGift = true;
          });
        }
        return false;
      },
      child: Scaffold(
        appBar:AppBar(
          actions:widget.isEdit ? null : [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                if(widget.isCharity){
                  Get.to(() => CreateEventPreviewScreen(isFromViewDemo: false));
                  return;
                }
                if(isGift){
                  setState(() {
                    isGift =false;
                  });
                }else{
                  Get.to(() => CreateEventPreviewScreen(isFromViewDemo: false));
                }
              },
            ),
          ]
        ),
        body:
        widget.isCharity ?
        Column(
          children: [
            SizedBox(height: screenHeight* .030,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/hnd.png'),
            ),
            SizedBox(height: 12,),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Host charity events to donate amount, collect amount  with Prezenty!,',textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            ),
          ],
        ):
        //Center(child: Text("Can donate to charity"),) :
        Padding(
          padding: const EdgeInsets.all(16),
          child: isGift?Column(
            children: [
              Image.asset('assets/images/ic_gift_list_dummy.png'),
              SizedBox(height: 12,),
              Text('Send-Invite-Collect & Redeem! Enjoy your day with Prezenty!',textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            ],
          ):Column(
            children: [
              Image.asset('assets/images/ic_food_list_dummy.png'),
              SizedBox(height: 12,),
              Text('Send food vouchers to the participants', textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            ],
          ),

          // Receive amount from the participants to buy gift vouchers you wish
          // Send food vouchers to the participants
        )
      ),
    );
  }
}
