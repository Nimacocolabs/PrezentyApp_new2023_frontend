import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:event_app/bloc/payment_bloc.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/touchpoint_wallet_balance_response.dart';
import 'package:event_app/models/gateway_key_response.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/models/validate_card.dart';
import 'package:event_app/models/woohoo/order_status_response.dart';
import 'package:event_app/models/woohoo/woohoo_create_order_response.dart';
import 'package:event_app/models/woohoo/woohoo_product_detail_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/screens/login/select_country_dialog_screen.dart';
import 'package:event_app/screens/payment/payment_v2_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/getsucessupi.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/upiresponse.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/string_validator.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/succes_or_failed_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/woohoo/check_voucher_code_valid_or_notmodel.dart';
import '../payment/payment_v2_screen.dart';

class WoohooVoucherBuyScreen extends StatefulWidget {
  final WoohooProductDetail woohooProductDetail;
  final RedeemData redeemData;
  final int productId;
  final String? image;
  final double? offers;
  final List<Templates> templates;
  final String templateBaseUrl;
  final String? eventId;

  const WoohooVoucherBuyScreen({
    Key? key,
    required this.woohooProductDetail,
    required this.redeemData,
    required this.productId,
    required this.image,
    required this.offers,
    required this.templates,
    required this.templateBaseUrl,
    this.eventId,
  }) : super(key: key);

  @override
  _WoohooVoucherBuyScreenState createState() => _WoohooVoucherBuyScreenState();
}

class _WoohooVoucherBuyScreenState extends State<WoohooVoucherBuyScreen> {
  TextFieldControl _textFieldControlPhone = TextFieldControl();
  TextFieldControl _textFieldControlDenomination = TextFieldControl();
  TextFieldControl _textFieldControlQty = TextFieldControl();
  TextFieldControl _textFieldControlFirstName = TextFieldControl();
  TextFieldControl _textFieldControlLastName = TextFieldControl();
  TextFieldControl _textFieldControlEmail = TextFieldControl();
  TextFieldControl _textFieldControlMessage = TextFieldControl();
  TextFieldControl _textFieldControlEventId = TextFieldControl();
  TextFieldControl _textFieldControlCardNumber = TextFieldControl();
  TextFieldControl _textFieldVoucherCode = TextFieldControl();
  final Rx<TextFieldControl> _textFieldHIRewardPINEntered =
      TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldHIRewardsRedeem = TextFieldControl().obs;
   final _controller = TextEditingController();
  WoohooProductBloc _bloc = WoohooProductBloc();
  WalletBloc _walletBloc = WalletBloc();
  ProfileBloc _profileBloc = ProfileBloc();

  Country _country = Country(
    isoCode: "IN",
    phoneCode: "91",
    name: "India",
    iso3Code: "IND",
  );

  late Razorpay _razorPay;
  Map<String, dynamic> createBody = {};
  late Templates selectedTemplate;

  VoucherAmount? voucherAmount;
  bool? haveVoucherCode = false;
  bool? isChecked = false;
  ValidateCardData? validatePPCardData;
  bool? isVerifiedUser = false;
  int? typedCardNumber;
  String? typedPromoCode;
  final _formKey = GlobalKey<FormState>();
  bool isCardVerified = false;
  CheckVoucherCodeValidOrNotmodel? voucherCodeData;
  @override
  void initState() {
    super.initState();
    selectedTemplate = widget.templates[0];

    if ([RedeemType.GIFT_REDEEM, RedeemType.SPIN_REDEEM_VOUCHER]
        .contains(widget.redeemData.redeemType)) {
      if (User.userName.contains(' ')) {
        int index = User.userName.lastIndexOf(' ');
        _textFieldControlFirstName.controller.text =
            User.userName.substring(0, index);
        _textFieldControlLastName.controller.text =
            User.userName.substring(index + 1);
      } else {
        _textFieldControlFirstName.controller.text = User.userName;
      }
      _textFieldControlPhone.controller.text = User.userMobile;
      _textFieldControlEmail.controller.text = User.userEmail;
      _textFieldControlMessage.controller.text = 'Redeem gift';
    }
    if (widget.redeemData.redeemType == RedeemType.SPIN_REDEEM_VOUCHER) {
      _textFieldControlDenomination.controller.text =
          '${widget.redeemData.denomination}';
      _textFieldControlQty.controller.text = '1';
    }
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == "AppLifecycleState.resumed") {
        // The app has resumed from the background
        // Call your API for status check here
        String key = await _getGatewayKey();
        await _startPayment(key, orderId);
      }
      return null;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(12),
                  children: [
                    Text(widget.woohooProductDetail.name ?? '',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20)),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Validity: ${widget.woohooProductDetail.expiry != null ? widget.woohooProductDetail.expiry : ''} from the date of issue',
                    ),

                    SizedBox(height: 12),
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight * .3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: widget.image ??
                              widget.woohooProductDetail.images?.mobile ??
                              '',
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/no_image.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    widget.woohooProductDetail.price!.type == 'SLAB'
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15.0, left: 15),
                                child: Text('Choose a denomination',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15)),
                              ),
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 2 / 1.3),
                                itemCount: widget.woohooProductDetail.price!
                                    .denominations!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  bool isSelected =
                                      _textFieldControlDenomination
                                              .controller.text ==
                                          widget.woohooProductDetail.price!
                                              .denominations![index];
                                  return GestureDetector(
                                    onTap: widget.redeemData.redeemType ==
                                            RedeemType.SPIN_REDEEM_VOUCHER
                                        ? null
                                        : () {
                                            setState(() {
                                              _textFieldControlDenomination
                                                      .controller.text =
                                                  widget
                                                      .woohooProductDetail
                                                      .price!
                                                      .denominations![index];
                                            });
                                          },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? secondaryColor.shade500
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color:
                                                widget.redeemData.redeemType ==
                                                        RedeemType
                                                            .SPIN_REDEEM_VOUCHER
                                                    ? Colors.grey.shade300
                                                    : secondaryColor),
                                      ),
                                      child: Center(
                                          child: Text(
                                        widget.woohooProductDetail.price!
                                            .denominations![index],
                                        style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : secondaryColor),
                                      )),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15.0, left: 15),
                                child: Text('Denomination',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15)),
                              ),
                              AppTextBox(
                                enabled: widget.redeemData.redeemType !=
                                    RedeemType.SPIN_REDEEM_VOUCHER,
                                textFieldControl: _textFieldControlDenomination,
                                hintText: 'Denomination',
                                keyboardType: TextInputType.number,
                                onChanged: (s) {
                                  setState(() {});
                                },
                              ),
                              if (widget.woohooProductDetail.price != null)
                                (Align(
                                    alignment: Alignment.centerRight,
                                    child: widget.redeemData.redeemType ==
                                            RedeemType.GIFT_REDEEM
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 12, top: 6),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Text(
                                                  ' Min: ',
                                                ),
                                                Image.asset(
                                                  'assets/images/ic_coins.png',
                                                  height: 12,
                                                ),
                                                Text(
                                                  ' ${widget.woohooProductDetail.price!.min} ',
                                                ),
                                                Text(
                                                  '  Max: ',
                                                ),
                                                Image.asset(
                                                  'assets/images/ic_coins.png',
                                                  height: 12,
                                                ),
                                                Text(
                                                  ' ${widget.woohooProductDetail.price!.max}',
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                right: 7.0, top: 2),
                                            child: Text(
                                              "Min: $rupeeSymbol ${widget.woohooProductDetail.price!.min}  Max: $rupeeSymbol ${widget.woohooProductDetail.price!.max}",
                                              style: TextStyle(
                                                  color: Colors.black26,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10),
                                            ),
                                          ))),

                              // Padding(
                              //   padding: EdgeInsets.only(
                              //     left: 10,
                              //     right: 8,
                              //   ),
                              //   child: TextFormField(
                              //     controller: _denominationController,
                              //     keyboardType: TextInputType.number,
                              //     textInputAction: TextInputAction.next,
                              //     inputFormatters: <TextInputFormatter>[
                              //       FilteringTextInputFormatter.digitsOnly
                              //     ],
                              //     decoration: InputDecoration(
                              //       border: UnderlineInputBorder(),
                              //     ),
                              //     validator: (value) {
                              //       if (value == null || value.isEmpty) {
                              //         return 'Please Enter Denomination';
                              //       }
                              //       return null;
                              //     },
                              //   ),
                              // ),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: Padding(
                              //     padding: EdgeInsets.only(right: 7.0, top: 2),
                              //     child: Text(
                              //       "Min: ₹ ${widget.woohooProductDetail.price!.min}  Max: ₹ ${widget.woohooProductDetail.price!.max}",
                              //       style: TextStyle(
                              //           color: Colors.black26,
                              //           fontWeight: FontWeight.w400,
                              //           fontSize: 10),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 15),
                      child: Text('Quantity',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15)),
                    ),
                    AppTextBox(
                      enabled: widget.redeemData.redeemType !=
                          RedeemType.SPIN_REDEEM_VOUCHER,
                      textFieldControl: _textFieldControlQty,
                      hintText: 'Quantity',
                      keyboardType: TextInputType.number,
                    ),

                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     left: 10,
                    //     right: 8,
                    //   ),
                    //   child: TextFormField(
                    //     controller: _qtyController,
                    //     keyboardType: TextInputType.number,
                    //     textInputAction: TextInputAction.next,
                    //     inputFormatters: <TextInputFormatter>[
                    //       FilteringTextInputFormatter.digitsOnly
                    //     ],
                    //     decoration: InputDecoration(
                    //       border: UnderlineInputBorder(),
                    //     ),
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please Enter Quantity';
                    //       }
                    //       if (int.parse(value) > 4) {
                    //         return "Only 4 Order at a time";
                    //       }
                    //     },
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 7.0, top: 2),
                        child: Text(
                          'Min:1 Max:4',
                          style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 15),
                      child: Text('Gifting Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15)),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextBox(
                            textFieldControl: _textFieldControlFirstName,
                            hintText: 'Receiver\'s first name',
                            onChanged: (s) {
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: AppTextBox(
                            textFieldControl: _textFieldControlLastName,
                            hintText: 'Receiver\'s last name',
                            onChanged: (s) {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    AppTextBox(
                      enabled: !(widget.redeemData.redeemType ==
                              RedeemType.GIFT_REDEEM &&
                          _textFieldControlEmail.controller.text
                              .trim()
                              .isNotEmpty),
                      textFieldControl: _textFieldControlEmail,
                      hintText: 'Receiver\'s Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     left: 10,
                    //     right: 8,
                    //   ),
                    //   child: TextFormField(
                    //     textInputAction: TextInputAction.next,
                    //     controller: _receiverNameController,
                    //     decoration: InputDecoration(
                    //       hintText: 'Receiver\'s Name',
                    //       border: UnderlineInputBorder(),
                    //     ),
                    //     onChanged: (s) {
                    //       setState(() {});
                    //     },
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please Enter Name';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     top: 10,
                    //     left: 10,
                    //     right: 8,
                    //   ),
                    //   child: TextFormField(
                    //     controller: _receiverEmailController,
                    //     keyboardType: TextInputType.emailAddress,
                    //     textInputAction: TextInputAction.next,
                    //     decoration: InputDecoration(
                    //       hintText: 'Receiver\'s Email',
                    //       border: UnderlineInputBorder(),
                    //     ),
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please Enter Email';
                    //       }
                    //       if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    //         return 'Please enter a valid Email';
                    //       }
                    //       if (value.contains(" ")) {
                    //         return 'Please enter a valid Email';
                    //       }
                    //     },
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 7.0, top: 2),
                        child: Text(
                          'Will be delivered to this id via Email',
                          style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _textFieldControlPhone.focusNode.hasFocus
                                  ? primaryColor
                                  : Colors.black26),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            GestureDetector(
                                child: Container(
                                    child: Container(
                                  margin: EdgeInsets.only(right: 1),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '+ ${_country.phoneCode} -',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      // Icon(Icons.keyboard_arrow_down_rounded)
                                    ],
                                  ),
                                )),
                                onTap: null
                                // () async {
                                //     Country? country = await Navigator.of(
                                //             context)
                                //         .push(PageRouteBuilder(
                                //             opaque: false,
                                //             pageBuilder: (_, __, ___) =>
                                //                 SelectCountryDialogScreen()));
                                //     if (country != null) {
                                //       setState(() {
                                //         _country = country;
                                //       });
                                //     }
                                //   },
                                ),
                            Expanded(
                              child: TextField(
                                scrollPhysics: BouncingScrollPhysics(),
                                controller: _textFieldControlPhone.controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textInputAction: TextInputAction.next,
                                focusNode: _textFieldControlPhone.focusNode,
                                minLines: 1,
                                maxLines: 1,
                                maxLength: 15,
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  hintText: 'Receiver\'s Mobile Number',
                                  hintStyle: TextStyle(fontSize: 14),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 7.0, top: 2),
                        child: Text(
                          'Will be delivered to this number via SMS',
                          style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ),
                    ),

                    AppTextBox(
                      textFieldControl: _textFieldControlMessage,
                      hintText: 'Message for Receiver',
                      textInputAction: TextInputAction.done,
                      onChanged: (s) {
                        setState(() {});
                      },
                    ),

                                        Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 15),
                      child: Text('Event ID',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15)),
                    ),

                 widget.eventId==null?
                 
                    AppTextBox(
                      enabled: true,
                      textFieldControl: _textFieldControlEventId,
                      keyboardType:TextInputType.number,
                      hintText: 'Enter event id',
                      textInputAction: TextInputAction.done,
                      onChanged: (s) {
                        setState(() {});
                      },
                    ) :  AppTextBox(
                      enabled: false,
                      
                      keyboardType:TextInputType.number,
                      hintText: '${widget.eventId}',
                      
                      textInputAction: TextInputAction.done,
                      onChanged: (s) {
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    widget.redeemData.redeemType ==
                                RedeemType.REDEEM_TOUCHPOINT ||
                            widget.redeemData.redeemType ==
                                RedeemType.GIFT_REDEEM
                        ? SizedBox()
                        : Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: haveVoucherCode,
                                      onChanged: (voucherCode) {
                                        setState(() {
                                          haveVoucherCode = voucherCode;
                                          isChecked = false;
                                        });
                                        if (voucherCode ?? false) {
                                          voucherCodeBottomSheet();
                                        } else {
                                          setState(() {
                                            haveVoucherCode = false;
                                          });
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            " Do you have any voucher code? ",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          FittedBox(
                                              child: Text(
                                                  "(Applicable for non Prezenty  Prepaid \n card users.)"))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    widget.redeemData.redeemType ==
                                RedeemType.REDEEM_TOUCHPOINT ||
                            widget.redeemData.redeemType ==
                                RedeemType.GIFT_REDEEM
                        ? SizedBox()
                        : widget.offers != null && widget.offers != 0.0
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            value: this.isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                this.isChecked = value;
                                                haveVoucherCode = false;
                                              });
                                              if (value == true) {
                                                cardNumberBottomSheet();
                                              } else {
                                                setState(() {
                                                  isCardVerified = false;
                                                });
                                              }
                                            }),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                " ${widget.offers!.toDouble()} % instant discount on Prezenty Prepaid \n card.",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(),

                    _uiTemplates(),
                    SizedBox(
                      height: 12,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 12,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.black38,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: screenWidth,
                                height: screenHeight * .3,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: widget.templateBaseUrl +
                                      selectedTemplate.imageFileUrl.toString(),
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/images/no_image.png'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                    _textFieldControlFirstName.controller.text
                                                    .trim() ==
                                                '' &&
                                            _textFieldControlLastName
                                                    .controller.text
                                                    .trim() ==
                                                ''
                                        ? 'Hi,'
                                        : '${_textFieldControlFirstName.controller.text.trim()} ${_textFieldControlLastName.controller.text.trim()}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'You\'ve got a ${widget.woohooProductDetail.name}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    _textFieldControlMessage.controller.text
                                                .trim() !=
                                            ''
                                        ? _textFieldControlMessage
                                            .controller.text
                                            .trim()
                                        : 'Your Message will appear here',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: SizedBox(
                                  width: screenWidth,
                                  height: screenHeight * .3,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: widget.image ??
                                        widget.woohooProductDetail.images
                                            ?.mobile ??
                                        '',
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/images/no_image.png'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  '$rupeeSymbol${_textFieldControlDenomination.controller.text != '' ? _textFieldControlDenomination.controller.text : '0.00'}',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Card Number',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'xxxxxxxxxxxxxxx',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Pin',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'xxxx',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Validity : xx xx xxxx',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.orange),
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
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: _validate,
                //  onPressed: payWithHiCardOrNot,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Continue'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _uiTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 12,
        ),
        Text('Select a theme'),
        SizedBox(
          height: 90,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: widget.templates.length,
              itemBuilder: (context, index) {
                print("index value is ${index}");
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedTemplate = widget.templates[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedTemplate == widget.templates[index]
                            ? secondaryColor.shade300
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    padding: selectedTemplate == widget.templates[index]
                        ? EdgeInsets.all(4)
                        : null,
                    height: 60,
                    width: 100,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: widget.templateBaseUrl +
                          widget.templates[index].imageFileUrl.toString(),
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/no_image.png'),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  _validate() async {
    String denomination = _textFieldControlDenomination.controller.text.trim();
    String quantity = _textFieldControlQty.controller.text.trim();
    String firstName = _textFieldControlFirstName.controller.text.trim();
    String lastName = _textFieldControlLastName.controller.text.trim();
    String receiverEmail = _textFieldControlEmail.controller.text.trim();
    String receiverPhone = _textFieldControlPhone.controller.text.trim();
    String message = _textFieldControlMessage.controller.text.trim();
    String eventId= _textFieldControlEventId.controller.text.trim();

    if (denomination.isEmpty) {
      toastMessage('Please provide the denomination');
      _textFieldControlDenomination.focusNode.requestFocus();
    } else {
      int min = int.parse(widget.woohooProductDetail.price!.min ?? '1');
      int max = int.parse(widget.woohooProductDetail.price!.max ?? '1');
      int den = int.parse(denomination);

      if (den < min || den > max) {
        toastMessage(
            'choose a denomination between ${widget.woohooProductDetail.price!.min} and ${widget.woohooProductDetail.price!.max}');
        _textFieldControlDenomination.focusNode.requestFocus();
      } else if (quantity.isEmpty) {
        toastMessage('Please provide the quantity');
        _textFieldControlQty.focusNode.requestFocus();
      } else {
        int q = int.parse(quantity);
        if (q < 1 || q > 4) {
          toastMessage('Please choose a quantity between 1 and 4');
          _textFieldControlQty.focusNode.requestFocus();
        } else if (firstName.isEmpty) {
          toastMessage('Please provide receiver\'s first name');
          _textFieldControlFirstName.focusNode.requestFocus();
        } else if (!firstName.isValidName()) {
          toastMessage('First name should contain only alphabets and space');
          _textFieldControlFirstName.focusNode.requestFocus();
        } else if (lastName.isEmpty) {
          toastMessage('Please provide receiver\'s last name');
          _textFieldControlLastName.focusNode.requestFocus();
        } else if (!lastName.isValidName()) {
          toastMessage('Last name should contain only alphabets and space');
          _textFieldControlLastName.focusNode.requestFocus();
        } else if (receiverEmail.isEmpty) {
          toastMessage('Please provide receiver\'s email address');
          _textFieldControlEmail.focusNode.requestFocus();
        } else if (!receiverEmail.isValidEmail()) {
          toastMessage('Please provide a valid email address');
          _textFieldControlEmail.focusNode.requestFocus();
        } else if (!receiverPhone.isValidMobileNumber()) {
          toastMessage('Please provide receiver\'s valid mobile number');
          _textFieldControlPhone.focusNode.requestFocus();
        } else if (message.isEmpty) {
          toastMessage('Please provide a message');
          _textFieldControlMessage.focusNode.requestFocus();
        } else {
          FocusScope.of(context).requestFocus(FocusNode());
          double voucherCodeOfferRate =
              double.parse('${voucherCodeData?.offer ?? "0.0"}');
          print("RRRR");
          print(voucherCodeOfferRate);
          print("LLLL");

          voucherCodeData?.offer != null || voucherCodeData?.offer != ""
              ? voucherCodeOfferRate = (voucherCodeOfferRate / 100)
              : "0";

          double offerRate = widget.offers != null || widget.offers != 0.0
              ? widget.offers! / 100
              : 0.0;
          int actualPrice = int.parse(denomination);
          num priceAfterOfferDiscount;
          haveVoucherCode ?? false
              ? priceAfterOfferDiscount = (voucherCodeOfferRate != 1.0)
                  ? actualPrice - (actualPrice * voucherCodeOfferRate)
                  : int.parse(denomination)
              : priceAfterOfferDiscount =
                  (offerRate != 1.0 && isCardVerified == true)
                      ? actualPrice - (actualPrice * offerRate)
                      : int.parse(denomination);

          if (widget.redeemData.redeemType == RedeemType.SPIN_REDEEM_VOUCHER) {
            priceAfterOfferDiscount -= widget.redeemData.discount ?? 0;
          }
          //(offerRate != 1 || offerRate != null)
          //    ? offerRate * int.parse(denomination)
          //    : 1 * int.parse(denomination);
          int qty = int.parse(quantity);

          if (widget.redeemData.redeemType == RedeemType.GIFT_REDEEM &&
              (priceAfterOfferDiscount * qty) > widget.redeemData.totalAmt!) {
            toastMessage('Insufficient balance');
            _textFieldControlDenomination.focusNode.requestFocus();
            return;
          }
          if (widget.redeemData.redeemType == RedeemType.REDEEM_TOUCHPOINT) {
            TouchPointWalletBalanceData? _balance =
                await _walletBloc.getTouchPointWalletBalance(User.userId);

            if (_balance != null) {
              voucherAmount = VoucherAmount(
                  quantity: qty,
                  denomination: actualPrice,
                  discountPercent: widget.offers ?? 0.0,
                  amountIncTax: double.parse('${actualPrice * qty}'));

              showTouchPointBalanceBottomSheet(_balance,
                  denomination: den, qty: qty, discountedPrice: actualPrice);
            }
          } else if (widget.redeemData.redeemType ==
              RedeemType.HI_REWARD_REDEEM) {
            if (User.userHiCardBalance != 0) {
              voucherAmount = VoucherAmount(
                  quantity: qty,
                  denomination: actualPrice,
                  discountPercent: widget.offers ?? 0.0,
                  amountIncTax: double.parse('${actualPrice * qty}'));
              print("vocher amount data = ${voucherAmount}");
              hiCardPay(hiCardPayableAmount: actualPrice);
            }
          } else {
            bool isBuy = ([
              RedeemType.BUY_VOUCHER,
              RedeemType.SPIN_REDEEM_VOUCHER
            ].contains(widget.redeemData.redeemType));

            PaymentTaxResponse? taxData = await PaymentBloc().getTaxInfo(
                isBuy,
                '${priceAfterOfferDiscount * qty}',
                '${actualPrice * qty}',
                '${widget.productId}',
                '${User.userId}',
                '${qty}',
                '${den}');

            if (taxData != null) {
              String? orderType;
              voucherAmount = VoucherAmount(
                quantity: qty,
                denomination: actualPrice,
                discountPercent: widget.offers ?? 0.0,
                amountIncTax: double.parse('${taxData.amount ?? '0.0'}'),
              );

              if (widget.redeemData.redeemType ==
                  RedeemType.SPIN_REDEEM_VOUCHER) {
                orderType = 'SPIN_BUY';
                taxData.data!.insert(
                    1,
                    TaxData(
                        key: 'Lucky spin discount',
                        value:
                            '$rupeeSymbol ${widget.redeemData.discount ?? 0}'));
              } else if (widget.redeemData.redeemType ==
                  RedeemType.BUY_VOUCHER) {
                orderType = 'BUY';
              } else if (widget.redeemData.redeemType == RedeemType.SEND_FOOD) {
                orderType = 'FOOD';
              }

              showTaxBottomSheet(context, taxData, (String state) {
                Get.back();
                // double netAmt = (price * qty).toDouble();
                // double discountPercent = widget.offers ?? 0.0;
                // double discountedAmt = double.parse('${taxData.amount}');
                _startPayOrRedeem(
                    state: state,
                    orderType: orderType,
                    insTableId: taxData.insTableId,
                    eventIdValue:  widget.eventId== null ?  eventId : widget.eventId);
              });
            }
          }
        }
      }
    }
  }

  hiCardPay({num? hiCardPayableAmount}) {
    _textFieldHIRewardPINEntered.value.controller.clear();
    _textFieldHIRewardsRedeem.value.controller.clear();

    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          
          String typedRedeemRewards =
              _textFieldHIRewardsRedeem.value.controller.text.trim();
          
          return SingleChildScrollView(
            child: StatefulBuilder(
                builder: ((context, setState) => SafeArea(
                        child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: CloseButton()),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                        child: Text(
                                      "Pay by H! rewards",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    )),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    Text(
                                        "Available Rewards: ${User.userHiCardBalance}",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Total payable amount',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      enabled: false,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "$rupeeSymbol ${hiCardPayableAmount}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Rewards to Redeem",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: AppTextBox(
                                          keyboardType: TextInputType.number,
                                          textFieldControl:
                                              _textFieldHIRewardsRedeem.value,
                                          onChanged: (p) {
                                            setState(() {
                                              typedRedeemRewards = p;
                                           
{

}                                            });
                                          },
                                        )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: AppTextBox(
                                          enabled: false,
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                                "${rupeeSymbol} ${typedRedeemRewards}"),
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                        )),
                                      ],
                                    ),
 
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Enter your H! reward PIN',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppTextBox(
                                      obscureText: true,
                                      enabled: true,
                                      textFieldControl:
                                          _textFieldHIRewardPINEntered.value,
                                      keyboardType: TextInputType.number,
                                      hintText: "Enter your H! Reward PIN",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 65, right: 65),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            String rewardPInTyped =
                                                _textFieldHIRewardPINEntered
                                                    .value.controller.text
                                                    .trim();
                                                    
                                                    if(typedRedeemRewards != hiCardPayableAmount.toString() ){
                                                    toastMessage("Payable amount and rewards points are not equal");
                                                    }
else{
 validateDetails(
                                                payableAmount:
                                                    hiCardPayableAmount,
                                                hiRewardPINTyped:
                                                    rewardPInTyped);
}
                                           
                                          },
                                          child: Text("Submit")),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )))),
          );
        });

  }

  validateRewardsToRedeem({String? msg}) {
    print("helo ai");
    return AppTextBox(
      enabled: false,
      hintText: "%{msg}",
    );
  }

  validateDetails({num? payableAmount, String? hiRewardPINTyped}) async {
    if (hiRewardPINTyped!.isEmpty) {
      toastMessage("Please enter your H! reward PIN");
    }

    CommonResponse? hiCardValidityData = await _profileBloc.checkHiCardValidity(
        cardNumber: User.userHiCardNo,
        pinNumber: hiRewardPINTyped,
        amount: payableAmount.toString());
    if (hiCardValidityData!.statusCode == 500) {
      toastMessage("${hiCardValidityData.message}");
    } else {
      _createOrder(
        orderType: "REDEEM",
        hiCardNo: User.userHiCardNo,
        hiCardPinNumber: User.userHiCardPin,
        hiCardPayableAmnt: payableAmount.toString(),
        enteredEventId: _textFieldControlEventId.controller.text.trim(), decentro_txn_id: null,
      );
    }
  }

  _item(String particular, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              particular,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            '$amount',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  showTouchPointBalanceBottomSheet(TouchPointWalletBalanceData balance,
      {required int denomination,
      required int qty,
      required num discountedPrice}) {
    // bool touchPointSelected = true;
// Bool walletSelected = false.obs;
//     bool paySelected = false;

    int selectedRadio = 1;

    // int editIndex = 0;
    // String selectedTouchValue = '';
    // String selectedPayValue = '';

    TextFieldControl _textControllerTouchPoints = TextFieldControl();
    TextFieldControl _textControllerPay = TextFieldControl();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        // double availableTouchPoints =
        //     double.parse(balance.touchPoints ?? '0.0');
        // num totalAmount = discountedPrice * qty;

        num touchPointValue =
            (int.tryParse(_textControllerTouchPoints.controller.text) ?? 0) /
                balance.unitTouchpoints;
        num amtValue = int.tryParse(_textControllerPay.controller.text) ?? 0;
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Payment',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              ),
              Divider(),
              _item('Denomination', '$rupeeSymbol $denomination'),
              _item(
                  'Discount', '$rupeeSymbol ${denomination - discountedPrice}'),
              _item('Quantity', '$qty'),
              _item('Total Amount', '$rupeeSymbol ${denomination * qty}'),
              _item('Payable Amount', '$rupeeSymbol ${discountedPrice * qty}'),
              Divider(),
              Center(
                child: Card(
                  elevation: 6,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text('Available Touch Point Balance'),
                        SizedBox(
                          height: 4,
                        ),
                        Text('${balance.touchPoints}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text('${balance.unitTouchpoints} Touchpoints = 1 Rupee',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: primaryColor)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Choose any redeem options',
                    style: TextStyle(fontSize: 16)),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              onChanged: (v) {
                                selectedRadio = v ?? 1;
                                setState(() {});
                              },
                              groupValue: selectedRadio,
                            ),
                            Expanded(child: Text('Touch Points only')),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 2,
                              onChanged: (v) {
                                selectedRadio = v ?? 2;
                                setState(() {});
                              },
                              groupValue: selectedRadio,
                            ),
                            Expanded(child: Text('TouchPoints + Payment')),
                          ],
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ([1, 2].contains(selectedRadio))
                        Expanded(
                          child: AppTextBox(
                            textFieldControl: _textControllerTouchPoints,
                            hintText: 'Touch points',
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              setState(() {});
                            },
                          ),
                        ),
                      SizedBox(
                        width: 8,
                      ),
                      if (selectedRadio == 2)
                        Expanded(
                          child: AppTextBox(
                            textFieldControl: _textControllerPay,
                            hintText: 'Pay amount',
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              setState(() {});
                            },
                          ),
                        ),
                    ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        'Equivalent Touchpoint Value ($rupeeSymbol): $touchPointValue',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Total Amount ($rupeeSymbol): ${touchPointValue + amtValue}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
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
                    int availableTouchPoints =
                        int.tryParse(balance.touchPoints ?? '0') ?? 0;
                    // int typedTouchPoints = int.tryParse(_textControllerTouchPoints.controller.text) ?? 0;
                    int typedTouchPoints = touchPointValue.toInt();
                    int typedPayAmount =
                        int.tryParse(_textControllerPay.controller.text) ?? 0;

                    if (selectedRadio == 2) {
                      //TOUCHPOINT_PAY

                      if (availableTouchPoints < typedTouchPoints) {
                        toastMessage(
                            "TouchPoint amount should be less than or equal to $availableTouchPoints",
                            isShort: false);
                      } else if ((discountedPrice * qty) !=
                          (typedTouchPoints + typedPayAmount)) {
                        toastMessage(
                            'Total amount needs to be $rupeeSymbol ${discountedPrice * qty}',
                            // "You have to pay ${(discountedPrice * qty)*balance.unitTouchpoints}. Please check the amount you entered",
                            isShort: false);
                      } else {
                        // Get.close(1);
                        _startPayOrRedeem(
                            orderType: 'TOUCHPOINT_PAY',
                            touchPoint: '$typedTouchPoints',
                            amount: _textControllerPay.controller.text.trim());
                      }
                    } else if (selectedRadio == 1) {
                      //TOUCHPOINT_ONLY

                      num payableAmt = (discountedPrice * qty);

                      if (payableAmt > availableTouchPoints) {
                        //no balance
                        toastMessage(
                            "You don't have enough touchpoints for this transaction. Please choose another redemption option",
                            isShort: false);
                      } else if (payableAmt != typedTouchPoints) {
                        //pay payable amt
                        toastMessage(
                            "You have to pay ${(discountedPrice * qty) * balance.unitTouchpoints} touch points",
                            isShort: false);
                      } else if (int.tryParse(
                              _textControllerTouchPoints.controller.text)! >
                          availableTouchPoints) {
                        toastMessage(
                            "You don't have enough touchpoints for this transaction");
                      }

                      //       }else{
                      //create

                      // if (availableTouchPoints != typedTouchPoints) {
                      //   toastMessage(
                      //       "You have to pay ${(discountedPrice * qty)} touch points",
                      //       isShort: false);
                      // if ((discountedPrice * qty) > availableTouchPoints) {
                      //   toastMessage(
                      //       "You don't have enough touchpoints for this transaction. Please choose another redemption option",
                      //       isShort: false);
                      // }else if ((discountedPrice * qty) != typedTouchPoints) {
                      //   toastMessage(
                      //   "You have to pay ${(discountedPrice * qty)} touch points",
                      //       isShort: false);
                      // } else if (availableTouchPoints != typedTouchPoints) {
                      //   toastMessage(
                      //       "TouchPoint amount should be less than or equal to $availableTouchPoints",
                      //       isShort: false);

                      // } else if (availableTouchPoints > typedTouchPoints) {
                      //   toastMessage(
                      //       "You have to pay ${(discountedPrice * qty)} touch points",
                      //       isShort: false);
                      // } else if ((discountedPrice * qty) != typedTouchPoints) {
                      //   toastMessage(
                      //       "You don't have enough touchpoints for this transaction. Please choose another redemption option",
                      //       isShort: false);

                      else {
                        // Get.close(1);
                        _createOrder(
                            orderType: 'TOUCHPOINT_ONLY',
                            touchPoint: _textControllerTouchPoints
                                .controller.text
                                .trim(), decentro_txn_id: null);
                      }
                    } else {
                      toastMessage('Choose any method to pay');
                    }
                    // Get.close(1);
                    // _createOrder();
                    // _startPayOrRedeem('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      backgroundColor: Colors.white,
    );

    // showModalBottomSheet(
    //     context: Get.context!,
    //     isScrollControlled: true,
    //     enableDrag: false,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //     builder: (builder) {
    //       return StatefulBuilder(
    //           builder: (BuildContext context, setState) => Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(16),
    //                 child:   Text('Payment',textAlign: TextAlign.center,
    //                   style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
    //                 ),
    //               ),
    //               Divider(height: 1,),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     ListView.builder(
    //                         shrinkWrap: true,
    //                         itemCount: taxResponse.data!.length,
    //                         itemBuilder: (context,index){
    //                           return Padding(
    //                             padding: const EdgeInsets.symmetric(vertical: 2),
    //                             child: Row(
    //                               crossAxisAlignment: CrossAxisAlignment.center,
    //                               mainAxisAlignment: MainAxisAlignment.center,
    //                               children: [
    //                                 Expanded(
    //                                   child: Text(
    //                                     taxResponse.data![index].key??'',
    //                                     style: TextStyle(fontSize: 16, ),
    //                                   ),
    //                                 ),
    //                                 Text(
    //                                   '${taxResponse.data![index].value}',
    //                                   style: TextStyle(fontSize: 16, ),
    //                                 ),
    //                               ],
    //                             ),
    //                           );
    //                         }),
    //                     SizedBox(
    //                       height: 12,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //
    //               Container(
    //                 margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
    //                 padding: const EdgeInsets.all(8),
    //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
    //                     border: Border.all(color:Colors.black26)),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Text('State',style: TextStyle(color: Colors.black54),),
    //                     DropdownButton<String>(
    //                       value: state,
    //                       isExpanded: true,menuMaxHeight: 300,
    //
    //                       underline: SizedBox(),
    //                       onChanged: (String? data) {
    //                         setState(() {
    //                           state = data!;
    //                         });
    //                       },
    //                       items: states.map<DropdownMenuItem<String>>((value) {
    //                         return DropdownMenuItem<String>(
    //                           value: value,
    //                           child: Text(value),
    //                         );
    //                       }).toList(),
    //                     ),
    //                   ],
    //                 ),),
    //
    //               Padding(
    //                 padding: const EdgeInsets.all(12),
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(12)),
    //                   ),
    //                   onPressed: (){
    //                     onTap(state);
    //                   },
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(16),
    //                     child: Text('Pay  $rupeeSymbol${taxResponse.amount ?? 0}'),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ));
    //     });
  }
  String orderId="";
  _startPayOrRedeem(
      {String? state,
      String? orderType,
      String? touchPoint,
      String? amount,
      int? insTableId,
      String? eventIdValue}) async {
    print("First amount -${amount}");

    if ([
      RedeemType.BUY_VOUCHER,
      RedeemType.REDEEM_TOUCHPOINT,
      RedeemType.SPIN_REDEEM_VOUCHER
    ].contains(widget.redeemData.redeemType)) {
      String key = await _getGatewayKey();
      if (key.isEmpty) {
        toastMessage('Unable to get payment key');
      } else {

        if (widget.redeemData.redeemType == RedeemType.BUY_VOUCHER) {
          orderId = await _getGatewayOrderIdConfirmVoucherAmount(
              amount ?? '${voucherAmount!.amountIncTax}', insTableId ?? 0);
        } else {
         widget.redeemData.redeemType=="BUY" ?showPaymentConfirmationDialog(context,"${voucherAmount!.amountIncTax}",orderId):showPaymentConfirmationDialog1(context,"${voucherAmount!.amountIncTax}",orderId);
          // orderId = await _getGatewayOrderId(
          //     amount ?? '${voucherAmount!.amountIncTax}');
        }
        if (orderId.isEmpty) {
          toastMessage('Unable to get order');
        } else {
          print("Amount-->${amount}");
        showPaymentConfirmationDialog(context,"${voucherAmount!.amountIncTax}",orderId);
        //   _startPayment(key, orderId,
        //       state: state,
        //       orderType: orderType,
        //       touchPoint: touchPoint,
        //       amount: amount,eventID: eventIdValue);
        }
      }
    } else if (widget.redeemData.redeemType == RedeemType.GIFT_REDEEM) {
      if (voucherAmount!.amountIncTax > widget.redeemData.totalAmt!) {
        toastMessage('Insufficient balance');
        _textFieldControlDenomination.focusNode.requestFocus();
      } else {
        _redeem(state ?? '');
      }
    }
  }
  void showPaymentConfirmationDialog(BuildContext context,String? amount,orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Confirmation'),
          content: Text('Are you sure you want to make the payment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                await getupcard(amount,orderId);

                // Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
                // Perform the payment logic here
                // For example, you can call a function to initiate the payment
                // If the payment is successful, you can close the dialog
                // If the payment fails, you can show an error message or handle it accordingly
                // For this example, let's just close the dialog

              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();

              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  void showPaymentConfirmationDialog1(BuildContext context,String? amount,orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Confirmation'),
          content: Text('Are you sure you want to make the payment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                await getupcardspin(amount,orderId);

                // Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
                // Perform the payment logic here
                // For example, you can call a function to initiate the payment
                // If the payment is successful, you can close the dialog
                // If the payment fails, you can show an error message or handle it accordingly
                // For this example, let's just close the dialog

              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();

              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  int taxid= 0;
  Future<paymentupiResponse?> getupcardspin(String? amount,orderId) async {
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upilink}',
        options: Options(
          followRedirects: true,
        ),
        data: {
          "amount": amount,
          "type": "spin",

        },

      );

      paymentupiResponse getupiResponse =
      paymentupiResponse.fromJson(response.data);
      print("response->${getupiResponse}");
      taxid = getupiResponse.data!.txnTblId!;


      // Check if the API call was successful before launching the URL
      if (getupiResponse != null && getupiResponse.statusCode==200) {
        // Replace 'your_url_here' with the actual URL you want to launch
        String url = 'your_url_here';

        // Launch the URL
        await launch("${getupiResponse.data!.paymentLink}");


      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
  Future<paymentupiResponse?> getupcard(String? amount,orderId) async {
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upilink}',
        options: Options(
          followRedirects: true,
        ),
        data: {
          "amount": amount,
          "type": "gift",
          "order_id":orderId
        },

      );

      paymentupiResponse getupiResponse =
      paymentupiResponse.fromJson(response.data);
      print("response->${getupiResponse}");
      taxid = getupiResponse.data!.txnTblId!;


      // Check if the API call was successful before launching the URL
      if (getupiResponse != null && getupiResponse.statusCode==200) {
        // Replace 'your_url_here' with the actual URL you want to launch
        String url = 'your_url_here';

        // Launch the URL
        await launch("${getupiResponse.data!.paymentLink}");


      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
String decentro_txn_id= "";
  // Future<UpiSucess?> getupistatus() async {
  //   try {
  //
  //     final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
  //       '${Apis.upistatus}',
  //       data: {
  //         "txn_tbl_id": taxid,
  //       },
  //     );
  //
  //     UpiSucess getupiResponse =
  //     UpiSucess.fromJson(response.data);
  //     decentro_txn_id = getupiResponse.decentro_txn_id!;
  //     print("response->${decentro_txn_id}");
  //
  //
  //
  //     // Check if the API call was successful before launching the URL
  //     if (getupiResponse != null && getupiResponse.statusCode==200) {
  //
  //       // Replace 'your_url_here' with the actual URL you want to launch
  //       // showStatusAlert("${getupiResponse.message}");
  //       // Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
  //
  //     }else{
  //       // showStatusAlert("${getupiResponse.message}");
  //     }
  //
  //     return getupiResponse;
  //   } catch (e, s) {
  //     Get.back();
  //     Completer().completeError(e, s);
  //     toastMessage(ApiErrorMessage.getNetworkError(e));
  //   }
  //   return null;
  // }


  Future<String> _getGatewayKey() async {
    try {
      AppDialogs.loading();
      final response =
          await ApiProvider().getJsonInstance().get(Apis.getPaymentGatewayKey);
      GatewayKeyResponse _gatewayKeyResponse =
          GatewayKeyResponse.fromJson(response.data);
      Get.back();
      return _gatewayKeyResponse.apiKey ?? '';
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return '';
  }

  Future<String> _getGatewayOrderId(String amount) async {
    try {
      AppDialogs.loading();
      final response = await ApiProvider()
          .getJsonInstance()
          .get('${Apis.getPaymentGatewayOrderId}?amount=$amount');
      GatewayKeyResponse _gatewayKeyResponse =
          GatewayKeyResponse.fromJson(response.data);
      Get.back();
      return _gatewayKeyResponse.orderId ?? '';
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return '';
  }

  Future<String> _getGatewayOrderIdConfirmVoucherAmount(
      String amount, int insTableId) async {
    try {
      AppDialogs.loading();
      Map body = {
        'amount': amount,
        'ins_table_id': insTableId,
        'cheked_agree': 'checked',
      };
      final response = await ApiProvider().getJsonInstance().post(
          '${Apis.getPaymentGatewayConfirmVoucherAmountOrderId}',
          data: body);
      GatewayKeyResponse _gatewayKeyResponse =
          GatewayKeyResponse.fromJson(response.data);
      Get.back();
      return _gatewayKeyResponse.orderId ?? '';
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return '';
  }

  _startPayment(String key, String orderId,
      {String? state, String? orderType, String? touchPoint, String? amount,String? eventID}) async {

    // try {
    //   _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
    //       (PaymentSuccessResponse paymentSuccessResponse) {
    //    // toastMessage('Payment successful');
    //     Get.back();
    //     Future.delayed(Duration(milliseconds: 500), () {
    //       _createOrder(
    //           rzpPaymentId: paymentSuccessResponse.paymentId,
    //           orderType: orderType,
    //           touchPoint: touchPoint,
    //           amount: amount,enteredEventId: eventID);
    //     });
    //   });
    //   _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
    //       (PaymentFailureResponse paymentFailureResponse) {
    //     _onPaymentErrorFn(paymentFailureResponse);
    //   });
    //
    //   _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});
    //
    //   int amt = 0;
    //   if (amount == null) {
    //     amt = (voucherAmount!.amountIncTax * 100).floor();
    //   } else {
    //     amt = (double.parse(amount) * 100).floor();
    //   }
    //
    //   var options = {
    //     'key': key,
    //     'amount': amt,
    //     'order_id': orderId,
    //     'currency': "INR",
    //     'name': 'Prezenty',
    //     'description': 'Payment',
    //     'prefill': {
    //       'name': '${User.userName}',
    //       'contact': '${_country.phoneCode}${User.userMobile}',
    //       'email': '${User.userEmail}'
    //     },
    //     'notes': {
    //       "type": "BUY_VOUCHER",
    //       "user_id": User.userId,
    //       "product_id": widget.productId,
    //       "amount": voucherAmount!.amountIncTax,
    //       "state": state,
    //       "discount": voucherAmount!.discountPercent,
    //       "discount_amt": voucherAmount!.discountPercentAmt,
    //       "org_amount": voucherAmount!.totalVoucherAmount,
    //     }
    //   };
    //
    //   debugPrint(jsonEncode(options));
    //
    //   _razorPay.open(options);
    //   return true;
    // } catch (e, s) {
    //   Completer().completeError(e, s);
    //   toastMessage('Unable to start payment. Please try again');
    //   return false;
    // }
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upistatus}',
        data: {
          "txn_tbl_id": taxid,
        },
      );

      UpiSucess getupiResponse =
      UpiSucess.fromJson(response.data);
      decentro_txn_id = getupiResponse.decentro_txn_id!;
      print("response->${decentro_txn_id}");



      // Check if the API call was successful before launching the URL
      if (getupiResponse.message=="SUCCESS") {
        _createOrder(
            decentro_txn_id: decentro_txn_id,
            orderType: "BUY",
            touchPoint: touchPoint,
            amount: amount,enteredEventId: eventID);
        // Future.delayed(Duration(milliseconds: 500), () {
        //
        // });
        // Replace 'your_url_here' with the actual URL you want to launch
        // showStatusAlert("${getupiResponse.message}");
        // Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));

      }else{
        _showOrderRetryDialog();
      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }


  _showOrderRetryDialog() {
    //goToHomeScreen();
Get.to(() => SuccessOrFailedScreen(isSuccess: false,content: "Unable to create order.Please try again later.",));

    // Get.offAll(() => WoohooVoucherListScreen(
    //       redeemData: RedeemData.buyVoucher(),
    //       showBackButton: false,
    //     ));
    // AppDialogs.message('Unable to create order');
    // return;

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text('Unable to create order. Try again?'),
    //       actions: [
    //         OutlinedButton(
    //           child: Text('No'),
    //           onPressed: () {
    //             Get.back();
    //           },
    //         ),
    //         ElevatedButton(
    //           child: Text('Yes'),
    //           onPressed: () {
    //             Get.back();
    //             _createOrder();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  Map<String, dynamic> getBody() {
    String referenceNo = 'prezenty_${DateTime.now().millisecondsSinceEpoch}';

    Map<String, dynamic> body = {
      "address": {
        "country": "${_country.isoCode}",
        "firstname": _textFieldControlFirstName.controller.text.trim(),
        "lastname": _textFieldControlLastName.controller.text.trim(),
        "email": "${_textFieldControlEmail.controller.text.trim()}",
        "telephone":
            '+${_country.phoneCode}${_textFieldControlPhone.controller.text.trim()}',
        "billToThis": true
      },
      "billing": {
        "email": "${_textFieldControlEmail.controller.text.trim()}",
        "telephone":
            "+${_country.phoneCode}${_textFieldControlPhone.controller.text.trim()}",
        "country": "${_country.isoCode}",
        "firstname": _textFieldControlFirstName.controller.text.trim(),
        "lastname": _textFieldControlLastName.controller.text.trim(),
      },
      "payments": [
        {
          "code": "svc",
          "amount": voucherAmount!.totalVoucherAmount,
          "discount_amt": voucherAmount!.discountPercentAmt,
          "discount": voucherAmount!.discountPercent,
          "org_amount": voucherAmount!.totalVoucherAmount -
              voucherAmount!.discountPercentAmt,
          "template_img": selectedTemplate.id
        }
      ],
      "refno": referenceNo,
      "products": [
        {
          "sku": widget.woohooProductDetail.sku,
          "price": _textFieldControlDenomination.controller.text,
          "qty": _textFieldControlQty.controller.text,
          "currency": 356,
          "giftMessage": _textFieldControlMessage.controller.text,
        }
      ],
      "syncOnly": true,
      "deliveryMode": "API"
    };

    print(jsonEncode(body));
    return body;
  }

  _createOrder(
   
      {
        int? redeemTransactionId,
        String? rzpPaymentId,
        String? state,
        String? orderType,
        String? touchPoint,
        String? amount,
        String? hiCardNo,
        String? hiCardPinNumber,
        String? hiCardPayableAmnt,
        String? enteredEventId, required decentro_txn_id}) async {
    try {
      createBody = getBody();
     
      dynamic response = await _bloc.createOrder(
          userId: User.userId,
          woohooProductId: widget.productId,
          orderBody: createBody,
          redeemTransactionId: redeemTransactionId,
          rzpPaymentId: rzpPaymentId,
          stateForRedeem: state,
          themeId: selectedTemplate.id,
          orderType: orderType,
          touchPoint: touchPoint,
          payAmount: amount,
          insTableId: widget.redeemData.instTableID ?? 0,
          hiCardNo: hiCardNo,
          hiCardPinNumber: hiCardPinNumber,
          payableAmnt: hiCardPayableAmnt,
          eventId: enteredEventId,
          decentro_txn_id: decentro_txn_id
      );

      if (response == null) {
        _showOrderRetryDialog();
        return;
      }

      if (response is WoohooCreateOrderResponse) {
        if (response.success ?? false) {
          if (response.data!.status == 'COMPLETE') {
            //goToHomeScreen();
            // Get.offAll(() => WoohooVoucherListScreen(
            //     redeemData: RedeemData.buyVoucher(), showBackButton: false));

            Get.to(() => SuccessOrFailedScreen(isSuccess: true,content: "Your order placed successfully.\nAnd the voucher will be sent to the provided email shortly.",));
          //_showSuccessDialog();
          } else if (response.data!.status == 'PROCESSING') {
            _getOrderStatus();
          } else {
            _showOrderRetryDialog();
          }
        } else {
          //goToHomeScreen();

          // Get.offAll(() => WoohooVoucherListScreen(
          //       redeemData: RedeemData.buyVoucher(),
          //       showBackButton: false,
          //     ));
           Get.to(() => SuccessOrFailedScreen(isSuccess: false,content: "Unable to create order.",));
          // AppDialogs.message(
          //     response.data!.message ?? 'Unable to create order');
        }
      } else {
        _getOrderStatus();
      }
      if (orderType != 'TOUCHPOINT_ONLY') {
        _bloc.sendInvoice(
            orderType ?? (rzpPaymentId != null ? 'BUY' : 'REDEEM'),
            rzpPaymentId ?? '$redeemTransactionId');
      }
    } catch (e, s) {
      _showOrderRetryDialog();
      Completer().completeError(e, s);
      toastMessage('Unable to create order');
    } finally {}
  }

  _getOrderStatus() async {
    try {
      OrderStatusResponse? response =
          await _bloc.getOrderStatus(createBody['refno']);

      if (response == null) {
        _showOrderRetryDialog();
        return;
      }

      if (response.success ?? false) {
        if (response.data!.status == 'COMPLETE') {
          _getActiveCards(response.data!.orderId ?? '');
        } else if (response.data!.status == 'CANCELED') {
          _showOrderRetryDialog();
        } else {
          //PENDING || PROCESSING
          // _getOrderStatus();
          _showOrderRetryDialog();
        }
      } else {
        toastMessage(response.message ?? 'Unable to check order status');
        _showOrderRetryDialog();
      }
    } catch (e, s) {
      _showOrderRetryDialog();
      Completer().completeError(e, s);
      toastMessage('Unable to create order');
    }
  }

  _getActiveCards(String orderId) async {
    try {
      OrderStatusResponse? response = await _bloc.getActiveCards(orderId);

      if (response == null) {
        _getActiveCards(orderId);
        return;
      }

      if ((response.success ?? false)) {
        //goToHomeScreen();

        // Get.offAll(() => WoohooVoucherListScreen(
        //     redeemData: RedeemData.buyVoucher(), showBackButton: false));
         Get.to(() => SuccessOrFailedScreen(isSuccess: true,content: "Your order placed successfully.\nAnd the voucher will be sent to the provided email shortly.",));
        //_showSuccessDialog();
      } else {
        _getActiveCards(orderId);
      }
    } catch (e, s) {
      _getActiveCards(orderId);
      Completer().completeError(e, s);
      toastMessage('Unable to check card details');
    }
  }

  _showSuccessDialog() {
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
                    'Your order placed successfully.\nAnd the voucher will be sent to the provided email shortly.',
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

  _onPaymentErrorFn(PaymentFailureResponse response) {
    String msg = '';
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      msg = 'Payment Has Been Cancelled';
    } else if (response.code == Razorpay.NETWORK_ERROR) {
      msg = 'Network Issues while payment request';
    } else {
      msg = 'Payment Error, Try after some time';
    }

    Get.dialog(
      Center(
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.red.shade300,
                  size: 70,
                ),
                SizedBox(height: 16),
                Text(
                  '$msg',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _redeem(String state) async {
    FocusScope.of(context).requestFocus(FocusNode());

    int? redeemId = await _bloc.createRedeemOrder({
      "amount": voucherAmount!.amountIncTax,
      "event_id": widget.redeemData.eventId!,
      "user_id": User.userId
    });
    if (redeemId != null) {
      if (voucherAmount!.amountIncTax > widget.redeemData.totalAmt!) {
        toastMessage('Insufficient balance');
        _textFieldControlDenomination.focusNode.requestFocus();
      } else {
        _createOrder(redeemTransactionId: redeemId, state: state, decentro_txn_id: null);
      }
    }
  }

  Future voucherCodeBottomSheet() async {
    _textFieldVoucherCode.controller.clear();
    await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) => SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) => SafeArea(
                  child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Enter the voucher code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: _textFieldVoucherCode.controller,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (value) => typedPromoCode = value,
                                  validator: (value) {
                                    return _textFieldVoucherCode
                                            .controller.text.isEmpty
                                        ? "Enter a valid promocode"
                                        : null;
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton(
                                      child: Text("Submit"),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          voucherCodeData = await _bloc
                                              .checkVoucherCodeValidOrNot(
                                                  _textFieldVoucherCode
                                                      .controller.text,
                                                  widget.productId);

                                          if (voucherCodeData!.statusCode ==
                                              200) {
                                            toastMessage("Promo Code is valid");
                                            Get.back();
                                          } else {
                                            toastMessage("Invalid Promo Code");
                                          }
                                        } else {
                                          toastMessage(
                                              "Please provide a valid promo code");
                                        }
                                      },
                                    )),
                              ]),
                        ),
                      )),
                ),
              ),
            ),
          );
        });
  }

  Future cardNumberBottomSheet() async {
    _textFieldControlCardNumber.controller.clear();
    await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) => SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) => SafeArea(
                  child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Enter the last 6 digits of your card',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                TextFormField(
                                  controller:
                                      _textFieldControlCardNumber.controller,
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (value) =>
                                      typedCardNumber = int.parse(value),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    return value!.isEmpty || value.length != 6
                                        ? "Enter the last 6 didgits of your card"
                                        : null;
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton(
                                      child: Text("Submit"),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          ValidateCardData? data =
                                              await _walletBloc
                                                  .validatePrepaidCardNumber(
                                                      User.userId,
                                                      _textFieldControlCardNumber
                                                          .controller.text);
                                          if (data?.verified == "yes") {
                                            setState(() {
                                              isCardVerified = true;
                                            });
                                            toastMessage("Verified.");
                                            Get.back();
                                          } else {
                                            toastMessage("Not verified.");
                                          }
                                        } else {
                                          toastMessage(
                                              "Please provide valid details");
                                        }
                                      },
                                    )),
                              ]),
                        ),
                      )),
                ),
              ),
            ),
          );
        });
  }
}

class VoucherAmount {
  final int denomination;
  final int quantity;
  final double discountPercent;
  final double amountIncTax;

  VoucherAmount(
      {required this.denomination,
      required this.quantity,
      required this.discountPercent,
      required this.amountIncTax});

  int get netAmt => (denomination * quantity);

  get totalVoucherAmount => denomination * quantity;
  get discountPercentAmt => (discountPercent != 1.0)
      ? (denomination * discountPercent) / 100
      : denomination;
}
