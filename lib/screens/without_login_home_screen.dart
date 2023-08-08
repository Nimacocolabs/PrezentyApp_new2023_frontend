// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/get_home_slider_image_model.dart';

import 'package:event_app/models/wallet&prepaid_cards/available_card_list_response.dart';
import 'package:event_app/models/woohoo/get_food_and_movie_products_model.dart';
import 'package:event_app/models/woohoo/woohoo_product_list_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/deals_for_you_details_screen.dart';
import 'package:event_app/screens/info_video_screen.dart';

import 'package:event_app/screens/login/login_screen.dart';

import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/help_and_support_screen.dart';

import 'package:event_app/screens/prepaid_cards_wallet/how_to_earn_touchpoints_screen.dart';

import 'package:event_app/screens/woohoo/food_and_movie_products_list.dart';

import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';

import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:get/get.dart';
import 'package:event_app/screens/spin_wheel_timer_button.dart';

import '../models/woohoo/deals_for_you_products_model.dart';

class WithoutLoginHomeScreen extends StatefulWidget {
  WithoutLoginHomeScreen({Key? key}) : super(key: key);

  @override
  State<WithoutLoginHomeScreen> createState() => _WithoutLoginHomeScreenState();
}

class _WithoutLoginHomeScreenState extends State<WithoutLoginHomeScreen> {
  WalletBloc _walletBloc = WalletBloc();
  WoohooProductBloc _bloc = WoohooProductBloc();
  ProfileBloc _profileBloc = ProfileBloc();
  List<CardDetails?>? cardList;
  String? imageBaseUrl =
      "https://prezenty.in/prezentycards-live/public/app-assets/image/prepaid_card_bg/";
  String? sliderImageBaseUrl =
      "https://prezenty.in/prezentycards-live/public/app-assets/image/slider/";
  // List<Widget> carouselItems = [
  //   prepaidCardsDetailsWidget(
  //       "Enjoy Prezenty prepaid cards features by purchasing any of the following cards.",
  //       "",
  //       ""),
  //   prepaidCardsDetailsWidget("silver", "${rupeeSymbol} 2900", "adahsdgsd"),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reloadList();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _walletBloc.getAvailableCardList();
      await _bloc.getOffersProductList();
      await _bloc.getFoodAndMovieProducts();
      await _profileBloc.getHomeSliderImages();

      getPopupImage();
    });
  }

  getPopupImage() async {
    String? imgUrl = await AuthBloc().getPopupImage();
    //  if (imgUrl != null) {
    //         AppDialogs.homePopupImage(imgUrl);
    //       }
  }

  _reloadList() {
    _bloc.getProductList("", false);
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            // ListView(physics: ScrollPhysics(), shrinkWrap: true,
            children: [
              headerWidget(),
              SizedBox(
                height: 15,
              ),
              // touchPointsWidget(),
              SizedBox(
                height: 15,
              ),
              giftHiCardWidget(),
              SizedBox(
                height: 5,
              ),
              _ppCardWidget(),
              SizedBox(
                height: 5,
              ),
              moreOptionsWidget(),
              SizedBox(
                height: 10,
              ),
              referAndEarnWidget(),
              SizedBox(
                height: 15,
              ),
              // howItWorksWidget(),
              // SizedBox(
              //   height: 10,
              // ),
              mostPopularWidget(),
              SizedBox(
                height: 15,
              ),
              dealsForYouExclusively(),
              // BackToCampus(),
              SizedBox(
                height: 15,
              ),
              // foodAndMovieWidget(),
              // SizedBox(
              //   height: 15,
              // ),

              // SizedBox(
              //   height: 10,
              // ),
              // DealsForYou(),
              sliderBannerWidget(),
              SizedBox(
                height: 18,
              ),
              todaysChallengeWidget(),
              SizedBox(
                height: 18,
              ),
              helpAndSuuport(),
              SizedBox(
                height: 10,
              ),
            ]),
      ),
      bottomNavigationBar: bottomNavigationWidget(),
    );
  }

  Widget _ppCardWidget() {
    return SizedBox(
      width: screenWidth,
      height: 250,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _walletBloc.getAvailableCardListStream,
          builder: (context, snapshot) {
            print("aaaa");
            if (snapshot.hasData && snapshot.data?.status != null) {
              print("bbbbb");
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  print("ccccc");
                  return CommonApiLoader();
                case Status.COMPLETED:
                  print("dddd");
                  GetAllAvailableCardListResponse response =
                      snapshot.data!.data!;

                  final cardResponse = response.data;
                  // return Text("123456");

                  return newPrePaidCardWdiget(cardResponse);

                case Status.ERROR:
                  print("eeee");
                  return CommonApiResultsEmptyWidget(
                      "${snapshot.data?.message ?? ""}",
                      textColorReceived: Colors.black);
                default:
                  print("");
              }
            }
            return SizedBox();
          }),
    );
  }

  Widget newPrePaidCardWdiget(List<CardDetails?>? cardList) {
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
        children: cardList!.map((CardDetails? e) {
          return Stack(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 230,
                    imageUrl: '${imageBaseUrl}${e!.bgImage}',
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
                "${e.title}",
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
                        Get.to(
                            () => ApplyPrepaidCardListScreen(isUpgrade: false));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Get your card",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
        }).toList(),
      ),
    );
  }

  Widget giftHiCardWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: (){
            Get.to(() => LoginScreen(isFromWoohoo: false));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        Get.to(() => LoginScreen(isFromWoohoo: false));
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

  dealsForYouExclusively() {
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

//


  sliderBannerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
        //   child: Text(
        //     "Back-To-Campus Deals",
        //     style: TextStyle(
        //         color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        SizedBox(
          width: screenWidth,
          height: 200,
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _profileBloc.homeSliderImagesStream,
              builder: (context, snapshot) {
                print("aaaa");
                if (snapshot.hasData && snapshot.data?.status != null) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      print("ccccc");
                      return CommonApiLoader();
                    case Status.COMPLETED:
                      print("dddd");
                      GetHomeSliderImageModel response = snapshot.data!.data!;

                      final productsResponse = response.data;

                      return getSliderImagesWidget(productsResponse);

                    case Status.ERROR:
                      print("eeee");
                      return CommonApiResultsEmptyWidget(
                          "${snapshot.data?.message ?? ""}",
                          textColorReceived: Colors.black);
                    default:
                      print("");
                  }
                }
                return SizedBox();
              }),
        ),
      ],
    );
  }

  getSliderImagesWidget(List<GetHomeSliderImageData?>? sliderData) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
      height: 50,
      child: ImageSlideshow(
        width: double.infinity,
        height: screenHeight * 0.28,
        initialPage: 0,
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.white,
        onPageChanged: (value) {},
        isLoop: true,
        children: sliderData!.map((GetHomeSliderImageData? e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () async {
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                },
                child: CachedNetworkImage(
                  imageUrl: '${sliderImageBaseUrl}${e!.image}',
                  width: double.infinity,
                  height: screenHeight * 0.28,
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
        }).toList(),
      ),
    );
  }

  Widget todaysChallengeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Today's challenge",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        SpinWheelTimerButton(),
      ],
    );
  }

  mostPopularWidget() {
    return StreamBuilder<ApiResponse<dynamic>>(
        stream: _bloc.itemsStream,
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
          child: Text(
            "Most Popular",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                        // Get.to(() => SpinGiftsWonScreen());
                        Get.to(() => WoohooVoucherListScreen(
                            redeemData: RedeemData.buyVoucher(),
                            showBackButton: true,showAppBar: true,));
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

moreOptionsWidget() {
  return Padding(
    padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 5),
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
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                },
                child: Container(
                  color: Colors.grey.shade200,
                  height: 110,
                  width: 90,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "\nCreate Event",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -10,
              left: 25,
              child: InkWell(
                onTap: () {
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                },
                child: Image(
                  image: AssetImage('assets/images/create_event_image.png'),
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
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                },
                child: Container(
                  color: Colors.grey.shade200,
                  height: 110,
                  width: 90,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "\nGift\nNow",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -5,
              left: 25,
              child: InkWell(
                onTap: () {
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                },
                child: Image(
                  image: AssetImage('assets/images/gifting_image.png'),
                  width: 80,
                  height: 80,
                ),
              ),
            )
          ]),
          Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 30),
              child: InkWell(
                onTap: () {
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                },
                child: Container(
                  color: Colors.grey.shade200,
                  height: 110,
                  width: 90,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "\nSend Money",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -5,
              left: 25,
              child: InkWell(
                onTap: () {
                  Get.to(() => LoginScreen(isFromWoohoo: false));
                },
                child: Image(
                  image: AssetImage('assets/images/send_money_image.png'),
                  width: 80,
                  height: 80,
                ),
              ),
            )
          ]),
        ],
      ),
    ),
  );
}

referAndEarnWidget() {
  return InkWell(
    onTap: () {
      Get.to(() => LoginScreen(isFromWoohoo: false));
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

Widget bottomNavigationWidget() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2), color: Colors.white),
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
                Get.to(() => LoginScreen(isFromWoohoo: false));
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
                Get.to(() => LoginScreen(isFromWoohoo: false));
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
                Get.to(() => LoginScreen(isFromWoohoo: false));
              },
              child: SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: primaryColor,
                      size: 34,
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
              onTap: () {
                Get.to(() => LoginScreen(isFromWoohoo: false));
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
              onTap: () async {
                // await showDialog(
                //   context: context,
                //   builder:  (_) => imageDialog( context));
                Get.to(() => LoginScreen(isFromWoohoo: false));
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

Widget touchPointsWidget() {
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.only(top: 5, left: 15, right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 2,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Image(
                    image: AssetImage("assets/images/trans prupee.png"),
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Touch points',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    onTap: () {
      Get.to(() => HowToEarnTouchPointScreen());
    },
  );
}

Widget headerWidget() {
  Container(
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
    height: screenHeight * 0.23,
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
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () async {
              Get.to(() => LoginScreen(isFromWoohoo: false));
            },
            borderRadius: BorderRadius.all(Radius.circular(40)),
            child: Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(40.0)),
              child: Text(
                "Login/Signup",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),

              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
              // padding: EdgeInsets.all(0.0),
              //     child: Ink(
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(colors: [
              //             primaryColor,secondaryColor],
              //             begin: Alignment.centerLeft,
              //             end: Alignment.centerRight,
              //           ),
              //           borderRadius: BorderRadius.circular(30.0)
              //       ),
              //       child: Container(
              //         decoration:BoxDecoration(
              // borderRadius: BorderRadius.circular(30.0),
              //         ),
              //          constraints: BoxConstraints(
              //           maxWidth: 400.0,
              //            minHeight: 50.0),
              //         alignment: Alignment.center,
              //         child: Text(
              //           "Login/Signup",
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //               color: Colors.white
              //           ),
              //         ),
              //       ),
              //     ),
            ),
          ),
        ],
      ),
    ),
  );
  return SizedBox(
    height: screenHeight * 0.4,
    child: Stack(clipBehavior: Clip.none, children: [
      Container(
        margin: EdgeInsets.only(bottom: 70),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(20, 20),
            bottomRight: Radius.elliptical(20, 20),
          ),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [primaryColor, secondaryColor],
          ),
        ),
        padding: EdgeInsets.all(15),
        width: screenWidth,
        height: screenHeight * 0.3,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hello,",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text("User",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: 25,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: screenHeight * 0.23,
        left: 15,
        right: 15,
        bottom: 0, // -screenHeight * 0.09,
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
          height: screenHeight * 0.23,
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
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    Get.to(() => LoginScreen(isFromWoohoo: false));
                  },
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: Container(
                    width: 100,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(40.0)),
                    child: Text(
                      "Login/Signup",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),

                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    // padding: EdgeInsets.all(0.0),
                    //     child: Ink(
                    //       decoration: BoxDecoration(
                    //           gradient: LinearGradient(colors: [
                    //             primaryColor,secondaryColor],
                    //             begin: Alignment.centerLeft,
                    //             end: Alignment.centerRight,
                    //           ),
                    //           borderRadius: BorderRadius.circular(30.0)
                    //       ),
                    //       child: Container(
                    //         decoration:BoxDecoration(
                    // borderRadius: BorderRadius.circular(30.0),
                    //         ),
                    //          constraints: BoxConstraints(
                    //           maxWidth: 400.0,
                    //            minHeight: 50.0),
                    //         alignment: Alignment.center,
                    //         child: Text(
                    //           "Login/Signup",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               color: Colors.white
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]),
  );
}

class BackToCampus extends StatefulWidget {
  BackToCampus({Key? key}) : super(key: key);

  @override
  State<BackToCampus> createState() => _BackToCampusState();
}

class _BackToCampusState extends State<BackToCampus> {
  WoohooProductBloc _woohooBloc = WoohooProductBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _woohooBloc.backToCampusProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return backToCampusWidget();
  }

  Widget backToCampusWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, right: 10),
          child: Text(
            "Back-To-Campus Deals",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: screenWidth,
          height: 250,
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _woohooBloc.backToCampusProductStream,
              builder: (context, snapshot) {
                print("aaaa");
                if (snapshot.hasData && snapshot.data?.status != null) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      print("ccccc");
                      return CommonApiLoader();
                    case Status.COMPLETED:
                      print("dddd");
                      DealsForYouProductsModel response = snapshot.data!.data!;

                      final productsResponse = response.data;

                      return backToCampusProductsList(productsResponse!);

                    case Status.ERROR:
                      print("eeee");
                      return CommonApiResultsEmptyWidget(
                          "${snapshot.data?.message ?? ""}",
                          textColorReceived: Colors.black);
                    default:
                      print("");
                  }
                }
                return SizedBox();
              }),
        ),
      ],
    );
  }

  backToCampusProductsList(List<DealsForYouProductsData> dealsProductsList) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
      height: 100,
      child: ImageSlideshow(
        width: double.infinity,
        height: screenHeight * 0.28,
        initialPage: 0,
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.white,
        onPageChanged: (value) {},
        autoPlayInterval: 3000,
        isLoop: true,
        children: dealsProductsList.map((DealsForYouProductsData? e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () async {
                  Get.to(() => DealsForYouDetailsScreen(
                      isBackToCampus: true, isDealsForYou: false));
                },
                child: CachedNetworkImage(
                  imageUrl: '${e!.imageUrl ?? ""}',
                  width: double.infinity,
                  height: screenHeight * 0.28,
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
        }).toList(),
      ),
    );
  }
}

class DealsForYou extends StatefulWidget {
  DealsForYou({Key? key}) : super(key: key);

  @override
  State<DealsForYou> createState() => _DealsForYouState();
}

class _DealsForYouState extends State<DealsForYou> {
  WoohooProductBloc _bloc = WoohooProductBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _bloc.dealsForYouProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return productOffers();
  }

  Widget productOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 12),
          child: Text(
            "Deals for you",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: screenWidth,
          height: 250,
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _bloc.dealsProductsStream,
              builder: (context, snapshot) {
                print("aaaa");
                if (snapshot.hasData && snapshot.data?.status != null) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      print("ccccc");
                      return CommonApiLoader();
                    case Status.COMPLETED:
                      print("dddd");
                      DealsForYouProductsModel response = snapshot.data!.data!;

                      final productsResponse = response.data;

                      return dealsForYouProductsList(productsResponse!);

                    case Status.ERROR:
                      print("eeee");
                      return CommonApiResultsEmptyWidget(
                          "${snapshot.data?.message ?? ""}",
                          textColorReceived: Colors.black);
                    default:
                      print("");
                  }
                }
                return SizedBox();
              }),
        ),
      ],
    );
  }

  dealsForYouProductsList(List<DealsForYouProductsData> dealsProductsList) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
      height: 100,
      child: ImageSlideshow(
        width: double.infinity,
        height: screenHeight * 0.28,
        initialPage: 0,
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.white,
        onPageChanged: (value) {},
        autoPlayInterval: 3000,
        isLoop: true,
        children: dealsProductsList.map((DealsForYouProductsData? e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () async {
                  Get.to(() => DealsForYouDetailsScreen(
                        isBackToCampus: false,
                        isDealsForYou: true,
                      ));
                },
                child: CachedNetworkImage(
                  imageUrl: '${e!.imageUrl ?? ""}',
                  width: double.infinity,
                  height: screenHeight * 0.28,
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
        }).toList(),
      ),
    );
  }
}
