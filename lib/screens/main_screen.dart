import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/bloc/notifications_list_bloc.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/repositories/notifications_list_repository.dart';
import 'package:event_app/screens/drawer/happy_moments_screen.dart';
import 'package:event_app/screens/drawer/notification_screen.dart';
import 'package:event_app/screens/gifting_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/screens/profile/profile_details_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:event_app/widgets/common_drawer_widget.dart';
import 'package:event_app/util/string_constants.dart';
import 'package:event_app/util/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../bloc/wallet_bloc.dart';
import 'home_screen.dart';
import 'login/sign_up_completed_screen.dart';
import 'login/sign_up_screen.dart';
import 'profile/profile_screen.dart';
import 'package:badges/badges.dart' as badges;

class MainScreen extends StatefulWidget {
  final int showTab;
  final bool fromSignUp;
  const MainScreen({Key? key, this.showTab = 0,   this.fromSignUp=false}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with LoadMoreListener{
  ProfileBloc _profileBloc = ProfileBloc();
  late NotificationListBloc _notificationsBloc;
  NotificationListRepository _repository=NotificationListRepository();
  bool isLoadingMore = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _currentTab = 0;
  DateTime? currentBackPressTime;
  String accountId = User.userId;

  late VoidCallback refreshUIFn;
  WalletBloc _walletBloc = WalletBloc();
   bool? prepaidCardUserOrNot;
   bool?prepaidCardUserOrNotToken;
  @override
  void initState() {
    super.initState();
    getPrepaidCardUserOrNot();
    getPrepaidCardUserOrNotToken();

    _notificationsBloc = NotificationListBloc(this);
    _notificationsBloc.getList(false);
    _repository.getList(1, 20);
    _notificationsBloc.getList(false);
  // Timer(const Duration(seconds: 20), () async {
  //   Get.offAll(() => LoginMPINScreen());
  // });
    _currentTab = widget.showTab;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshUIFn = () {
        if (mounted) {
          setState(() {});
        }
      };
      User.userImageUrlValueNotifier.addListener(refreshUIFn);

      bool b = await checkUserInfo();
      if (!b) {
      await  AuthBloc().checkIsMobileEmailVerified(User.userId);
      }


    });
  }
  getPrepaidCardUserOrNotToken() async {
    prepaidCardUserOrNotToken = await _profileBloc.tokencard(accountId);
    setState(() {});
  }
  getPrepaidCardUserOrNot() async {
    prepaidCardUserOrNot = await _profileBloc.confirmWalletUser(accountId);
     setState(() {});
  }


  @override
  void dispose() {
    User.userImageUrlValueNotifier.removeListener(refreshUIFn);
    _notificationsBloc.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: StringConstants.doubleBackExit);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: _currentTab == 0
              ? AppBar(
            flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [primaryColor,secondaryColor],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(
                        CupertinoIcons.text_alignleft,
                        color: Colors.white,
                        size: 30,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      }),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20,top: 5,bottom: 5),
                          child: badges.Badge(
                            position: badges.BadgePosition.topEnd( top:0,end:3),
                            badgeContent: Text(
                              '${notificationcount}',
                              style:TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                            showBadge: true,
                            child: IconButton(
                              icon: Icon(
                                Icons.notifications_none_rounded,size: 35,
                              ),
                              onPressed: () {
                                Get.to(() => NotificationScreen());
                              },
                            ),
                          ),
                        ),
                         Padding(
            padding: const EdgeInsets.only(right: 20,top: 10,bottom: 5),
            child: InkWell(
              onTap: (){
                Get.to(() => ProfileDetailsScreen());
              },
              child: CircleAvatar(
                            backgroundColor: Colors.black87,
                            radius: 25,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:'${User.userImageUrl}',
                                 // '${userData?.baseUrl}${userData?.userDetails?.imageUrl}',
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/ic_avatar.png',
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
            ),
          ),
                      ],
                  // actions: [
                  //   FutureBuilder<String>(
                  //       future:_getTouchPoints(),
                  //       builder:
                  //           (BuildContext context, AsyncSnapshot<String> snapshot) {
                  //         String version = '';
                  //         if (snapshot.connectionState == ConnectionState.done &&
                  //             snapshot.hasData && snapshot.data != null) {
                  //           return Center(
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(100),
                  //                 color: secondaryColor,
                  //               ),
                  //               margin: const EdgeInsets.only(right: 8),
                  //               padding: const EdgeInsets.all(12),
                  //               child: Row(
                  //                 children: [
                  //                   Image.asset(
                  //                     'assets/images/ic_coins.png',
                  //                     height: 12,
                  //                   ),
                  //                   Text(
                  //                     '${snapshot.data}',
                  //                     style: TextStyle(
                  //                         fontSize: 16, fontWeight: FontWeight.w600),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         }
                  //         return SizedBox();
                  //       }),

                  // ],
                )
              : AppBar(
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(
                        CupertinoIcons.text_alignleft,
                        color: Colors.white,
                        size: 30,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      }),
                ),
          drawer: CommonDrawerWidget(),
          bottomNavigationBar: _currentTab == 0 ? CommonBottomNavigationWidget()
         :BottomNavigationBar(
            currentIndex: _currentTab,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/ic_home.png',
                    height: 20,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/ic_home_selected.png',
                    height: 20,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/ic_profile.png',
                    height: 20,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/ic_profile_selected.png',
                    height: 20,
                  ),
                  label: 'Profile'),
            ],
            onTap: (index) {
              if (_currentTab != index) {
                setState(() {
                  _currentTab = index;
                });
              }
            },
          ),
          body: _currentTab == 0 ?
          widget.fromSignUp?
          SignUpCompletedScreen()
          :  HomeScreen()
              : ProfileScreen()),
    );
  }

 
  Widget bottomNavigationWidget()  {
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
           
              onTap: ()  async {
                if( prepaidCardUserOrNot == true) {
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
                }
               
               else{
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
                      size: 32,
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
                      size: 32,
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
                   
                    Icon(
                      Icons.home,
                      color: primaryColor,
                      size:34 ,
                    ),
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
              onTap: ()  {
              Get.to(() => HappyMomentsScreen());
                //Get.to(() =>   CategoryListScreen());
                
              },
              child: SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border_purple500_outlined, color: Colors.grey, size: 32),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      "H! Rewards",
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
              onTap: () async{
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
                    Icon(Icons.more_horiz,
                        color: Colors.grey, size: 32),
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

Widget imageDialog( context) {
return Dialog(
  // backgroundColor: Colors.transparent,
  // elevation: 0,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close_rounded),
          color: Colors.redAccent,
        ),
      ),
      Container(
        width: 220,
        height: 400,
        child:  ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
           child: Image(
            image: AssetImage('assets/images/help_&_support_image.jpg'),
          width: double.infinity,
          height: 230,
                    fit: BoxFit.fill,),
         ),
      ),
    ],
  ),
);}
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
      print(isLoadingMore);
    }
  }
}