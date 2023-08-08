import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import 'package:crypto/crypto.dart';
import 'package:event_app/screens/chat/chat_screen.dart';
import 'package:event_app/screens/common_notifications_screen.dart';
import 'package:event_app/screens/drawer/bid_notification_screen.dart';
import 'package:event_app/screens/drawer/notification_screen.dart';
import 'package:event_app/screens/event/received_payments_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_helper.dart';
import 'chat_data.dart';
import 'shared_prefs.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Notifications {


  static void init() {

    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("146c8ca5-723e-4616-aaca-765389534403");
// 146c8ca5-723e-4616-aaca-765389534403

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   log('additionalDatasxasx:${result.notification.additionalData}');
    //     print("ghjnghj");
    //     // Extract the custom data from the notification payload
    //     Map<String, dynamic> data = result.notification.additionalData ?? {};
    //     String screen = data['screen'];
    //     print("notification-->${screen}");
    //     // Navigate to the appropriate screen based on the custom data
    //     if (screen == 'notification') {
    //       Get.to(() => NotificationScreen(
    //       ));
    //       // Navigator.pushNamed(context as BuildContext, '/home');
    //     } else  {
    //       Get.to(() => MainScreen(
    //       ));
    //     }
    //     // Add more conditions as per your app's requirements
    //
    //
    //
    // });

    void checkPayload(OSNotificationOpenedResult notificationObj) {
      OSNotification notification = notificationObj.notification;
      if (notification != null) {
        print("**************");
        print(notification);
        print("**************");
        if (notification.rawPayload != null) {
          print("**************");
          print(notification.rawPayload);
          print("Title : ");
          print(notification.rawPayload!.containsKey("title"));
          print("Body : ");
          print(notification.rawPayload!.containsKey("body"));
          print(notification.additionalData);
          print("**************");
          if (notification.additionalData != null) {
            var notify = notification.additionalData;
            print("**************notification additional data");
            print(notify.toString());
            if (notify!.containsKey("screen") && notify.containsKey("value")) {
              if (notify["screen"] == "notification") {
                Get.to(() => NotificationScreen());
              }
            }
          } else {
            print("**************");
            print("Notification payload additional data is null");
            print("**************");
          }
        } else {
          print("**************");
          print("Notification payload is null");
          print("**************");
        }
      } else {
        print("**************");
        print("Notification s null");
        print("**************");
      }
    }


    // OneSignal.shared.setNotificationWillShowInForegroundHandler(
    //         (OSNotificationReceivedEvent event) {
    //           print("sdfghj");
    //       // Will be called whenever a notification is received in foreground
    //       // Display Notification, pass null param for not displaying the notification
    //
    //       log('additionalData:${event.notification.additionalData}');
    //       // toastMessage('setNotificationWillShowInForegroundHandler\nadditionalData:${event.notification.additionalData}');
    //
    //       Map<String, dynamic> data = event.notification.additionalData ?? {};
    //       try {
    //         if (data['screen'] == "notification") {
    //           Get.to(() => NotificationScreen(
    //           ));
    //         };
    //       } catch (e, s) {
    //         Completer().completeError(e, s);
    //       }
    //     });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification

      log('additionalData:${event.notification.additionalData}');
      // toastMessage('setNotificationWillShowInForegroundHandler\nadditionalData:${event.notification.additionalData}');

      Map<String, dynamic> data = event.notification.additionalData ?? {};
      try {
        if (data['sender_email'] == ChatData.chatUserEmail) return;

        if (data.isNotEmpty) {
          if (data['type'] == 'message' &&
              data['event_id'] == '${ChatData.eventId}') {
            // if(ChatData.chatMessageList.any((element) => data['id']==element.id)) return;
            // ChatData.chatMessageList.insert(0, ChatMessage.fromNotificationJson(data));
            ChatData.valueNotifierReLoadMessages.value = !ChatData.valueNotifierReLoadMessages.value;
          } else {
            event.complete(event.notification);
          }
        } else {
          event.complete(event.notification);
        }
      } catch (e, s) {
        Completer().completeError(e, s);
      }
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.

      Map<String, dynamic> data = result.notification.additionalData ?? {};
      Map<String, dynamic> data1 = result.notification.rawPayload ?? {};
      // toas Map<String, dynamic> data = result.notification.additionalData ?? {};tMessage('setNotificationOpenedHandler\nadditionalData:${jsonEncode(data)}');
      print('**************${jsonEncode(data)}');
      print('********data1******${jsonEncode(data1)}');
      print('**************${ data1.containsKey}');

      try{
        if (data.isNotEmpty) {
          try {
            if(navigatorKey.currentContext==null){
              //set notification
              await SharedPrefs.init();
              await SharedPrefs.setNotificationData(data);
            }else{
              if (data['type'] == 'message') {
                //chat
                if (data['isGroupMessage']) {
                  Get.to(() => ChatScreen(
                      isFromNotification: true,
                      eventId: int.parse('${data['event_id']}')));
                } else {
                  Get.to(() => ChatScreen(
                      isFromNotification: true,
                      eventId: int.parse('${data['event_id']}'),
                      opponentEmail: data['sender_email']),);
                }
              } else if (data['type'] == 'receive_event_gift') {
                Get.off(() => ReceivedPaymentsScreen(eventId: data['event_id'], isFromNotification: true));
              }  else if(data['type'] == 'general'){
                Get.off(() => CommonNotificationScreen(notificationContent: data['message'] ));
              }
              else if (data['type'] == 'go_live') {
                //go live
                //todo changed for ios
                String url = "https://meet.jit.si/${md5.convert(utf8.encode('event:${data['event_id']}')).toString()}";
                if(await canLaunchUrl(Uri.parse(url))){
                  launchUrl(Uri.parse(url));
                }else{
                  toastMessage('Unable to open $url');
                }

                  //Get.to(() => MeetingOngoingScreen(
                  //     isFromNotification: true,
                  //     eventId: int.parse('${data['event_id']}'),
                  //     eventTitle: data['event_name'] ?? '',
                  //   ));
              }
              if(data['screen'] == 'notification'){
                print("notification");
                Get.to(() => BidNotificationScreen(
                    isFromNotification: true,title: data["title"] ?? '',
                  imageUrl :data["image"] ?? '',url :data["url"] ?? ''
                  ));
              }else{
              };
            }
          } catch (e, s) {
            Completer().completeError(e, s);
          }
        }
      } catch (e, s) {
        Completer().completeError(e, s);
      }


      // if(data.isNotEmpty) {
      //   if (data['isGroupMessage']) {
      //     Get.to(() =>
      //         ChatScreen(
      //             isFromNotification: true,
      //             eventId: int.parse(data['event_id']) ));
      //   } else {
      //     Get.to(() =>
      //         ChatScreen(
      //             isFromNotification: true,
      //             eventId: int.parse(data['event_id']),
      //             opponentEmail: data['sender_email']));
      //   }

      // Go Live notification
      // DateTime dt1 = DateHelper.getDateTime(_eventDetails!.detail!.date!);
      // DateTime dt2 = DateHelper.getDate(DateTime.now());
      //
      // if(dt1!=dt2){
      //   toastMessage('Live stream can only be started on the day of event');
      // }else {
      //   Get.to(() => MeetingOngoingScreen(isFromNotification: true));
      // }
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }


  static setUserId(String userId) {
    OneSignal.shared.sendTag("user_id", "$userId").then((response) {
      print("Successfully sent tags with response: $response");
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }

  static removeUserId() {
    OneSignal.shared.deleteTag("user_id").then((response) {
      print("Successfully removed tags with response: $response");
    }).catchError((error) {
      print("Encountered an error removing tags: $error");
    });
  }
}
