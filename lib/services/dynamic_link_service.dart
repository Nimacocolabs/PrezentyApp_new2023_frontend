import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:event_app/screens/EventDeeplink/event_invite_details_screen.dart';
import 'package:event_app/screens/chat/chat_screen.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/screens/event/received_payments_screen.dart';
import 'package:event_app/screens/home_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/without_login_home_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/common_methods.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/user.dart';

class DynamicLinkService {
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      showPage(deepLink);
    }, onError: (OnLinkErrorException e) async {
      print("deeplink error");
      print(e.message);
      showPage(null);
      Get.snackbar("Oops!!", "Unable to open the page",
          backgroundColor: primaryColor,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          shouldIconPulse: true,
          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
          icon: Icon(
            Icons.warning_amber_sharp,
            color: Colors.white,
          ));
    });

    try {
      final PendingDynamicLinkData data =
          (await FirebaseDynamicLinks.instance.getInitialLink())!;
      final Uri deepLink = data.link;
      CommonMethods().removeStoredEventsInfo();
      showPage(deepLink);
    } catch (e) {
      showPage(null);
    }
  }

  /*
  we need to create our own in needed, dummy function

  eg: use this while share
   var link = await DynamicLinkService().createDynamicLink(4);
   Note: then pass this link.


   */
  // Future<dynamic> createDynamicLink(var eventId) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://cocoalabs.page.link',
  //     // link: Uri.parse('https://www.presenty.com/event?event_id=$eventId'),
  //     link: Uri.parse('https://www.cocoalabs.in/Event/rsvp/rsvp#/home/$eventId'),
  //     androidParameters: AndroidParameters(
  //       packageName: 'com.cocoalabs.event_app',
  //       minimumVersion: 1,
  //       fallbackUrl: Uri.parse('https://www.cocoalabs.in/Event/rsvp/rsvp#/home?event_id=$eventId')
  //     ),
  //     iosParameters: IosParameters(
  //       bundleId: 'com.cocoalabs.eventApp',
  //       minimumVersion: '1',
  //       fallbackUrl: Uri.parse('https://www.cocoalabs.in/Event/rsvp/rsvp#/home?event_id=$eventId')
  //       //appStoreId: '123',
  //     ),
  //     /*socialMetaTagParameters: SocialMetaTagParameters(
  //       title: 'Example of a Dynamic Link',
  //       description: 'This link works whether app is installed or not!',
  //     ),*/
  //   );

  //   final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
  //   final Uri shortUrl = shortDynamicLink.shortUrl;
  //   return shortUrl;
  // }

  Future<dynamic> createDynamicLink(
      var eventId, String? eventImageUrl, String eventTitle) async {
    Uri uri = Uri.parse(
        'https://prezenty.page.link/?link=https://prezenty.in/rsvp/%23/?event_id=${eventId.toString()}&apn=com.cocoalabs.event_app&ibi=com.cocoalabs.event&st=${eventTitle}&sd=To%20participate%2FOnline%20gifting&si=${eventImageUrl ?? ''}');
    final ShortDynamicLink shortenedLink0 =
        await DynamicLinkParameters.shortenUrl(
      uri,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );

    print(uri.toString());
    print(shortenedLink0.shortUrl);

    return shortenedLink0.shortUrl;

    // // String socialParams = '&st=${eventTitle}&sd=To participate/Online gifting&si=${eventImageUrl??''}';
    // // String longUrl = 'https://prezenty.page.link/?link=https://prezenty.in/rsvp/%23/?event_id=${eventId }&apn=com.cocoalabs.event_app&ibi=com.cocoalabs.eventApp${socialParams}';
    //
    // String link = 'https://prezenty.page.link/?link=https://prezenty.in/rsvp/%23/?event_id=${eventId}';
    //
    // final DynamicLinkParameters parameters = DynamicLinkParameters(
    //   uriPrefix: 'https://prezenty.page.link',
    //   link: Uri.parse(link),
    //   androidParameters: AndroidParameters(
    //       packageName: 'com.cocoalabs.event_app',
    //       minimumVersion: 1,
    //       fallbackUrl: Uri.parse(link)),
    //   iosParameters: IosParameters(
    //     bundleId: 'com.cocoalabs.event',
    //     minimumVersion: '1',
    //     fallbackUrl: Uri.parse(link),
    //     // appStoreId: '1589909513',
    //   ),
    //   socialMetaTagParameters: SocialMetaTagParameters(
    //     imageUrl: Uri.parse(eventImageUrl??''),
    //     title: eventTitle,
    //     description: 'To participate/Online gifting'
    //   ),
    // );
    //
    // var uri = await parameters.buildUrl();
    // final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    // final Uri shortUrl = shortDynamicLink.shortUrl;
    //
    // // log('longUrl: $longUrl');
    // log('uri: ${uri.toString()}');
    // debugPrint('shortUrl: $shortUrl');
    //
    // return shortUrl;
  }

  Future<dynamic> createDynamic1Link(
     ) async {
    Uri uri = Uri.parse(
      'https://prezenty.page.link/?link=https://prezenty.in/WalletHomeScreen/&apn=com.cocoalabs.event_app&ibi=com.cocoalabs.event&sd=To%20participate%2FOnline%20gifting');
    final ShortDynamicLink shortenedLink0 =
    await DynamicLinkParameters.shortenUrl(
      uri,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );

    print(uri.toString());
    print(shortenedLink0.shortUrl);

    return shortenedLink0.shortUrl;
  }

  void showPage(Uri? deepLink) async {
    if (deepLink != null) {
      await SharedPrefs.clearNotificationData();

      String url = Uri.decodeFull(deepLink.toString());
      if (url.toString().contains('event_id=')) {
        int index = url.toString().indexOf('event_id=') + 9;
        bool b = url.toString().contains('&', index);

        String id = url.toString().substring(
            index, (b ? url.toString().indexOf('&') : url.toString().length));

        log(id);
        int eventId = int.parse(id);

        Get.offAll(
            () => EventInviteDetailsScreen(
                eventId: eventId, isFromDynamicLink: true),
            transition: Transition.fade);
      } else {
        goToHomeScreen();
        // Get.offAll(() =>  WoohooVoucherListScreen(
        //       redeemData: RedeemData.buyVoucher(),
        //       showBackButton: false,
        //     )
        //    );

        // if (User.apiToken.isEmpty) {
        //   Get.offAll( () => LoginScreen( isFromWoohoo: false, ),
        //       transition: Transition.fade);
        // } else {
        //   Get.offAll(() => MainScreen(), transition: Transition.fade);
        // }
      }
    } else {
      Map<String, dynamic> data = SharedPrefs.getNotificationData();
      if (data.isNotEmpty) {
        await SharedPrefs.clearNotificationData();
        if (data['type'] == 'message') {
          //chat
          if (data['isGroupMessage']) {
            Get.off(() => ChatScreen(
                isFromNotification: true,
                eventId: int.parse('${data['event_id']}')));
          } else {
            Get.off(
              () => ChatScreen(
                  isFromNotification: true,
                  eventId: int.parse('${data['event_id']}'),
                  opponentEmail: data['sender_email']),
            );
          }
        } else if (data['type'] == 'receive_event_gift') {
          Get.off(() => ReceivedPaymentsScreen(
              eventId: data['event_id'], isFromNotification: true));
        } else if (data['type'] == 'go_live') {
          Get.offAll(() => WoohooVoucherListScreen(
                redeemData: RedeemData.buyVoucher(),
                showBackButton: false,
                showAppBar: true,
                
              ));
          //go live
          //todo changed for ios
          String url =
              "https://meet.jit.si/${md5.convert(utf8.encode('event:${data['event_id']}')).toString()}";
          if (await canLaunch(url)) {
            launch(url);
          } else {
            toastMessage('Unable to open $url');
          }
          //Get.to(() => MeetingOngoingScreen(
          //     isFromNotification: true,
          //     eventId: int.parse('${data['event_id']}'),
          //     eventTitle: data['event_name'] ?? '',
          //   ));
        }
        // log(data['event_id']);
      } else {
        goToHomeScreen();
        // if (User.apiToken.isEmpty) {
        //
        //   Get.offAll(() => WithoutLoginHomeScreen());
        //
        // }else{
        //   Get.offAll(() => MainScreen());
        //   //  WoohooVoucherListScreen(
        //   //       redeemData: RedeemData.buyVoucher(),
        //   //       showBackButton: false,
        //   //     ));
        // }
      }
      // if (User.apiToken.isEmpty) {
      //   Get.offAll(
      //       () => LoginScreen(
      //             isFromWoohoo: false,
      //           ),
      //       transition: Transition.fade);
      // } else {
      //   Get.offAll(() => MainScreen(), transition: Transition.fade);
      // }
    }
    await SharedPrefs.clearNotificationData();
  }
}
