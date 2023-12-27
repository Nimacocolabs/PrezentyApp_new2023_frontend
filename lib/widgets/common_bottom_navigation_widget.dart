import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/repositories/profile_repository.dart';
import 'package:event_app/screens/gifting_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/screens/profile/profile_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/drawer/happy_moments_screen.dart';

class CommonBottomNavigationWidget extends StatefulWidget implements PreferredSizeWidget {
  const CommonBottomNavigationWidget();

  @override
  State<CommonBottomNavigationWidget> createState() => _CommonBottomNavigationWidgetState();
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  new Size.fromHeight(50);
}

class _CommonBottomNavigationWidgetState extends State<CommonBottomNavigationWidget> {
  ProfileBloc _profileBloc = ProfileBloc();
    bool? prepaidCardUserOrNot;
   bool?prepaidCardUserOrNotToken;

@override
void initState() {
  super.initState();
  getPrepaidCardUserOrNot();
  getPrepaidCardUserOrNotToken();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    getPrepaidCardUserOrNotToken();
    getPrepaidCardUserOrNot();});
}

  getPrepaidCardUserOrNotToken() async {
    prepaidCardUserOrNotToken = await _profileBloc.tokencard(User.userId);
    setState(() {});
  }
  getPrepaidCardUserOrNot() async {
    prepaidCardUserOrNot = await _profileBloc.confirmWalletUser(User.userId);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2), color: Colors.white10),
      height: 70,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () async {
                  if (prepiad_user == true) {
                    Get.to(() => WalletHomeScreen(isToLoadMoney: false,));
                    //  bool? hasMpin = await _walletBloc.getMPinStatus(User.userId);
                    //           if(hasMpin!=null) {
                    //             if (hasMpin) {
                    //               Get.to(() => AuthMPinScreen());
                    //             } else {
                    //               Get.to(() => SetWalletPin());
                    //             }
                    //           }else{
                    //             toastMessage('Unable to open wallet');
                    //           }
                    // Get.to(() => AuthMPinScreen());
                  } else {
                    Get.to(() => ApplyPrepaidCardListScreen(isUpgrade: false));
                  }
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.grey,
                        size: 30,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Wallet",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )),
          )),
          Expanded(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  //Get.to(() => CreateNewEventScreen());
                  Get.to(() => GiftingScreen(currentPageIndex: 1,));
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wallet_giftcard_outlined,
                        color: Colors.grey,
                        size: 30,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Gifting",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )),
          )),
          Expanded(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  Get.to(() => MainScreen());
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: Icon(
                          Icons.home,
                          size: 34,
                        ),
                      ),
                      // Icon(
                      //   Icons.home,
                      //   color: primaryColor,
                      //   size: 34,
                      // ),
                      SizedBox(height: 3),
                      Text(
                        "Home",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )),
          )),
          Expanded(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  Get.to(() => HappyMomentsScreen());
                  //Get.to(() =>   CategoryListScreen());
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_border_purple500_outlined,
                          color: Colors.grey, size: 32),
                      SizedBox(
                        height: 0,
                      ),
                      Text(
                        "H! rewards",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )),
          )),
          Expanded(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () async {
                  // await showDialog(
                  //   context: context,
                  //   builder:  (_) => imageDialog( context));
                  Get.to(() => ProfileScreen());
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more_horiz, color: Colors.grey, size: 32),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "More",
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                )),
          )),
        ],
      ),
    );
  }
}