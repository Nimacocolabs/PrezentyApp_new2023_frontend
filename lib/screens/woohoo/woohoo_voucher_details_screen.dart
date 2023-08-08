import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/payment_bloc.dart';
import 'package:event_app/bloc/send_food_bloc.dart';
import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/gateway_key_response.dart';
import 'package:event_app/models/payment_tax_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_payment_order_details.dart';
import 'package:event_app/models/woohoo/woohoo_product_detail_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/screens/event/send_food_create_order_screen.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/screens/payment/payment_v2_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_buy_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/succes_or_failed_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'woohoo_voucher_list_screen.dart';

class WoohooVoucherDetailsScreen extends StatefulWidget {
  final int productId;
  final RedeemData redeemData;
  final String? eventId;

  const WoohooVoucherDetailsScreen(
      {Key? key, required this.productId, required this.redeemData,this.eventId})
      : super(key: key);

  @override
  _WoohooVoucherDetailsScreenState createState() =>
      _WoohooVoucherDetailsScreenState();
}

class _WoohooVoucherDetailsScreenState
    extends State<WoohooVoucherDetailsScreen> {
  WoohooProductBloc _bloc = WoohooProductBloc();
  TextFieldControl _textFieldControlDenomination = TextFieldControl();

  SendFoodVoucherBloc _sendFoodbloc = SendFoodVoucherBloc();
    PaymentBloc _paymentBloc = PaymentBloc();
  PaymentTaxResponse? _invoiceResponse;
  late Razorpay _razorPay;
  WalletPaymentOrderDetails? paymentOrderDetails;

  @override
  void initState() {
    super.initState();
    _bloc.getProductDetails(widget.productId);
    print(":event id  =   ${widget.eventId}");
  }

  @override
  void dispose() {
    _bloc.dispose();
    _sendFoodbloc.dispose();
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
        child: StreamBuilder<ApiResponse<dynamic>>(
            stream: _bloc.detailsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status!) {
                  case Status.LOADING:
                    return CommonApiLoader();
                  case Status.COMPLETED:
                    WoohooProductDetailResponse resp = snapshot.data!.data;
                    return _buildContent(resp);
                  case Status.ERROR:
                    return CommonApiErrorWidget(snapshot.data!.message!, () {
                      _bloc.getProductDetails(widget.productId);
                    });
                }
              }

              return SizedBox();
            }),
      ),
    );
  }

  _buildContent(WoohooProductDetailResponse response) {
    if (response.data == null) {
      return CommonApiResultsEmptyWidget('No Result');
    }
    WoohooProductDetail productDetail = response.data!;
    List<String> tAndC = productDetail.tnc!.content != null
        ? productDetail.tnc!.content!.split('<br/>')
        : [];
    int tAndCL = tAndC.length;
    return Column(
      children: [
        Expanded(
          child: ListView(padding: const EdgeInsets.all(12), children: [
            Text(productDetail.name ?? '',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20)),
            SizedBox(
              height: 12,
            ),
            Text(
              'Validity: ${productDetail.expiry != null ? productDetail.expiry : ''} ',
            ),
            SizedBox(height: 12),
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * .3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          response.image ?? productDetail.images?.mobile ?? '',
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/no_image.png'),
                    ),
                  ),
                ),
                // response.offers != null && response.offers != ""
                //     ? Positioned(
                //         left: 0,
                //         bottom: 20,
                //         child: Container(
                //           color: primaryColor,
                //           child: Padding(
                //             padding: const EdgeInsets.all(4.0),
                //             child: Row(
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Text('${response.offers ?? ''}  \n',
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis,
                //                     style: TextStyle(
                //                         color: Colors.yellow,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 18)),
                //                 Text("% OFF",
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis,
                //                     style: TextStyle(
                //                         color: Colors.yellow,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 18))
                //               ],
                //             ),
                //           ),
                //         ),
                //       )
                //     : Container(),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text('DESCRIPTION',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HtmlWidget(
                productDetail.description ?? '',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text('DENOMINATION',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            if (productDetail.price != null)
              (widget.redeemData.redeemType == RedeemType.GIFT_REDEEM
                  ? Padding(
                      padding: EdgeInsets.only(left: 12, top: 6),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            ' Min: ',
                          ),
                          Image.asset(
                            'assets/images/ic_coins.png',
                            height: 12,
                          ),
                          Text(
                            ' ${productDetail.price!.min} ',
                          ),
                          Text(
                            '  Max: ',
                          ),
                          Image.asset(
                            'assets/images/ic_coins.png',
                            height: 12,
                          ),
                          Text(
                            ' ${productDetail.price!.max}',
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 12, top: 6),
                      child: Text(
                        ' ${productDetail.price != null ? "Min: $rupeeSymbol ${productDetail.price!.min}  Max: $rupeeSymbol ${productDetail.price!.max}" : ''}',
                      ),
                    )),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text('TERMS AND CONDITION',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                  ),
                )
              ],
            ),

            SizedBox(
              height: 12,
            ),
            productDetail.tnc!.content != null
                ? HtmlWidget(productDetail.tnc!.content!)
                : Container(),

            // Column(
            //   children: tAndC.map((word) {
            //     return ListTile(
            //       horizontalTitleGap: 0,
            //       contentPadding: EdgeInsets.only(left: 8),
            //       dense: true,
            //       leading: Container(
            //         height: 10,
            //         width: 10,
            //         decoration: new BoxDecoration(
            //           color: Colors.black,
            //           shape: BoxShape.circle,
            //         ),
            //       ),
            //       title: Text(
            //         word,
            //         style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            //       ),
            //     );
            //   }).toList(),
            // ),

            // Padding(
            //   padding: EdgeInsets.only(
            //     left: 12,
            //     top: 6,
            //   ),
            //   child: Text(productDetail.tnc!.content ?? ''),
            // ),

            // GestureDetector(
            //   onTap: () async {
            //     if (await canLaunch(termsUrlLogin)) {
            //       await launch(productDetail.tnc?.link ?? '');
            //     } else {
            //       toastMessage('Unable to open url ${productDetail.tnc?.link ?? ''}');
            //     }
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 12, top: 10.0),
            //     child: Text(
            //         '${productDetail.tnc?.link != null ? productDetail.tnc?.link : 'Not Available'}',
            //         style: TextStyle(
            //           color: Colors.blue,
            //           decoration: TextDecoration.underline,
            //         ),
            //         maxLines: 3),
            //   ),
            // ),
            SizedBox(height: 50),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDenomination(productDetail),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  double? ofr = response.offers != ""
                      ? double?.parse(response.offers ?? '0.0')
                      : 0.0;

                  _validate(productDetail, response.templates,response.basePathTemplatesImages,response.image, offers: ofr);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      widget.redeemData.redeemType == RedeemType.SEND_FOOD
                          ? 'Select voucher'
                          : 'Buy Now'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildDenomination(WoohooProductDetail productDetail) {
    if (widget.redeemData.redeemType != RedeemType.SEND_FOOD) return SizedBox();

    return ((productDetail.price!.denominations ?? []).isNotEmpty)
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2 / 1.3),
                itemCount: productDetail.price!.denominations!.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isSelected =
                      _textFieldControlDenomination.controller.text ==
                          productDetail.price!.denominations![index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _textFieldControlDenomination.controller.text =
                            productDetail.price!.denominations![index];
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? secondaryColor.shade500
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: secondaryColor),
                      ),
                      child: Center(
                          child: Text(
                        productDetail.price!.denominations![index],
                        style: TextStyle(
                            color: isSelected ? Colors.white : secondaryColor),
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
                child: Text('Enter denomination',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15)),
              ),
              AppTextBox(
                textFieldControl: _textFieldControlDenomination,
                hintText: 'Denomination',
                keyboardType: TextInputType.number,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 7.0, top: 2),
                  child: Text(
                    "Min: $rupeeSymbol ${productDetail.price!.min}  Max: $rupeeSymbol ${productDetail.price!.max}",
                    style: TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.w400,
                        fontSize: 10),
                  ),
                ),
              ),
            ],
          );
  }

  _validate(WoohooProductDetail productDetail,List<Templates>? templates,String? templateBaseUrl, String? image,
      {double? offers}) async {
    if (User.apiToken.isEmpty) {
      Get.to(
          () => LoginScreen(
                isFromWoohoo: true,
              ),
          transition: Transition.fade);
    } else {
      if (widget.redeemData.redeemType == RedeemType.SEND_FOOD) {
        String denomination =
            _textFieldControlDenomination.controller.text.trim();

        if (denomination.isEmpty) {
          toastMessage('Please provide the denomination');
          return;
        }

        int min = int.parse(productDetail.price!.min ?? '1');
        int max = int.parse(productDetail.price!.max ?? '1');
        int den = int.parse(denomination);

        if (den < min || den > max) {
          toastMessage(
              'choose a denomination between ${productDetail.price!.min} and ${productDetail.price!.max}');
          return;
        }

        _createOrder(productDetail, den, image ?? '');
      } else {
        Get.to(
            () => WoohooVoucherBuyScreen(
                  offers: offers?.toDouble(),
                  image: image,
                  woohooProductDetail: productDetail,
                  productId: widget.productId,
                  redeemData: widget.redeemData,
              templates: templates?? [],
                templateBaseUrl:templateBaseUrl?? "",
                eventId: widget.eventId ?? "",

                ),
            transition: Transition.fade);
      }
    }
  }

  _createOrder(
      WoohooProductDetail productDetail, int denomination, String image) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());

      _invoiceResponse = await _sendFoodbloc.createFoodOrder(
          (_invoiceResponse == null ? '' : '${_invoiceResponse!.orderId}'),
          widget.redeemData.eventId!,
          widget.productId,
          widget.redeemData.participants!,
          denomination);

      if (_invoiceResponse != null) {
        showTaxBottomSheet(context, _invoiceResponse!, (String state) {
          Get.back();
          RedeemData redeemData = widget.redeemData;
          redeemData.updateSendFood(
              widget.productId, denomination, productDetail, image);

          PaymentData paymentData = PaymentData.food(
              account: widget.redeemData.account!,
              amount: '${_invoiceResponse!.amount ?? 0}',
              purpose: 'Food voucher',
              userId: User.userId,
              eventId: widget.redeemData.eventId!,
              state: state);
              startPayment(amountGiven: '${_invoiceResponse!.amount ?? 0}',);
          // Get.to(() => PaymentV2Screen(
          //       paymentData: paymentData,
          //       redeemData: redeemData,
          //     ));
        });
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage('Something went wrong. Please try again');
    }
  }
  startPayment({String? amountGiven}) async {
  
     print("food event Id = ${widget.eventId}");
    String key = await getGatewayKey();
    if (key.isEmpty) {
      toastMessage('Unable to get payment key');
    } else {
      paymentOrderDetails = await _getGatewayOrderId(amountGiven!);
      String orderId = paymentOrderDetails?.orderId ?? "";

      if (orderId.isEmpty) {
        toastMessage('Unable to get order');
      } else {
        try {
          _razorPay = Razorpay();
          _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
              (PaymentSuccessResponse paymentSuccessResponse) {
            //toastMessage('Payment successful');
            // Get.close(3);
            // Get.back();
            //_showSuccessDialog();
           
            Get.offAll(() => SendFoodCreateOrderScreen(
                    redeemData: widget.redeemData,
                    rzpPaymentId:
                        paymentSuccessResponse.paymentId ?? "",
                        eventId: widget.eventId,
                  ));

            Future.delayed(Duration(milliseconds: 100), () async {});
          });
          _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
              (PaymentFailureResponse paymentFailureResponse) {
            _onPaymentErrorFn(paymentFailureResponse);
          });

          _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});

          var options = {
            'key': key,
            "amount": paymentOrderDetails?.convertedAmount,
            'order_id': paymentOrderDetails?.orderId,
            'currency': "INR",
            'name': 'Prezenty',
            'description': 'Payment',
            'prefill': {
              'name': '${User.userName}',
              'contact': '${User.userMobile}',
              'email': '${User.userEmail}'
            },
            'notes': {
              "type": "FOOD",
               "user_id": User.userId,
               //"participant_list":widget.redeemData.participants,
              // "ins_table_id": insTableIdPassed,
              // // 'order_id': paymentOrderDetails?.orderId,
              // //"gift_amount":amountEntered,
              // "gift_amount": amountGiven,
              // 'state_code': permanentAddress ? permanentStateCode :stateCode ,
              // 'address': permanentAddress ? permanentAddressValue : addressControl.text,
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

  Future<String> getGatewayKey() async {
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
      String amountEntered) async {
    try {
      AppDialogs.loading();
      final response = await ApiProviderPrepaidCards()
          .getJsonInstance()
          .get('${Apis.getOrderIdTouchPoint}?amount=$amountEntered');
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
    Get.back();
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
