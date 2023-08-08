import 'dart:developer';
import 'dart:io';

import 'package:event_app/models/check_loginmpin_set_or_not_model.dart';
import 'package:event_app/screens/login/login_mpin_screen.dart';
import 'package:event_app/screens/login/set_login_mpin_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/without_login_home_screen.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../bloc/auth_bloc.dart';

///
///
///
///******************************************

//todo change to live base url before build
bool isProduction = true;

///******************************************
///
///
///

// String sampleImageUrl =
//     'https://d1pnnwteuly8z3.cloudfront.net/images/7462b53b-722a-4118-bce0-9de00cb86bc3/042e4872-744c-41b8-b577-5e4cf43d584d.jpeg';

String termsAndConditionsCardUrl =
    "https://prezenty.in/Livquik-Terms%20and%20conditions.pdf";
String termsAndConditionsUrl = "https://prezenty.in/Terms_of_use.pdf";
String privacyPolicyUrl = "https://prezenty.in/privacy_Policy.pdf";

MaterialColor primaryColor = MaterialColor(int.parse("0xffd0006f"), {
  50: Color(0xfffde5f0),
  100: Color(0xfffabdd9),
  200: Color(0xfff991c0),
  300: Color(0xfff962a5),
  400: Color(0xfff83c8f),
  500: Color(0xfff90079),
  600: Color(0xffe70075),
  700: Color(0xffd0006f),
  800: Color(0xffba006a),
  900: Color(0xff940062),
});

MaterialColor secondaryColor = MaterialColor(int.parse("0xff02075f"), {
  50: Color(0xffe5e6f2),
  100: Color(0xffbebfde),
  200: Color(0xff9396c7),
  300: Color(0xff696eb1),
  400: Color(0xff4b50a2),
  500: Color(0xff2c3393),
  600: Color(0xff272c8a),
  700: Color(0xff1e237f),
  800: Color(0xff151a73),
  900: Color(0xff02075f),
});

Color secondaryColorShade = Color(0xff001043);

double screenWidth = 0.0;
double screenHeight = 0.0;

String rupeeSymbol = '₹';

goToHomeScreen({bool showCheckMpin:true}) async {
  String? imgUrl = await AuthBloc().getPopupImage();
  await SharedPrefs.init();
  if (User.apiToken.isEmpty) {
    Get.offAll(() => WithoutLoginHomeScreen());
  } else {
    CheckLoginmpinSetOrNotModel loginMpinData =
    await AuthBloc().checkLoginMPINSetOrNot(User.userId);

    if (loginMpinData.statusCode == 200 &&
        loginMpinData.data!.loginMpin != null) {

     if(showCheckMpin) {
       Get.offAll(() => LoginMPINScreen());
     }else{
       Get.offAll(() => MainScreen());
     }

    } else {
      Get.offAll(() => SetLoginMPINScreen());
    }

    // Get.offAll(() => MainScreen());
  }
  if (imgUrl != null) {
    AppDialogs.homePopupImage(imgUrl);
  }
}

void setScreenDimensions(BuildContext context) {
  screenHeight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;
}

void snackBarMessage(String msg) {
  Get.rawSnackbar(
      messageText: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      animationDuration: Duration(milliseconds: 200),
      duration: Duration(seconds: 3));
}

void toastMessage(dynamic message,
    {ToastGravity gravity = ToastGravity.BOTTOM, bool isShort = true}) {
  log('toast: $message');
  Fluttertoast.showToast(
    msg: '$message',
    gravity: gravity,
    toastLength: isShort ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
  );
}

String parseformatDate(var _dt, [String? _format]) {
  var dateformat = new DateFormat(_format);
  DateFormat apidatedateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  try {
    return dateformat.format(apidatedateFormat.parse(_dt));

    // DateFormat(_format).format(DateTime.parse(_dt));
  } catch (e) {
    try {
      return DateFormat(_format).format(DateTime.parse(_dt));
    } catch (e2) {
      return '<ErrDate>';
    }
  }
}

String getDateGap(String dateReceived) {
  try {
    DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
    DateTime dateTimeNow = DateTime.now();
    final differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inDays;
    print('$differenceInDays');
    return '$differenceInDays';
  } catch (e) {
    return "";
  }
}

double getFileSizeInMb(File file) {
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);

  print('${file.path}: $sizeInMb');
  return sizeInMb;
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

List states = [
  "Andaman and Nicobar (UT)",
  "Andhra Pradesh",
  "Arunachal Pradesh",
  "Assam",
  "Bihar",
  "Chandigarh (UT)",
  "Chhattisgarh",
  "Dadra and Nagar Haveli (UT)",
  "Daman and Diu (UT)",
  "Delhi",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jammu and Kashmir",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Lakshadweep (UT)",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Orissa",
  "Puducherry (UT)",
  "Punjab",
  "Rajasthan",
  "Sikkim",
  "Tamil Nadu",
  "Telangana",
  "Tripura",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal"
];
