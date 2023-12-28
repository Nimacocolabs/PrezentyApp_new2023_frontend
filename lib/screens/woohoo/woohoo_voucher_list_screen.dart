import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/send_food_participant_list_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/available_card_list_response.dart';
import 'package:event_app/models/woohoo/get_how_it_works_model.dart';
import 'package:event_app/models/woohoo/woohoo_product_detail_response.dart';
import 'package:event_app/models/woohoo/woohoo_product_list_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/hi_card/hi_card_transaction_history_screen.dart';

import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/screens/drawer/contact_us_screen.dart';
import 'package:event_app/screens/drawer/happy_moments_screen.dart';
import 'package:event_app/screens/drawer/my_vouchers/my_vouchers_screen.dart';
import 'package:event_app/screens/drawer/notification_screen.dart';
import 'package:event_app/screens/login/login_screen.dart';

import 'package:event_app/screens/woohoo/input_card_no_pin_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:event_app/screens/drawer/favourite_list_screen.dart';
import 'package:event_app/screens/drawer/my_events_list_screen.dart';
import 'package:event_app/util/shared_prefs.dart';

import '../../bloc/profile_bloc.dart';
import '../../models/get_product_category_list_model.dart';

import '../drawer/spin_voucher_list_screen.dart';
import '../login/sign_up_screen.dart';
import '../prepaid_cards_wallet/auth_mpin_screen.dart';
import '../prepaid_cards_wallet/set_wallet_pin_screen.dart';
import '../main_screen.dart';

import 'woohoo_voucher_details_screen.dart';

class WoohooVoucherListScreen extends StatefulWidget {
  final bool showBackButton;
  final RedeemData redeemData;
  final String? eventId;
  final bool? showAppBar;

  const WoohooVoucherListScreen(
      {Key? key, required this.redeemData, required this.showBackButton,this.eventId,this.showAppBar})
      : super(key: key);

  @override
  _WoohooVoucherListScreenState createState() =>
      _WoohooVoucherListScreenState();
}

class _WoohooVoucherListScreenState extends State<WoohooVoucherListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  WoohooProductBloc _bloc = WoohooProductBloc();
  EventBloc _eventBloc = EventBloc();
  ProfileBloc _profileBloc = ProfileBloc();

  late bool isToShowFoodList;
  String selectedCategoryId = '';
  CardDetails? selectedCard;
  String? imageBaseUrl =
      "https://prezenty.in/prezentycards-live/public/app-assets/image/category/";

  TextEditingController _textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("eventid value = ${widget.eventId}");

    if (!widget.showBackButton) {
      checkUserInfo();
    }
    isToShowFoodList = (widget.redeemData.redeemType == RedeemType.SEND_FOOD);
    _reloadList(null);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setScreenDimensions(context);
      
      // _bloc.getHowItWorks();
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _eventBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: widget.showBackButton
      //     ? AppBar(
      //         elevation: 0,
      //       )
      //     : AppBar(
      //         elevation: 0,
      //         leading: IconButton(
      //             icon: Icon(
      //               CupertinoIcons.text_alignleft,
      //               color: Colors.white,
      //               size: 30,
      //             ),
      //             splashRadius: 24,
      //             onPressed: () {
      //               _scaffoldKey.currentState!.openDrawer();
      //             }),
      //       ),
      appBar: widget.showAppBar ?? false ? 
      CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ): null,
      bottomNavigationBar: CommonBottomNavigationWidget(),
      drawer: widget.showBackButton ? null : _drawer(),

      // PreferredSize(
      //   child: Container( color: primaryColor, ),
      //   preferredSize: Size(0, 0),
      // ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: primaryColor,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                // onSubmitted: (value) {},
                onChanged: (value) {
                  setState(() {});
                },
                controller: _textEditingControllerSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search_rounded,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Search',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ),
          ),
          if (!widget.showBackButton)
            Column(
              children: [
                Container(
                  color: primaryColor,
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: secondaryColor,
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: Text(
                                  'Create Event',
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // return;
                          if (User.apiToken.isEmpty) {
                            Get.to(
                                () => LoginScreen(
                                      isFromWoohoo: false,
                                    ),
                                transition: Transition.fade);
                          } else {
                            Get.to(() => MainScreen());
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  color: primaryColor,
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: secondaryColor,
                                ),
                                child: Icon(
                                  Icons.add_card_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: Text(
                                  'Prepaid cards',
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          if (User.apiToken.isEmpty) {
                            Get.to(
                                () => ApplyPrepaidCardListScreen(
                                    isUpgrade: false),
                                transition: Transition.fade);
                          } else {
                            bool? hasMpin =
                                await WalletBloc().getMPinStatus(User.userId);
                            if (hasMpin != null) {
                              if (hasMpin) {
                                Get.to(() => AuthMPinScreen());
                              } else {
                                Get.to(() => SetWalletPin());
                              }
                            } else {
                              toastMessage('Unable to open wallet');
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (widget.redeemData.redeemType == RedeemType.BUY_VOUCHER)
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // scrollDirection: Axis.horizontal,
                children: [
                  // _option('assets/images/brand.png', 'Brand Cards'),
                  // _option('assets/images/categories.png', 'Categories',onTap: _showBottomSheet),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        cardBalanceCheck();
                        // Get.to(() =>
                        //     InputCardNoPinScreen(isCardBalance: true));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet_outlined),
                            Text(
                              'Card Balance',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    indent: 4,
                    endIndent: 4,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        transactionHistoryCheck();
                        // Get.to(() => InputCardNoPinScreen(
                        //       isCardBalance: false,
                        //       isHiCardBalanceCheck: false,
                        //     ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_outlined),
                            Text(
                              'Transaction History',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  VerticalDivider(
                    width: 1,
                    indent: 4,
                    endIndent: 4,
                  ),

                  if (User.apiToken.isEmpty)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                              () => LoginScreen(
                                    isFromWoohoo: false,
                                  ),
                              transition: Transition.fade);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline_rounded),
                              Text(
                                'Login/Sign Up',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // _option('assets/images/offers.png', 'offer'),
                  // _option('assets/images/redeem.png', 'Redeem Prezenty'),
                ],
              ),
            ),
          
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: screenWidth,
            //height: screenHeight*0.72,
            child: StreamBuilder<ApiResponse<dynamic>>(
                stream: _bloc.itemsStream,
                builder: (context, snapshot) {
                  print("aaaa");

                  if (snapshot.hasData && snapshot.data?.status != null) {
                    print("bbbbb");
                    print(snapshot.data!.status);
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        print("ccccc");
                        return CommonApiLoader();
                      case Status.COMPLETED:
                        print("dddd");
                        WoohooProductListResponse resp = snapshot.data!.data;
                        return _buildList(resp);
                      case Status.ERROR:
                        print("eeee");
                        return CommonApiErrorWidget(snapshot.data!.message!,
                            () {
                          _reloadList(null);
                        });
                      default:
                        print("");
                    }
                  }
                  return SizedBox();
                }),
          ),
        ],
      )),
    );
  }

  cardBalanceCheck() {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(
                "Do you want to check your H! card balance?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Get.off(() => InputCardNoPinScreen(
                            isCardBalance: true,
                            isHiCardBalanceCheck: false,
                          ));
                    },
                    child: Text("No",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                ElevatedButton(
                    onPressed: () {
                      Get.off(() => InputCardNoPinScreen(
                            isCardBalance: true,
                            isHiCardBalanceCheck: true,
                          ));
                    },
                    child: Text("Yes",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
              ],
            )));
  }
transactionHistoryCheck(){
   return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(
                "Do you want to check your H! card transcation history?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                     Get.off(() => InputCardNoPinScreen(
                              isCardBalance: false,
                              isHiCardBalanceCheck: false,
                            ));
                    },
                    child: Text("No",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                ElevatedButton(
                    onPressed: () {
                  Get.off(() => HICardTransactionScreen());
                    },
                    child: Text("Yes",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
              ],
            )));
}

  Widget _buildList(WoohooProductListResponse response) {
    if ((response.data ?? []).isEmpty) {
      return CommonApiResultsEmptyWidget('No Result');
    }
    List<WoohooProductListItem> productList = []; //response.data??[];

    String query = _textEditingControllerSearch.text.trim().toLowerCase();
    if (query.isEmpty) {
      productList = response.data ?? [];
    } else {
      (response.data ?? []).forEach((element) {
        if ((element.name ?? '').toLowerCase().contains(query))
          productList.add(element);
      });
    }

    if (productList.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'No result',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
// if (query.isEmpty &&
          //     widget.redeemData.redeemType == RedeemType.BUY_VOUCHER )
          //   howItWorksWidget(),
          // SizedBox(
          //   height: 10,
          // ),
          // if (query.isEmpty &&
          //     widget.redeemData.redeemType == RedeemType.BUY_VOUCHER)

          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            shrinkWrap: true,
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  if (User.apiToken.isEmpty) {
                    await Get.to(() => LoginScreen(isFromWoohoo: false));
                  } else
                    await Get.to(() => WoohooVoucherDetailsScreen(
                        productId: productList[index].id ?? 0,
                        redeemData: widget.redeemData,
                        eventId: widget.eventId,));
                },
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
                                  imageUrl: productList[index].image != null
                                      ? '${response.basePathWoohooImages}${productList[index].image}'
                                      : productList[index].imageMobile ?? '',
                                  placeholder: (context, url) => Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
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
                          child: Text('${productList[index].name ?? ''}\n',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                        //   child: Text(productList[index].sku ?? '',
                        //       maxLines: 3, style: TextStyle(fontSize: 12)),
                        // ),
                      ],
                    ),
                    // productList[index].offers != "" &&
                    //         productList[index].offers != null
                    //     ? Positioned(
                    //         left: 0,
                    //         bottom: 50,
                    //         child: Container(
                    //           color: primaryColor,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(2.0),
                    //             child: Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Text(
                    //                     '${productList[index].offers.toString()}  \n',
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: Colors.yellow,
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 16)),
                    //                 Text("% OFF",
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: Colors.yellow,
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 16))
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Container(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  howItWorksWidget() {
    return SizedBox(
      width: screenWidth,
      height: 250,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _bloc.howItWorksStream,
          builder: (context, snapshot) {
            print("gxt");
            print(snapshot.hasData);
            if (snapshot.hasData && snapshot.data?.status != null) {
              print("bbbbb");
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  print("ccccc");
                  return CommonApiLoader();
                case Status.COMPLETED:
                  print("dddd");
                  GetHowItWorksModel response = snapshot.data!.data!;

                  final imageResponse = response.data;
                  // return Text("123456");

                  return howItWorksImages(imageResponse);
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

  howItWorksImages(List<GetHowItWorksData?>? howItWorksList) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 5),
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
        children: howItWorksList!.map((GetHowItWorksData? e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: '${e!.imageUrl ?? ''}',
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
                errorWidget: (context, url, error) =>
                    SizedBox(child: Image.asset('assets/images/no_image.png')),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _drawer() {
    if (User.apiToken.isEmpty) {
      return Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Material(
              color: secondaryColor.shade800,
              child: SafeArea(
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
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: Image(
                                image:
                                    AssetImage('assets/images/ic_avatar.png'),
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                          )),
                      SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Guest',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ))
                    ])),
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
                        Icon(Icons.person_outline_rounded,
                            color: Colors.white.withOpacity(0.4)),
                        'Login/Sign Up', () {
                      Get.to(
                          () => LoginScreen(
                                isFromWoohoo: false,
                              ),
                          transition: Transition.fade);
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
          ],
        ),
      );
    }
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Material(
            color: secondaryColor.shade800,
            child: SafeArea(
              child: InkWell(
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                  Get.off(() => MainScreen(showTab: 1));
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
                      Icon(Icons.home_filled,
                          color: Colors.white.withOpacity(0.4)),
                      'Home', () {
                    Get.to(() => MainScreen());
                  }),
                  _drawerMenuItem(
                      Image.asset('assets/images/ic_nav_notification.png'),
                      'Notifications', () {
                    Get.to(() => NotificationScreen());
                  }),
                  _drawerMenuItem(
                      Image.asset('assets/images/ic_nav_my_events.png'),
                      'My Coins', () async {
                    await Get.to(() => HappyMomentsScreen());
                  }),
                  _drawerMenuItem(
                      Image.asset('assets/images/ic_nav_my_events.png'),
                      'My Events', () {
                    Get.to(() => MyEventsListScreen());
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
                  _scaffoldKey.currentState!.openEndDrawer();
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
                              //Get.back();
                              SharedPrefs.logOut();
                              // Get.offAll(() => WithoutLoginHomeScreen());
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
            _scaffoldKey.currentState!.openEndDrawer();
            onTap();
          }),
    );
  }

  _reloadList(String? categoryId) {
    if (categoryId != null) selectedCategoryId = categoryId;
    _bloc.getProductList(selectedCategoryId, isToShowFoodList);
  }
}

class RedeemData {
  late RedeemType redeemType;
  int? eventId;
  String? account;
  double? totalAmt;
  List<Participant>? participants;
  int? denomination;
  int? productId; //require product master id
  WoohooProductDetail? productDetail;
  String? image;
  int? discount;
  int? instTableID;

  RedeemData.spinRedeemVoucher(int instTableID, int productId, int denomination,
      int discount, String image, WoohooProductDetail productDetail) {
    this.instTableID = instTableID;
    this.redeemType = RedeemType.SPIN_REDEEM_VOUCHER;
    this.productId = productId;
    this.denomination = denomination;
    this.discount = discount;
    this.productDetail = productDetail;
    this.image = image;
    
  }

  RedeemData.buyVoucher() {
    this.redeemType = RedeemType.BUY_VOUCHER;
  }

  RedeemData.giftRedeem(this.eventId, this.totalAmt) {
    this.redeemType = RedeemType.GIFT_REDEEM;
  }

  RedeemData.sendFood(this.eventId, this.participants, this.account) {
    this.redeemType = RedeemType.SEND_FOOD;
  }

  RedeemData.redeemTouchPoint() {
    this.redeemType = RedeemType.REDEEM_TOUCHPOINT;
  }
    RedeemData.hiRewardRedeem() {
    this.redeemType = RedeemType.HI_REWARD_REDEEM;
  }
  

  updateSendFood(int productId, int denomination,
      WoohooProductDetail productDetail, String image) {
    this.denomination = denomination;
    this.productId = productId;
    this.productDetail = productDetail;
    this.image = image;
  }
}

enum RedeemType {
  SPIN_REDEEM_VOUCHER,
  BUY_VOUCHER,
  SEND_FOOD,
  GIFT_REDEEM,
  REDEEM_TOUCHPOINT,
  HI_REWARD_REDEEM
}
