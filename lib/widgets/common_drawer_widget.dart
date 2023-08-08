import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/screens/drawer/contact_us_screen.dart';
import 'package:event_app/screens/drawer/favourite_list_screen.dart';
import 'package:event_app/screens/drawer/happy_moments_screen.dart';
import 'package:event_app/screens/drawer/my_events_list_screen.dart';
import 'package:event_app/screens/drawer/my_vouchers/my_vouchers_screen.dart';
import 'package:event_app/screens/drawer/notification_screen.dart';
import 'package:event_app/screens/drawer/spin_voucher_list_screen.dart';
import 'package:event_app/screens/event/event_video_wish_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/faq_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/prepaid_cards_wallet/my_cards_wallet/Component/offers.dart';
import '../screens/profile/profile_screen.dart';

class CommonDrawerWidget extends StatefulWidget {
  const CommonDrawerWidget({Key? key}) : super(key: key);

  @override
  State<CommonDrawerWidget> createState() => _CommonDrawerWidgetState();


}

class _CommonDrawerWidgetState extends State<CommonDrawerWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Material(
              color: secondaryColor.shade800,
              child: SafeArea(
                child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                    Get.to(() => ProfileScreen());
                    // setState(() {
                    //   _currentTab = 1;
                    // });
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(26, 26, 26, 26),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        Container(
                            width: screenWidth * .18,
                            height: screenWidth * .18,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: secondaryColor.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${User.userImageUrlValueNotifier.value}',
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  margin: EdgeInsets.all(5),
                                  child: Image(
                                    image:
                                        AssetImage('assets/images/ic_avatar.png'),
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${User.userName}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${User.userEmail}',
                              style: TextStyle(
                                color: secondaryColor.shade200,
                              ),
                            ),
                          ],
                        ))
                      ])),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: secondaryColorShade,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    _drawerMenuItem(
                        Image.asset('assets/images/ic_nav_notification.png'),
                        'Notifications', () {
                      Get.to(() => NotificationScreen());
                    }),
                    _drawerMenuItem(
                        Image.asset('assets/images/hi_icon.png'),
                        'H! Rewards', ()  {
                       Get.to(() => HappyMomentsScreen());
                    }),
                    _drawerMenuItem(
                        Image.asset('assets/images/ic_nav_my_events.png'),
                        'My Events', () async {
                      await Get.to(() => MyEventsListScreen());
                    }),
                    _drawerMenuItem(
                        Image.asset('assets/images/ic_nav_my_wishes.png'),
                        'My Wishes', () {
                      Get.to(() => EventVideoWishListScreen(
                            eventId: null,
                          ));
                    }),
                    _drawerMenuItem(
                        Image.asset('assets/images/ic_nav_my_orders.png'),
                        'My Vouchers', () {
                      Get.to(() => MyVouchersScreen(showAppBar: true,));
                    }),
                    _drawerMenuItem(
                        Image.asset('assets/images/ic_nav_my_favourites.png'),
                        'My Favourites', () {
                      Get.to(() => FavouritesListScreen());
                    }),
                    _drawerMenuItem(
                        Image.asset('assets/images/ic_nav_my_orders.png'),
                        'Spin Vouchers', () {
                      Get.to(() => SpinVoucherListScreen());
                    }),
                     _drawerMenuItem(
                       Icon(Icons.attractions_outlined,color: Colors.white38,),
                        'Offers', () {
                      Get.to(() => Offers());
                    }),
                    _drawerMenuItem(
                       Icon(Icons.question_answer_outlined,color: Colors.white38,),
                        'FAQ', () {
                      Get.to(() => FAQScreen());
                    }),
                    _drawerMenuItem(
                        Center(
                          child: Icon(
                            Icons.call_rounded,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        'Contact Us', () {
                      Get.to(() => ContactUsScreen());
                    }),
                  ],
                ),
              ),
            ),
            Material(
              color: secondaryColor.shade800,
              child: InkWell(
                  child: Container(
                      padding: EdgeInsets.all(26),
                      child: Row(children: [
                        Icon(Icons.exit_to_app_rounded,
                            color: secondaryColor.shade200),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 17,
                          ),
                        ))
                      ])),
                  onTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Are you sure want to log out?'),
                          actions: [
                            OutlinedButton(
                              child: Text('No'),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              child: Text('Yes'),
                              onPressed: () {
                                //  Get.back();
                                SharedPrefs.logOut();
                                //Get.offAll(() => WithoutLoginHomeScreen());
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
    );
  }
   Widget _drawerMenuItem(Widget widget, String title, Function onTap) {
    return Material(
      color: secondaryColorShade,
      child: InkWell(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Row(children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: secondaryColor,
                  ),
                  child: widget,
                ),
                SizedBox(width: 12),
                Expanded(
                    child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ))
              ])),
          onTap: () {
            _scaffoldKey.currentState?.openEndDrawer();
            onTap();
          }),
    );
  }
}