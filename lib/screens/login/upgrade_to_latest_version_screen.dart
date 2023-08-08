import 'dart:io';

import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';

class UpgradeToLatestVersionScreen extends StatefulWidget {
  const UpgradeToLatestVersionScreen({Key? key}) : super(key: key);

  @override
  State<UpgradeToLatestVersionScreen> createState() => _UpgradeToLatestVersionScreenState();
}

class _UpgradeToLatestVersionScreenState extends State<UpgradeToLatestVersionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(child: 
      Column(
        children: [
        
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/upgarde_to_latest_version.jpg'),)
            ),
            child: Column(
              children: [
                             Column(
                               children: [
                                SizedBox(
                                  height: 200,
                                ),
                               
                                 Padding(
                  padding: const EdgeInsets.only(top: 200,left: 10,right: 10,bottom: 40),
                  
                  child: Text(
                                    'We have a brand new update for you, please go to ${Platform.isAndroid ? 'Play store' : 'App store'} and download the latest version of the app. ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                  ),
                ),
                               ],
                             ),
               
               Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: secondaryColor,
                                      ),
                                        onPressed: () {
                                          if (Platform.isAndroid) {
                                            SystemNavigator.pop();
                                          } else if (Platform.isIOS) {
                                            exit(0);
                                          }
                                        },
                                        child: Text('Exit')),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          LaunchReview.launch(
                                            androidAppId: 'com.cocoalabs.event_app',
                                            iOSAppId: '1589909513',
                                          );
                                        },
                                        child: Text('Update Now')),
                                  )
                                ], 
                              ),
            )],
            ),
          ),
        ],
      )),
    );
  }
}