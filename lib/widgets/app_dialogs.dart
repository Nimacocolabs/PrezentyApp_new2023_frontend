import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/models/qr_code_model.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppDialogs {
  static closeDialog() {
    if (Get.isDialogOpen ?? false) Get.close(1);
  }

  static loading(
      {bool isDismissible = false, Alignment alignment = Alignment.center}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          if (isDismissible) {
            Get.back();
          }
          return false;
        },
        child: Align(
          alignment: alignment,
          child: Container(
            margin: EdgeInsets.all(12),
            height: 200,
            child: Material(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  isDismissible
                      ? Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.black12,
                              ),
                            ),
                            onTap: () {
                              Get.close(2);
                            },
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.indigo)
                                      //  color: Colors.indigo,
                                      ),
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/ic_logo.png',
                                    height: 36,
                                    width: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          'Please wait..',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black26,
    );
    return;
  }

  static message(String message) {
    Get.dialog(
      Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(16),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text('Ok'),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    );
    return;
  }

  static Future<String?> inputAmountBottomSheet(
      String title, String message) async {
    String _amount = '';
    bool? b = await Get.bottomSheet(
      Container(
        //   padding: MediaQuery.of(Get.context!).viewInsets,
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: secondaryColor.shade200)),
                width: screenWidth * .5,
                child: TextField(
                  autofocus: true,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (val) => _amount = val,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: secondaryColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: '0',
                    counterText: '',
                    hintStyle: TextStyle(fontSize: 30, color: Colors.grey),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                      child: Text(
                        '$rupeeSymbol',
                        style: TextStyle(
                            fontSize: 30, color: secondaryColor.shade300),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Center(
                child: Container(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 24,
                        color: Colors.grey,
                      ),
                      VerticalDivider(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  try {
                    double d = double.parse(_amount);
                    if (d > 0) {
                      Get.back(result: true);
                    } else {
                      toastMessage("Please provide a valid amount");
                    }
                  } catch (e) {
                    toastMessage("Please provide a valid amount");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
    );

    if (b ?? false) {
      return _amount;
    } else {
      return null;
    }
  }

  static homePopupImage(String url) {
    Get.dialog(
      Dialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              child: CachedNetworkImage(
                imageUrl: '${url}',
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/ic_person_avatar.png'),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Icon(
                Icons.close_rounded,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
