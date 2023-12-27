import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/available_card_list_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/upgrade_coupon_tax_info_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_creation_and_payment_status.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_payment_order_details.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_kyc_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/prepaid_card_offer_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/check_scratchcard_valid_or_not_model.dart';
import '../../models/gateway_key_response.dart';
import '../../models/wallet&prepaid_cards/apply_card_tax_info_response.dart';
import '../../models/wallet&prepaid_cards/state_data_response.dart';
import '../../network/api_provider_prepaid_cards.dart';
import '../../network/apis.dart';
import '../../util/app_helper.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_text_box.dart';
import '../login/select_country_dialog_screen.dart';
import 'apply_kyc_screen.dart';
import 'coupon_code_screen.dart';

class ApplyPrepaidCardListScreen extends StatefulWidget {
  const ApplyPrepaidCardListScreen(
      {Key? key, required this.isUpgrade, this.currentCardId = 0,this.isFromSignUp,this.signupCouponCode,this.signupReferralCode})
      : super(key: key);

  @override
  State<ApplyPrepaidCardListScreen> createState() =>
      _ApplyPrepaidCardListScreenState();

  final bool isUpgrade;
  final int currentCardId;
  final bool? isFromSignUp;
  final String? signupCouponCode;
   final String? signupReferralCode;
}

class _ApplyPrepaidCardListScreenState
    extends State<ApplyPrepaidCardListScreen> {
  WalletBloc _walletBloc = WalletBloc();
  String viewExpand = "More";

  late Razorpay _razorPay;

  CardDetails? selectedCard;
  WalletPaymentOrderDetails? paymentOrderDetail;

  bool get isUpgradeScreen => widget.isUpgrade;
  PaymentSuccessResponse? paymentSuccessResponse;
  String globalRefReferralCode = '';

  final Country _country = Country(
    isoCode: "IN",
    phoneCode: "91",
    name: "India",
    iso3Code: "IND",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.isFromSignUp ?? false ?  Navigator.pushReplacement(context, _applyCardApplyCouponCode(enteredCouponCode: widget.signupCouponCode,enteredReferralCode: widget.signupReferralCode)) :null;
      if (isUpgradeScreen) {
        _walletBloc.getCardUpgradePlans(User.userId, widget.currentCardId);
      } else {
        _walletBloc.getAvailableCardList();
      }
    });
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    super.dispose();
  }

  // Future<bool> showExitPopup() async {
  //   if (User.apiToken.isEmpty) {
  //     return true;
  //   }
  //   return await showDialog(
  //         //show confirm dialogue
  //         //the return value will be from "Yes" or "No" options
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Exit Wallet?'),
  //           titleTextStyle: TextStyle(
  //               fontSize: 24,
  //               fontWeight: FontWeight.bold,
  //               color: secondaryColor),
  //           content: const Text('Do you want to exit Wallet?'),
  //           contentTextStyle: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.normal,
  //               color: secondaryColor),
  //           actions: [
  //             ElevatedButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               //return false when click on "NO"
  //               child: const Text(
  //                 'No',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () => Get.offAll(() => MainScreen()),
  //               //Navigator.of(context).pop(true),
  //               //return true when click on "Yes"
  //               child: const Text(
  //                 'Yes',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false; //if show dialog had returned null, then return false
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isUpgradeScreen)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Prepaid cards",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       //Get.to(MyCardsAndWallet());
                    //       Get.to(() => WalletHomeScreen());
                    //     },
                    //     child: Text(
                    //       "Wallet",
                    //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    //     ),
                    //     style: TextButton.styleFrom(
                    //       shape: RoundedRectangleBorder(
                    //           side: BorderSide(color: secondaryColor, width: 2),
                    //           borderRadius: BorderRadius.circular(8)),
                    //       fixedSize: Size(105, 30),
                    //       primary: secondaryColor,
                    //       elevation: 0,
                    //     )
                    //   //backgroundColor: primaryColor),
                    // )
                  ],
                ),
              ),
            Expanded(
              child: StreamBuilder<ApiResponse<dynamic>>(
                  stream: isUpgradeScreen
                      ? _walletBloc.getAvailableCardListStream
                      : _walletBloc.getAvailableCardListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return CommonApiLoader();
                        case Status.COMPLETED:
                          GetAllAvailableCardListResponse response =
                              snapshot.data!.data!;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: response.data!.length,
                              itemBuilder: ((context, index) {
                                return _cardItem(response.data![index]!);
                              }));
                        case Status.ERROR:
                          return SizedBox(
                            height: 100,
                            child: Text("${snapshot.data!.message!}"),
                          );
                      }
                    }
                    return SizedBox();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardItem(CardDetails cardDetailsData) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    // fit: BoxFit.fill,
                    // width: double.infinity,
                    // height: 230,
                    imageUrl: '${cardDetailsData.imageUrl ?? ""}',
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
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cardDetailsData.title!,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    rupeeSymbol + ' ' + cardDetailsData.amount!.toString(),
                    // +" "+
                    // '+ GST',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      children: [
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(0.10, 10.0),
                            child: Text(
                              " " + '+GST',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cardDetailsData.shortDescription!,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54),
              ),
            ),
            (viewExpand != 'More')
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlWidget(
                      cardDetailsData.longDescription!,
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                GestureDetector(
                  onTap: () {
                    viewExpand != 'More'
                        ? viewExpand = 'More'
                        : viewExpand = 'Less';
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 4),
                    child: Text(
                      viewExpand,
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => PrepaidCardOfferListScreen(
                      cardId: cardDetailsData.id!,
                    ));
              },
              child: Container(
                width: screenWidth - 30,
                height: 50,
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  "Deals & Offers",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            isUpgradeScreen
                ? GestureDetector(
                    onTap: () {
                      selectedCard = cardDetailsData;
                      //_upgradeApplyCouponCode();
                      touchpointRemeber();
                    },
                    child: Container(
                      height: 50,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Upgrade",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      if (User.apiToken.isEmpty) {
                        Get.to(() => LoginScreen(isFromWoohoo: false));
                      } else {
                        selectedCard = cardDetailsData;
                         _applyCardCheckWalletCreationAndPayment();
                 // Get.to(() => ApplyKycScreen(razorPayId: '', firstName: '', lastName: '', panNumber: '', cardId: '',));
                      }
                    },
                    child: Container(
                      height: 50,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Apply Card",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _applyCardCheckWalletCreationAndPayment() async {
    try {
      AppDialogs.loading();
      WalletCreationAndPaymentStatus response =
          await _walletBloc.walletCreationAndPaymentStatus(
              User.userId, selectedCard!.id.toString());
      Get.back();
      if (response.success!) {
        if (response.data!.paymentStatus != true) {
          haveAScratchCodeOrNot();

          // if (response.data!.slug == "kavajam") {
          //   kavajamScratchCodeBottomSheet();
          // }
          //  else {
          //   _applyCardApplyCouponCode();
          // }
        } else if (response.data!.walletStatus != true) {
          Get.to(() => ApplyKycScreen(
              razorPayId: response.data!.razorpayId!.toString(),
              cardId: response.data!.cardId!.toString(),
              panNumber: response.data?.panNumber ?? '',
              firstName: response.data?.firstName ?? '',
              lastName: response.data?.lastName ?? ''));
        } else {
          Get.to(() => WalletHomeScreen(isToLoadMoney: false,));
        }
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();

      toastMessage('Something went wrong. Please try again');
    }
  }

  haveAScratchCodeOrNot() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you have a Scratch card or Coupon code?'),
            // content: const Text('Do you want to block and replace your card?'),
            // contentTextStyle: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.normal,
            //     color: secondaryColor),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Get.close(1);
                  _applyCardApplyCouponCode();
                },

                //return false when click on "NO"
                child: const Text(
                  'No',
                ),
              ),
              SizedBox(
                width: 16,
              ),
              ElevatedButton(
                // onPressed:() =>
                onPressed: () {
                  Get.close(1);
                  scratchCodeBottomSheet();
                },
                //Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: const Text(
                  'Yes',
                ),
              ),
            ],
          );
        });
  }

  scratchCodeBottomSheet() async {
    final Rx<TextFieldControl> _textFieldControlScartchCode =
        TextFieldControl().obs;
          final Rx<TextFieldControl> _textFieldControlReferralCode =
        TextFieldControl().obs;
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(shrinkWrap: true, children: [
            SizedBox(
              height: 16,
            ),
            Text("Enter Scratch card number or Coupon code",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                )),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, //primaryColor.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: AppTextBox(
                  enabled: true,
                  padding: EdgeInsets.zero,
                  textFieldControl: _textFieldControlScartchCode.value,
                  hintText: 'Card Number or coupon code',
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
             Text("Enter Referral Code",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                )),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, //primaryColor.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: AppTextBox(
                  enabled: true,
                  padding: EdgeInsets.zero,
                  textFieldControl: _textFieldControlReferralCode.value,
                  hintText: 'Referral Code',
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                  onPressed: () async {
                    
                    try {
                      FocusScope.of(context).unfocus();
                      String scratchCode =
                          _textFieldControlScartchCode.value.controller.text;
                          String typedReferralCode = _textFieldControlReferralCode.value.controller.text;
                      CheckScratchcardValidOrNotModel? scratchValidOrNot =
                          await WalletBloc().getScratchCodeValidOrNot(
                              User.userId, selectedCard!.id.toString(), scratchCode,referralCode:typedReferralCode);

                             
  if(scratchValidOrNot?.data?.type == "coupon"){
    _applyCardApplyCouponCode(enteredCouponCode: scratchCode,enteredReferralCode: typedReferralCode);
  }
  else if(scratchValidOrNot?.statusCode == 500){
    toastMessage("${scratchValidOrNot?.message}");
  }
                      else 
                      if (scratchValidOrNot != null) {
                        Get.offAll(() => ApplyKycScreen(
                            razorPayId: scratchValidOrNot.data?.rzrPayId,
                            cardId: scratchValidOrNot.data?.cardId ?? '',
                            firstName: "",
                            lastName: "",
                            panNumber: ""));
                      } else {
                        toastMessage("Entered Coupon code is invalid");
                      }
                    } catch (e, s) {
                      Completer().completeError(e, s);
                    }
                  },
                  child: Text("Continue")),
            ),
          ]),
        ),
      ),
      enableDrag: true,
      isScrollControlled: false,
    );
  }

   _applyCardApplyCouponCode({String? enteredCouponCode,String? enteredReferralCode}) {
    final TextFieldControl _textFieldControlEmail = TextFieldControl();
    final Rx<TextFieldControl> _textFieldControlFirstName =
        TextFieldControl().obs;
    final Rx<TextFieldControl> _textFieldControlLastName =
        TextFieldControl().obs;
    final TextFieldControl _textFieldControlPhoneNumber = TextFieldControl();
    final Rx<TextFieldControl> _textFieldControlCouponCode =
        TextFieldControl().obs;
    final Rx<TextFieldControl> _textFieldControlPan = TextFieldControl().obs;
    final Rx<TextFieldControl> _textFieldControlReferralCode =
        TextFieldControl().obs;

    _textFieldControlEmail.controller.text = User.userEmail;
    _textFieldControlPhoneNumber.controller.text = User.userMobile;
    globalRefReferralCode = '';

    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setState) => SafeArea(
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: CloseButton()),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Hey, Your virtual card is ready in simple 3 Steps! ",
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Divider(
                                      height: 16,
                                    ),
                                    Text(
                                      '''Step 1 : Preliminary details
Step 2 : Payment Authorization
Step 3 : Address and the ID Details
At last, You will receive an OTP from the issuer to validate your mobile number. You may start using the virtual card after the OTP validation.''',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                    Divider(
                                      height: 16,
                                    ),
                                    Text(
                                      "*** Make sure your PAN Number and the mobile number while registration to complete the onboarding.",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'STEP 1 : Preliminary details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            enabled: true,
                            textFieldControl: _textFieldControlFirstName.value,
                            hintText: 'First Name',
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Last name',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            enabled: true,
                            textFieldControl: _textFieldControlLastName.value,
                            hintText: 'Last name',
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Email address',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            textFieldControl: _textFieldControlEmail,
                            hintText: '',
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          AppTextBox(
                            textFieldControl: _textFieldControlPhoneNumber,
                            enabled: false,
                            hintText: '',
                            keyboardType: TextInputType.number,
                            prefixIcon: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '+91 -',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  // Icon(Icons .keyboard_arrow_down_rounded)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          AppTextBox(
                            textFieldControl: _textFieldControlPan.value,
                            hintText: 'PAN',
                            textCapitalization: TextCapitalization.characters,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Coupon/Promo code',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    String? code = await Get.to(() =>
                                        CouponCodeScreen(
                                            cardId: selectedCard!.id!));
                                    _textFieldControlCouponCode
                                        .value.controller.text = code ?? '';
                                  },
                                  child: Text('Available coupons ')),
                            ],
                          ),
                          Obx(() => AppTextBox(
                                textFieldControl:
                                    _textFieldControlCouponCode.value,
                                textCapitalization:
                                    TextCapitalization.characters,
                                hintText:enteredCouponCode == null? 'Coupon code' : "${enteredCouponCode}",
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Referral Person Code',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.dialog(
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(22),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Enter your referred person or friends referral code for availing the touch points both of you.",
                                                  // textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                CloseButton(color: primaryColor)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.info_outline_rounded),
                                color: Colors.grey,
                              )
                            ],
                          ),
              
                          Obx(
                            () => AppTextBox(
                              enabled: true,
                              textFieldControl:
                                  _textFieldControlReferralCode.value,
                              hintText: enteredReferralCode == null ?'Referral person code' : "${enteredReferralCode}",
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                String pan =
                                    _textFieldControlPan.value.controller.text;
                                String? err = validatePANCard(pan);
                                if (err != null) {
                                  toastMessage(err);
                                  return;
                                }

                                String code = _textFieldControlCouponCode
                                    .value.controller.text;
                                bool b = await _validateCouponCode(code);
                                String firstName = _textFieldControlFirstName
                                    .value.controller.text;
                                String lastName = _textFieldControlLastName
                                    .value.controller.text;

                                if (b) {
                                  globalRefReferralCode =
                                      _textFieldControlReferralCode
                                          .value.controller.text
                                          .trim();
                                  _applyCardGetTaxInfo(
                                      code, pan, firstName, lastName);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Continue',
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _applyCardGetTaxInfo(
      String couponCode, String pan, String firstName, String lastName) async {
    ApplyCardTaxInfoResponse? taxData = await _walletBloc.getApplyCardTaxInfo({
      'account_id': User.userId,
      'card_id': selectedCard?.id,
      'name': firstName,
      //'name': User.userName,
      'email': User.userEmail,
      'phone_number': '+91-${User.userMobile}',
      'coupon_code': couponCode,
      'pan_number': pan,
      'last_name': lastName
    });

    if (taxData != null && taxData.data != null) {
      AppDialogs.loading();
      StateCodeResponse? response = await _walletBloc.getStateList();
      AppDialogs.closeDialog();

      if (response == null) return;

      _applyCardTaxBottomSheet(couponCode, taxData.data!, response.data ?? [],
          panNumber: pan, firstName: firstName, lastName: lastName);
    }
  }

  _applyCardTaxBottomSheet(
      String couponCode, ApplyCardTaxInfoData taxData, List<States> states,
      {required String firstName,
      required String lastName,
      required String panNumber}) {
    // States state = states[0];

    States state = states.firstWhere((element) => element.stateTitle.toString().toUpperCase() == 'KERALA');

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: StatefulBuilder(
                builder: (BuildContext context, setState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Payment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListView(shrinkWrap: true, children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        rupeeSymbol + ' ${taxData.amount}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (taxData.discountPrice != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Discount',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '- ' +
                                              rupeeSymbol +
                                              ' ${taxData.discountPrice}',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'GST',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${taxData.gst}%',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Payable Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        rupeeSymbol +
                                            ' ' +
                                            (taxData.payableAmount ?? '0'),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black26)),
                          child: DropdownButton<States>(
                            value: state,
                            isExpanded: true,
                            menuMaxHeight: 300,
                            underline: SizedBox(),
                            onChanged: (States? data) {
                              setState(() {
                                state = data!;
                              });
                            },
                            items:
                                states.map<DropdownMenuItem<States>>((value) {
                              return DropdownMenuItem<States>(
                                value: value,
                                child: Text(value.stateTitle ==null ? 'Select state':value.stateTitle.toString().toUpperCase()),
                              );
                            }).toList(),
                          ),
                        ),

                        //     Container(
                        // padding: const EdgeInsets.all(8),
                        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                        //     border: Border.all(color:Colors.black26)),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.stretch,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Text('State',style: TextStyle(color: Colors.black54),),
                        //     DropdownButtonHideUnderline(
                        //       child: DropdownButton(
                        //         style: TextStyle(color: secondaryColor),
                        //         alignment: AlignmentDirectional.centerStart,
                        //         hint: Text(
                        //           "Select State",
                        //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        //         ),
                        //         items: states.map((item) {
                        //           return DropdownMenuItem(
                        //               value: state,onTap: (){
                        //             state = item;
                        //             setState(() {});
                        //           },
                        //               child: Text(item.stateTitle!,
                        //                   style: TextStyle(
                        //                       fontWeight: FontWeight.w700,
                        //                       color: Colors.black54,
                        //                       fontSize: 16)));
                        //         }).toList(),
                        //         onChanged: (States? value) { },
                        //       ),
                        //     ),
                        //   ],
                        // ),),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              bool b = await _walletBloc
                                  .checkEventVaCreated(User.userId);

                              if (b) {
                                _applyCardInitPayment(couponCode,
                                    taxData.amount.toString(), state,
                                    insTableId: taxData.insTableId ?? 0,
                                    panNumber: panNumber,
                                    firstName: firstName,
                                    lastName: lastName);
                              } else {
                                toastMessage(
                                    "This phone number has already registered.Please use a different mobile number");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  'Pay  $rupeeSymbol${taxData.payableAmount ?? 0}'),
                            ),
                          ),
                        ),
                      ],
                    )),
          );
        });
  }

  _applyCardInitPayment(String couponCode, String amount, States? state,
      {required int insTableId,
      required String firstName,
      required String lastName,
      required String panNumber}) async {
    String key = await _getGatewayKey();
    if (key.isEmpty) {
      toastMessage('Unable to get payment key');
    } else {
      paymentOrderDetail = await _getGatewayOrderId(amount, couponCode);
      String orderId = paymentOrderDetail?.orderId ?? '';

      if (orderId.isEmpty) {
        toastMessage('Unable to get order');
      } else {
        try {
          _razorPay = Razorpay();
          _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
              (PaymentSuccessResponse paymentSuccessResponse) async {
            toastMessage('Payment successful');

            Get.close(1);
            Get.back();

            Map<String, dynamic> paymentNotes = {
              "type": "CARD",
              "user_id": User.userId,
              "card_id": selectedCard!.id,
              'order_id': paymentOrderDetail?.orderId,
              "amount": paymentOrderDetail?.convertedAmount,
              "state_code": state?.stateId,
              "coupon_code": paymentOrderDetail?.couponCode,
              "coupon_value": paymentOrderDetail?.couponValue,
              "discount_amount": paymentOrderDetail?.discountAmount,
              "signature": paymentSuccessResponse.signature,
              "payment_id": paymentSuccessResponse.paymentId,
              "ins_table_id": '$insTableId',
              "referral_code": globalRefReferralCode,
            };

            // Get.to(() => ApplyKycScreen( razorPayId: paymentSuccessResponse.paymentId,cardId: selectedCard!.id.toString(),
            //         panNumber:panNumber,firstName:firstName,
            //         lastName:lastName));

            _walletBloc
                .transactionStatusCheck(paymentNotes, "apply_card")
                .then((b) {
              if (b) {
                Get.to(() => ApplyKycScreen(
                    razorPayId: paymentSuccessResponse.paymentId,
                    cardId: selectedCard!.id.toString(),
                    panNumber: panNumber,
                    firstName: firstName,
                    lastName: lastName));
              }
            });
          });
          _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
              (PaymentFailureResponse paymentFailureResponse) {
            _onPaymentErrorFn(paymentFailureResponse);
          });

          _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});

          var options = {
            'key': key,
            'amount': paymentOrderDetail?.convertedAmount,
            'order_id': paymentOrderDetail?.orderId,
            'currency': "INR",
            'name': 'Prezenty',
            'description': 'Payment',
            'prefill': {
              'name': '${User.userName}',
              'contact': '${_country.phoneCode}${User.userMobile}',
              'email': '${User.userEmail}'
            },
            'notes': {
              "type": "CARD",
              "user_id": User.userId,
              "card_id": selectedCard!.id,
              'order_id': paymentOrderDetail?.orderId,
              "amount": paymentOrderDetail?.convertedAmount,
              "state_code": state?.stateId,
              "coupon_code": "${paymentOrderDetail?.couponCode}",
              "coupon_value": "${paymentOrderDetail?.couponValue}",
              "discount_amount": "${paymentOrderDetail?.discountAmount}",
              "signature": '${paymentSuccessResponse?.signature}',
              "payment_id": '${paymentSuccessResponse?.paymentId}',
              "ins_table_id": '$insTableId',
              "referral_code": globalRefReferralCode,
            }
          };

          debugPrint('options:' + jsonEncode(options));

          _razorPay.open(options);
          return true;
        } catch (e, s) {
          Completer().completeError(e, s);
          toastMessage('Unable to start payment. Please try again');
          return false;
        }
      }
    }
  }

  String? validatePANCard(String value) {
    return value.isEmpty ||
            value.length != 10 ||
            !FormatAndValidate.alphaRegExp.hasMatch(value.substring(0,
                2)) //First three characters i.e. "XYZ" in the above PAN are alphabetic series running from AAA to ZZZ
            ||
            !FormatAndValidate.alphaRegExp.hasMatch(value.substring(
                3)) //Fourth character i.e. "P" stands for Individual status of applicant.
            ||
            !FormatAndValidate.alphaRegExp.hasMatch(value.substring(
                4)) //Fifth character i.e. "K" in the above PAN represents first character of the PAN holder's last name/surname.
            ||
            !FormatAndValidate.alphaRegExp.hasMatch(value.substring(4,
                8)) //Next four characters i.e. "8200" in the above PAN are sequential number running from 0001 to 9999.
            ||
            !FormatAndValidate.alphaRegExp.hasMatch(value.substring(
                9)) //Last character i.e. "S" in the above PAN is an alphabetic check digit.
        ? "Enter 10 digit valid PAN Card number"
        : null;
  }

  // _upgradeApplyCouponCode() {
  //   final Rx<TextFieldControl> _textFieldControlCouponCode =
  //       TextFieldControl().obs;

  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       enableDrag: true,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(12), topRight: Radius.circular(12))),
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(
  //           builder: (context, setState) => SafeArea(
  //             child: Padding(
  //               padding: MediaQuery.of(context).viewInsets,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Expanded(
  //                             child: Text(
  //                               'Coupon code',
  //                               style: TextStyle(
  //                                   fontSize: 16, fontWeight: FontWeight.w600),
  //                             ),
  //                           ),
  //                           TextButton(
  //                               onPressed: () async {
  //                                 String? code = await Get.to(() =>
  //                                     CouponCodeScreen(
  //                                         cardId: selectedCard!.id!));
  //                                 _textFieldControlCouponCode
  //                                     .value.controller.text = code ?? '';
  //                               },
  //                               child: Text('Available coupons')),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 16,
  //                       ),
  //                       Obx(() => AppTextBox(
  //                             textFieldControl:
  //                                 _textFieldControlCouponCode.value,
  //                             hintText: 'Coupon code',
  //                           )),
  //                       SizedBox(
  //                         height: 16,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(12),
  //                         child: ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(12)),
  //                           ),
  //                           onPressed: () async {
  //                             String code = _textFieldControlCouponCode
  //                                 .value.controller.text;
  //                             bool b = await _validateCouponCode(code);
  //                             if (b) {
  //                               _upgradeCardGetTaxInfo(code);
  //                             }

  //                             ////////// change to upgrade get tax info
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(16),
  //                             child: Text(
  //                               'Continue',
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ]),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  touchpointRemeber() {
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
                  "Ensure your available touch points to be used fully prior to the upgrade!",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: (){
                  Get.back();
_upgradeCardGetTaxInfo();
                }, child: Text("Confirm"))
              ],
            ),
          ),
        ),
      ),
    ));
  }

  _upgradeCardGetTaxInfo({String? couponCode}) async {
    UpgradeCouponTaxInfo? taxData = await _walletBloc.getupgardeCouponTaxInfo(
        selectedCard!.id, User.userId);

    if (taxData != null && taxData.data != null) {
      AppDialogs.loading();
      StateCodeResponse? response = await _walletBloc.getStateList();
      AppDialogs.closeDialog();

      if (response == null) return;

      _upgradeCardTaxBottomSheet(couponCode ?? "", taxData.data!);
    }
  }

  _upgradeCardTaxBottomSheet(
      String couponCode, UpgradeCouponTaxResponse taxData) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: StatefulBuilder(
                builder: (BuildContext context, setState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Payment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListView(shrinkWrap: true, children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        rupeeSymbol + ' ${taxData.amount}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (taxData.discountPrice!.isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Discount',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '- ' +
                                              rupeeSymbol +
                                              ' ${taxData.discountPrice ?? 0}',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'GST',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${taxData.gst}%',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Payable Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        rupeeSymbol +
                                            ' ' +
                                            (taxData.payableAmount ?? '0'),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {

                              ApplyKycScreen(razorPayId: '', firstName: '', lastName: '', panNumber: '', cardId: '',);
                              // _upgradeInitPayment(
                              //     couponCode, taxData.amount.toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  'Pay  $rupeeSymbol${taxData.payableAmount ?? 0}'),
                            ),
                          ),
                        ),
                      ],
                    )),
          );
        });
  }

  _upgradeInitPayment(String couponCode, String amount) async {
    String key = await _getGatewayKey();
    if (key.isEmpty) {
      toastMessage('Unable to get payment key');
    } else {
      paymentOrderDetail = await _getGatewayOrderId(amount, couponCode);
      String orderId = paymentOrderDetail?.orderId ?? '';

      if (orderId.isEmpty) {
        toastMessage('Unable to get order');
      } else {
        try {
          _razorPay = Razorpay();
          _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
              (PaymentSuccessResponse paymentSuccessResponse) {
            toastMessage('Payment successful');
            Get.close(2);
            Get.back();
            Get.to(() => WalletHomeScreen(isToLoadMoney: false,));
            Future.delayed(Duration(milliseconds: 100), () async {
              Map<String, dynamic> paymentNotes = {
                "type": "CARD",
                "user_id": User.userId,
                "card_id": selectedCard!.id,
                'order_id': paymentOrderDetail?.orderId,
                "amount": paymentOrderDetail?.convertedAmount,
                "coupon_code": paymentOrderDetail?.couponCode,
                "coupon_value": paymentOrderDetail?.couponValue,
                "discount_amount": paymentOrderDetail?.discountAmount,
                "signature": paymentSuccessResponse.signature,
                "payment_id": paymentSuccessResponse.paymentId,
              };

              // bool b = await _walletBloc.transactionStatusCheck(
              //     paymentNotes, "upgrade_card");

              // if (b) {
              //   Get.offAll(() => WalletHomeScreen());
              //   _upgradeSuccessDialog();
              // }
            });
          });
          _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
              (PaymentFailureResponse paymentFailureResponse) {
            _onPaymentErrorFn(paymentFailureResponse);
          });

          _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});

          var options = {
            'key': key,
            'amount': paymentOrderDetail?.convertedAmount,
            'order_id': paymentOrderDetail?.orderId,
            'currency': "INR",
            'name': 'Prezenty',
            'description': 'Payment',
            'prefill': {
              'name': '${User.userName}',
              'contact': '${_country.phoneCode}${User.userMobile}',
              'email': '${User.userEmail}'
            },
            'notes': {
              "type": "UPGRADE",
              "user_id": User.userId,
              "card_id": selectedCard?.id,
              'order_id': paymentOrderDetail?.orderId,
              "amount": paymentOrderDetail?.convertedAmount,
              "coupon_code": "${paymentOrderDetail?.couponCode}",
              "coupon_value": "${paymentOrderDetail?.couponValue}",
              "discount_amount": "${paymentOrderDetail?.discountAmount}"
            }
          };

          debugPrint('options:' + jsonEncode(options));

          _razorPay.open(options);
          return true;
        } catch (e, s) {
          Completer().completeError(e, s);
          toastMessage('Unable to start payment. Please try again');
          return false;
        }
      }
    }
  }

  _upgradeSuccessDialog() {
    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green.shade300,
                    size: 70,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your card upgraded successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _validateCouponCode(String code) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (code.isNotEmpty) {
      bool b = await _walletBloc.validate(selectedCard!.id.toString(), code);
      if (!b) {
        snackBarMessage('Invalid coupon code');
        return false;
      }
    }
    Get.close(1);
    return true;
  }

  Future<String> _getGatewayKey() async {
    try {
      AppDialogs.loading();
      final response = await ApiProviderPrepaidCards()
          .getJsonInstance()
          .get(Apis.getRazorpayGateWayKey);
      GatewayKeyResponse _gatewayKeyResponse =
          GatewayKeyResponse.fromJson(jsonDecode(response.data));
      Get.back();
      return _gatewayKeyResponse.apiKey ?? '';
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return '';
  }

  Future<WalletPaymentOrderDetails?> _getGatewayOrderId(
      String amount, String couponCode) async {
    try {
      AppDialogs.loading();
      final response = await ApiProviderPrepaidCards().getJsonInstance().get(
          '${Apis.getWalletPaymentOrderDetails}?amount=$amount&coupon_code=$couponCode&referral_code=$globalRefReferralCode');
      WalletPaymentOrderDetails _gatewayKeyResponse =
          WalletPaymentOrderDetails.fromJson(jsonDecode(response.data));

      Get.back();
      return _gatewayKeyResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

  _onPaymentErrorFn(PaymentFailureResponse response) {
    String msg = '';
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      msg = 'Payment Has Been Cancelled';
    } else if (response.code == Razorpay.NETWORK_ERROR) {
      msg = 'Network Issues while payment request';
    } else {
      msg = 'Payment Error, Try after some time';
    }

    AppDialogs.message(msg);
  }
}
