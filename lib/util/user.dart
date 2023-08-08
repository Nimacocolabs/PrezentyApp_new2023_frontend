import 'package:flutter/material.dart';

import 'chat_data.dart';

class User {
  static String apiToken = '';
  static String userId = '';
  static String userName = '';
  static String userEmail = '';
  static String userRole = '';
  static String userMobile = '';
  static String userAddress = '';
  static String happyMomentId = '';
  static String userHiCardNo = '';
  static String userHiCardPin = '';
  static String userHiCardBalance = '';

  // static bool userHasMPin = false;

  static String userImageUrl = '';
  static ValueNotifier userImageUrlValueNotifier = ValueNotifier("");

  static void set(
    String token,
    String id,
    String name,
    String email,
    String role,
    String imageUrl,
    String mobile,
    String address,
    String happyCardId,
    String hiCardNo,
    String hiCardPin,
    String hiCardBalance,

    // bool hasMPin
  ) {
    apiToken = token;

    userId = id;

    userName = name;
    userEmail = email;
    ChatData.chatUserEmail = email;
    userRole = role;
    userMobile = mobile;
    userAddress = address;
    userImageUrl = imageUrl;
    userImageUrlValueNotifier.value = imageUrl;
    // userHasMPin = hasMPin;
    happyMomentId = happyCardId;
    userHiCardNo = hiCardNo;
    userHiCardPin = hiCardPin;
    userHiCardBalance = hiCardBalance;
  }
}
