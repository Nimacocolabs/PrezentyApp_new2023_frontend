import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_methods.dart';

class CommonWidgets {
  showNetworkErrorDialog(msg) {
    CommonMethods().isInternetAvailable().then((onValue) {
      if (onValue) {
        showErrorDialog(msg);
      } else {
        showNetworkFailureDialog();
      }
    });
  }

  void showErrorDialog(msg) {
    Get.defaultDialog(
        onWillPop: () async => false,
        backgroundColor: Colors.white,
        barrierDismissible: false,
        radius: 15,
        title: "",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 10.0, right: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white30),
                    onPressed: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Close",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ));
  }

  void showNetworkFailureDialog() {
    Get.defaultDialog(
        onWillPop: () async => false,
        backgroundColor: Colors.white,
        barrierDismissible: false,
        radius: 15,
        title: "",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/ic_404_error.png'),
              height: Get.size.height * .30,
              width: Get.size.width * .50,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                10,
                0,
                10,
                10,
              ),
              child: Text(
                "Could not connect to Internet",
                style: new TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                10,
                0,
                10,
                0,
              ),
              child: Text(
                "Please check your network settings",
                style: new TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white30),
              onPressed: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Close",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0),
                ),
              ),
            )
          ],
        ));
  }

  showPersonInfoDialog({var name, var email, var phone, var address}) {
    Get.dialog(
        Align(
          alignment: Alignment.center,
          child: Container(
            width: Get.width * .9,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Material(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Participant Info',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${email}',
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/ic_person_avatar.png'),
                          ),
                        ),),
                    ),
                  ),
                  Text(
                    'Name',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Email',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '$email',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Phone',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '$phone',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Address',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '$address',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Ok'))
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: true);
  }
}
