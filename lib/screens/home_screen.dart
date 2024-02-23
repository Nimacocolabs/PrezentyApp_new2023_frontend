import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/interface/FavouritesUpdatedListener.dart';
import 'package:event_app/models/homscreen_common_apis_model.dart';
import 'package:event_app/models/touchpoint_wallet_balance_response.dart';
import 'package:event_app/models/home_events_response.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/profile_repository.dart';
import 'package:event_app/screens/deals_for_you_details_screen.dart';
import 'package:event_app/screens/drawer/happy_moments_screen.dart';
import 'package:event_app/screens/drawer/tambola_game_screen.dart';
import 'package:event_app/screens/event/create_new_event_screen.dart';
import 'package:event_app/screens/event/my_events_and_invites_screen.dart';
import 'package:event_app/screens/gifting_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/help_and_support_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/screens/profile/invite_and_earn.dart';
import 'package:event_app/screens/spin_wheel_timer_button.dart';
import 'package:event_app/screens/woohoo/food_and_movie_products_list.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/chat_data.dart';
import 'package:event_app/util/common_methods.dart';
import 'package:event_app/util/notifications.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/succes_or_failed_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:get/get.dart';
import '../bloc/wallet_bloc.dart';

import '../models/woohoo/woohoo_product_list_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with FavouritesUpdatedListener {
  EventBloc _bloc = EventBloc();
  WoohooProductBloc _woohooBloc = WoohooProductBloc();

  ProfileBloc _profileBloc = ProfileBloc();

  int eventsTabIndex = 0;
  int invitesTabIndex = 0;
  TextEditingController _textFieldControlSearch = TextEditingController();
  var searchText = '';
  String accountId = User.userId;
  HomscreenCommonApisModel? dataValue;
  String bank_info = "";
  String? coinBalance;
  String? imageBaseUrl =
      "https://prezenty.in/prezentycards-live/public/app-assets/image/prepaid_card_bg/";
  String? baseUrl =
      "https://prezentycards-live/public/app-assets/image/verified.png";
  String? sliderImageBaseUrl =
      "https://prezenty.in/prezentycards-live/public/app-assets/image/slider/";
  bool? prepaidCardUserOrNot;
  bool? prepaidCardUserOrNotToken;
  Future bankbalcInfo() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://prezenty.in/prezentycards-live/public/api/prepaid/cards/wallet-balance"),
        headers: {
          "Authorization": "Bearer ${TokenPrepaidCard}",
        },
      );
      Map jsonResponse = json.decode(response.body);
      print("response.body==>${jsonResponse}");
      bank_info = jsonResponse["balance"]["balance"];
      print("banace-->${bank_info = jsonResponse["balance"]["balance"]}");

      Get.back();
      if (response.statusCode == 200) {
        toastMessage(response.statusCode);
      } else {
        toastMessage('${response.statusCode}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  @override
  void initState() {
    super.initState();
    _reloadList();
    getPrepaidCardUserOrNotToken();


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getPrepaidCardUserOrNotToken();
      getPrepaidCardUserOrNot();
      _profileBloc = ProfileBloc();
      bankbalcInfo();
      getData();
      await _profileBloc.getProfileInfo();
      Notifications.setUserId(User.userEmail);
      ChatData.chatUserEmail = User.userEmail;
      CommonMethods().setFavouritesUpdatedListener(this);
    });
  }

  getPrepaidCardUserOrNotToken() async {
    prepaidCardUserOrNotToken = await _profileBloc.tokencard(User.userId);
    setState(() {});
  }

  getPrepaidCardUserOrNot() async {
    prepaidCardUserOrNot = await _profileBloc.confirmWalletUser(User.userId);
    setState(() {});
  }

  Future getData() async {
    dataValue = await _profileBloc.homeScreenCommonApi(User.userId);
    setState(() {});
  }

  _reloadList() {
    _woohooBloc.getProductList("", false);
  }

  _onSearchChanged(searchKey, [bool needWait = true]) {
    if (needWait) {
      Future.delayed(const Duration(milliseconds: 800), () {
        searchText = _textFieldControlSearch.text.trim();
        _bloc.getHomeList(false, searchText);
      });
    } else {
      searchText = _textFieldControlSearch.text.trim();
      _bloc.getHomeList(false, searchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: showExitAppPopup,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              child: RefreshIndicator(
                color: Colors.white,
                backgroundColor: primaryColor,
                onRefresh: () {
                  return _profileBloc.getProfileInfo();
                },
                child: StreamBuilder<ApiResponse<dynamic>>(
                    stream: _profileBloc.profileStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data?.status != null) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return CommonApiLoader();
                          case Status.COMPLETED:
                            UserSignUpResponse resp = snapshot.data?.data;
                            return headerWidget(resp);
                          case Status.ERROR:
                            return CommonApiResultsEmptyWidget(
                                "${snapshot.data?.message ?? ""}",
                                textColorReceived: Colors.black);
                          default:
                            print("");
                        }
                      }
                      return Container(
                        child: Center(
                          child: Text(""),
                        ),
                      );
                    }),
              ),
            ),
            _buildHomeScreenContent(),
          ],
        )),
      ),
    );
  }

  _buildHomeScreenContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(
        //   height: 10,
        // ),
        giftHiCardWidget(),
        // SizedBox(
        //   height: 4,
        // ),giftHiCardWidget(),
        // SizedBox(
        //   height:10
        // ),
        tambolaJoinWidget(),
        SizedBox(
          height: 10,
        ),
        newPrePaidCardWdiget(),
        SizedBox(
          height: 10,
        ),
        moreOptionsWidget(),
        SizedBox(
          height: 10,
        ),
        referAndEarnWidget(),
        SizedBox(
          height: 13,
        ),
        hotDealsAndPromotionsWidget(),
        SizedBox(
          height: 10,
        ),
        // upcomingEventsAndInvitesWidget(),
        SizedBox(
          height: 10,
        ),

        SizedBox(
          height: 10,
        ),
        mostPopularWidget(),
        SizedBox(
          height: 18,
        ),
        sliderBannerWidget(),
        SizedBox(
          height: 18,
        ),
        SpinWheelTimerButton(),
        //foodAndMovieWidget(),
        // SizedBox(
        //   height: 13,
        // ),
        // backToCampusWidget(),

        // backToCampusWidget(),
        SizedBox(
          height: 10,
        ),
        helpAndSuuport(),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget happyMomentsBalanceWdiget() {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.white,
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(49, 249, 152, 0.8),
                    Color.fromRGBO(159, 20, 211, 0.9)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // color: secondaryColor,
                    ),
                    child: Image(
                      image: AssetImage('assets/images/hi_icon.png'),
                      height: 37,
                      width: 37,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Expanded(
                  //   child: Text(
                  //     'My coins',
                  //     style: TextStyle(
                  //         color: secondaryColor,
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  Expanded(
                    child: Text(
                      'Happy Rewards',
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: Container(
                      width: 85,
                      height: 30,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Center(
                        child: Text(
                          '${rupeeSymbol} ${User.userHiCardBalance}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => HappyMomentsScreen());
                    },
                    icon: Icon(Icons.info_outline_rounded),
                    color: secondaryColor.shade500,
                  )
                ],
              ),
            ),
            onTap: () {
              Get.to(() => HappyMomentsScreen());
            },
          ),
        ),
      ),
    );
  }

  Widget giftHiCardWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 12),
      child: InkWell(
        onTap: () {
          Get.to(() => GiftingScreen(currentPageIndex: 1));
        },
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(212, 228, 253, 3),
                Color.fromRGBO(241, 206, 228, 3)
              ]),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Gift H! Rewards for\nyour loved ones.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "KaushanScript-Regular",
                  ),
                ),
                Spacer(),
                Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        Get.to(() => GiftingScreen(currentPageIndex: 1));
                      },
                      child: Text(
                        "Gift Now!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tambolaJoinWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 12),
      child: InkWell(
        onTap: () {
          Get.to(() => TambolaGameScreen());
        },
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 200,
            width: 360,
            // padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/images/tambola_game.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => TambolaGameScreen());
                    },
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Join Now",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    )),
                  )),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //       Color.fromRGBO(230, 228, 253, 3),
          //       Color.fromRGBO(241, 206, 228, 3)
          //     ]),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   height: 70,
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Image.asset('assets/images/ic_nav_tambola.png'),
          //       SizedBox(
          //         width: 15,
          //       ),
          //       Text(
          //         "Inviting all to \nEnjoy the game",
          //             // "\nyour loved ones.",
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 18,
          //           fontFamily: "KaushanScript-Regular",
          //         ),
          //       ),
          //       Spacer(),
          //       Container(
          //         height: 45,
          //         width: 150,
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(15),
          //             color: Colors.white),
          //         child: OutlinedButton(
          //             style: OutlinedButton.styleFrom(
          //                 shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(12))),
          //             onPressed: () {
          //               Get.to(() => TambolaGameScreen());
          //             },
          //             child: Text(
          //               "Join Now!",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(fontSize: 16, color: Colors.black),
          //             )),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget newPrePaidCardWdiget() {
    print("Card section");
    if (dataValue?.prepaidCards == null) {
      return CommonApiResultsEmptyWidget("");
    } else {
      return Container(
        padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
        height: 230,
        child: ImageSlideshow(
          width: double.infinity,
          height: screenHeight * 0.28,
          initialPage: 0,
          indicatorColor: Colors.white,
          indicatorBackgroundColor: Colors.white,
          onPageChanged: (value) {},
          autoPlayInterval: 3000,
          isLoop: true,
          children: dataValue?.prepaidCards?.map((PrepaidCards? e) {
                return Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: 230,
                          imageUrl: '${imageBaseUrl}${e!.bgImg ?? ""}',
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => SizedBox(
                            child: Image.asset('assets/images/no_image.png'),
                          ),
                        )),
                  ),
                  Positioned(
                    top: 50,
                    left: 5,
                    child: Text(
                      "${e.title ?? ""}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 5,
                    child: Text(
                      "${rupeeSymbol + e.amount.toString()}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.purple.shade900,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                      top: 150,
                      left: 10,
                      child: Container(
                        height: 45,
                        width: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              Get.to(() =>
                                  ApplyPrepaidCardListScreen(isUpgrade: false));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Get your card",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 9, top: 2, bottom: 2, right: 5),
                                  child: Icon(Icons.arrow_forward,
                                      size: 25, color: Colors.white),
                                ),
                              ],
                            )),
                      )),
                ]);
              }).toList() ??
              [],
        ),
      );
    }
  }

  hotDealsAndPromotionsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
          child: Text(
            "Hot Deals & Promotions",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            height: 180,
            child: Row(
              children: [
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => DealsForYouDetailsScreen(
                            isDealsForYou: true, isBackToCampus: false));
                      },
                      child: Container(
                        color: Colors.grey.shade200,
                        height: 110,
                        width: 90,
                        child: Center(
                          child: Text(
                            "\nBest Deals\nFor You",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    left: 30,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => DealsForYouDetailsScreen(
                            isDealsForYou: true, isBackToCampus: false));
                      },
                      child: Image(
                        image: AssetImage(
                            'assets/images/BestDealsForYou_image.png'),
                        width: 80,
                        height: 80,
                      ),
                    ),
                    // child: ShaderMask(
                    //   blendMode: BlendMode.srcIn,
                    //   shaderCallback: (Rect bounds) {
                    //     return LinearGradient(
                    //       colors: [primaryColor, secondaryColor],
                    //       tileMode: TileMode.mirror,
                    //     ).createShader(bounds);
                    //   },
                    //   child: Icon(
                    //     Icons.shopping_bag_outlined,
                    //     size: 60,
                    //   ),
                    // ),
                  ),
                ]),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => FoodAndMovieProductsListScreen());
                      },
                      child: Container(
                        color: Colors.grey.shade200,
                        height: 110,
                        width: 90,
                        child: Center(
                          child: Text(
                            "\nFood And\nMovies",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    left: 30,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => FoodAndMovieProductsListScreen());
                      },
                      child: Image(
                        image:
                            AssetImage('assets/images/FoodAndMovies_image.png'),
                        width: 80,
                        height: 80,
                      ),
                    ),
                    // child: ShaderMask(
                    //   blendMode: BlendMode.srcIn,
                    //   shaderCallback: (Rect bounds) {
                    //     return LinearGradient(
                    //       colors: [primaryColor, secondaryColor],
                    //       tileMode: TileMode.mirror,
                    //     ).createShader(bounds);
                    //   },
                    //   child: Icon(
                    //     Icons.fastfood_outlined,
                    //     size: 60,
                    //   ),
                    // ),
                  )
                ]),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => DealsForYouDetailsScreen(
                            isDealsForYou: false, isBackToCampus: true));
                      },
                      child: Container(
                        color: Colors.grey.shade200,
                        height: 110,
                        width: 90,
                        child: Center(
                          child: Text(
                            "\nBack To\nCampus",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    left: 30,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => DealsForYouDetailsScreen(
                            isDealsForYou: false, isBackToCampus: true));
                      },
                      child: Image(
                        image:
                            AssetImage('assets/images/BackToCampus_image.png'),
                        width: 80,
                        height: 80,
                      ),
                    ),
                    // child: ShaderMask(
                    //   blendMode: BlendMode.srcIn,
                    //   shaderCallback: (Rect bounds) {
                    //     return LinearGradient(
                    //       colors: [primaryColor, secondaryColor],
                    //       tileMode: TileMode.mirror,
                    //     ).createShader(bounds);
                    //   },
                    //   child: Icon(
                    //    Icons.school_outlined,
                    //     size: 60,
                    //   ),
                    // ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  moreOptionsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 15, right: 8, bottom: 35),
              child: InkWell(
                onTap: () {
                  Get.to(() => CreateNewEventScreen(
                        showAppBar: true,
                      ));
                },
                child: Container(
                  width: 95,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(159, 20, 211, 0.1)),
                  child: Column(
                    children: [
                      Image(
                        image:
                            AssetImage("assets/images/create_event_image.png"),
                        width: 80,
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 10, right: 8),
                        child: Text(
                          "Create Event",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 15, right: 8, bottom: 35),
              child: InkWell(
                onTap: () {
                  Get.to(() => GiftingScreen(currentPageIndex: 1));
                },
                child: Container(
                  width: 95,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(159, 20, 211, 0.1)),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage("assets/images/gifting_image.png"),
                        width: 80,
                        height: 60,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          "Gift\nNow",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 35),
              child: InkWell(
                onTap: () {
                  Get.to(() => WalletHomeScreen(
                        isToLoadMoney: true,
                      ));
                  // Navigator.of(context).push(MaterialPageRoute(builder:(context) =>  WalletHomeScreen(isToLoadMoney: true,)));
                },
                child: Container(
                  width: 95,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(159, 20, 211, 0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/send_money_image.png"),
                        width: 80,
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 10, right: 8),
                        child: Text(
                          "Send Money",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  referAndEarnWidget() {
    return InkWell(
      onTap: () {
        Get.to(() => InviteAndEarnScreen());
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image(
              image: AssetImage('assets/images/refer_and_earn.jpg'),
              width: double.infinity,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  mostPopularWidget() {
    return StreamBuilder<ApiResponse<dynamic>>(
        stream: _woohooBloc.itemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status!) {
              case Status.LOADING:
                return CommonApiLoader();

              case Status.COMPLETED:
                WoohooProductListResponse resp = snapshot.data!.data;

                return mostPopularCardsWidget(
                    resp.basePathWoohooImages ?? "", resp.data);

              case Status.ERROR:
                return CommonApiErrorWidget(snapshot.data!.message!, () {});
            }
          }

          return SizedBox();
        });
  }

  mostPopularCardsWidget(
      String imgUrl, List<WoohooProductListItem>? wohooCardData) {
    wohooCardData!.shuffle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
          child: Center(
            child: Text(
              "Most Popular",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 2,
          child: Column(
            children: [
              GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      // onTap: () async {
                      // await Get.to(() => WoohooVoucherDetailsScreen(
                      //     productId: productList[index].id ?? 0,
                      //     redeemData: widget.redeemData));
                      // },
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: wohooCardData[index].image !=
                                                null
                                            ? '${imgUrl}${wohooCardData[index].image}'
                                            : wohooCardData[index]
                                                    .imageMobile ??
                                                '',
                                        // productList[index].imageMobile ?? '',
                                        placeholder: (context, url) => Center(
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            SizedBox(
                                                child: Image.asset(
                                                    'assets/images/no_image.png'))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                                child: Text('${wohooCardData[index].name} \n',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              Center(
                child: Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        Get.to(() => WoohooVoucherListScreen(
                              redeemData: RedeemData.buyVoucher(),
                              showBackButton: true,
                              showAppBar: true,
                            ));
                        // Get.to(() => SpinGiftsWonScreen());
                        // Get.to(() => WoohooVoucherListScreen(
                        //       redeemData: RedeemData.buyVoucher(),
                        //       showBackButton: true,
                        //     ));
                      },
                      child: Text(
                        "View more",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
                ),
              ),
              SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }

  sliderBannerWidget() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
      height: 230,
      child: ImageSlideshow(
        width: double.infinity,
        height: screenHeight * 0.20,
        initialPage: 0,
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.white,
        onPageChanged: (value) {},
        isLoop: true,
        children: dataValue?.sliderImages?.map((SliderImages? e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () async {
                      // Get.to(() => DealsForYouDetailsScreen(
                      //     isDealsForYou: false, isBackToCampus: true));
                    },
                    child: CachedNetworkImage(
                      imageUrl: '${sliderImageBaseUrl}${e!.image}',
                      width: double.infinity,
                      height: screenHeight * 0.20,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => SizedBox(
                          child: Image.asset('assets/images/no_image.png')),
                    ),
                  ),
                ),
              );
            }).toList() ??
            [],
      ),
    );
  }

  helpAndSuuport() {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 12, right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.white,
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // color: secondaryColor,
                    ),
                    // child: Image(
                    //   image: AssetImage('assets/cards/hi_card.jpeg'),
                    //   height: 40,
                    //   width: 40,
                    // ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),

                  Expanded(
                    child: Text(
                      'Help and Support',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              Get.to(() => HelpAndSupportScreen());
              //Get.to(() => SuccessOrFailedScreen());
            },
          ),
        ),
      ),
    );
    // return Container(
    //   child: GestureDetector(
    //     onTap: () {
    //       Get.to(() => HelpAndSupportScreen());
    //       // Freshchat.showConversations();

    //       return;
    //     },
    //     child: Stack(children: [
    //       Padding(
    //          padding: const EdgeInsets.all(10),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(20.0),
    //           child: Image(
    //             image: AssetImage('assets/images/help_2.png',
    //             ),
    //             width: screenWidth,
    //             height: 100,
    //              fit: BoxFit.fill,
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top:25,left:340),
    //         child: Row(
    //           children: [
    //             // Text(
    //             //   "Help and support",
    //             //   style: TextStyle(
    //             //       color: Colors.black,
    //             //       fontWeight: FontWeight.bold,
    //             //       fontSize: 20),
    //             // ),
    //             // SizedBox(
    //             //   width: 10,
    //             // ),
    //             Icon(
    //               Icons.info_outline_rounded,
    //               color: Colors.black,
    //               size: 30,
    //             )
    //           ],
    //         ),
    //       )
    //     ]),
    //   ),
    // );
  }

  Widget headerWidget(UserSignUpResponse data) {
    return SizedBox(
      height: screenHeight * 0.3,
      child: Stack(clipBehavior: Clip.none, children: [
        Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(20, 20),
                    bottomRight: Radius.elliptical(20, 20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: [primaryColor, secondaryColor],
                  ),
                ),
                padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                width: screenWidth,
                height: screenHeight * 0.1,
                child: Column(
                  children: [
                    // Padding(
                    //     padding: const EdgeInsets.only(
                    //         top: 0,right: 290, bottom: 10),
                    //     child: Text("Hello,",
                    //     textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           fontSize: 16,
                    //         )),
                    //   ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 25, top: 10, left: 65),
                          child: Text('${data.userDetails?.name}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        ),
                        if (data.userDetails!.userVerified == "Yes")
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, bottom: 25, top: 5),
                            child: CachedNetworkImage(
                                width: 33,
                                imageUrl:
                                    'https://prezenty.in/prezentycards-live/public/app-assets/image/verified.png'),
                          ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
        Positioned(
          top: 65,
          left: 15,
          right: 15,
          bottom: 25,

          // bottom: -screenHeight * 0.05,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                )
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: screenWidth,
            // height: screenHeight * 0.25,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "My Wallet",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  dataValue?.checkCardUserOrNot == "no"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                                onTap: () async {
                                  Get.to(() => ApplyPrepaidCardListScreen(
                                      isUpgrade: false));
                                },
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [primaryColor, secondaryColor],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(40.0)),
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      Get.to(() => ApplyPrepaidCardListScreen(
                                          isUpgrade: false));
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40))),
                                    ),
                                    child: Text(
                                      "Get your card",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Image(
                                  image: AssetImage(
                                      'assets/cards/horizontal_with_logo.png'),
                                  height: 28,
                                  width: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Wallet Balance",
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor.shade300,
                                      gradient: LinearGradient(
                                        colors: [primaryColor, secondaryColor],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: prepiad_user == false
                                      ? Text(
                                          '${rupeeSymbol} 0.00',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        )
                                      : Text(
                                          '${rupeeSymbol} ${bank_info ?? 0}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                IconButton(
                                    onPressed: () {
                                      _infoButtonContent(isWalletContent: true);
                                    },
                                    icon: Icon(
                                      Icons.info_outline_rounded,
                                      size: 22,
                                    )),
                              ],
                            ),
                            // Divider(
                            //  thickness: 1,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Image(
                                  image: AssetImage(
                                      'assets/cards/hi_card_blank.jpg'),
                                  height: 28,
                                  width: 28,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("H! Rewards",
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor.shade300,
                                      gradient: LinearGradient(
                                        colors: [primaryColor, secondaryColor],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Text(
                                    '${User.userHiCardBalance}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 16,
                                // ),
                                IconButton(
                                    onPressed: () {
                                      _infoButtonContent(
                                          isWalletContent: false);
                                    },
                                    icon: Icon(
                                      Icons.info_outline_rounded,
                                      size: 22,
                                    )),
                              ],
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _infoButtonContent({bool? isWalletContent}) {
    return Get.dialog(Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${isWalletContent ?? false ? "${dataValue?.touchWalletDetails!.iButtonWallet ?? ""}" : "${dataValue?.touchWalletDetails!.iButtonRewards ?? ""}"}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Ubuntu",
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("OK"))
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<bool> showExitAppPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit app?'),
            // titleTextStyle: TextStyle(
            //     fontSize: 12,
            //     fontWeight: FontWeight.bold,
            //     color: secondaryColor),
            content: const Text('Do you want to exit from Prezenty?'),
            // contentTextStyle: TextStyle(
            //     // fontSize: 18,
            //     fontWeight: FontWeight.normal,
            //     color: secondaryColor),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text(
                  'No',
                  // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                //Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: const Text(
                  'Yes',
                  // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  refreshHome() {
    throw UnimplementedError();
  }
}

//@override
// refreshHome() {
//   if (mounted) {
//     _bloc.getHomeList(false, _textFieldControlSearch.text.trim());
//   }
// }
