// import 'dart:async';
// import 'dart:convert';
// import 'package:event_app/network/apis.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../models/gateway_key_response.dart';
// import '../models/order_response.dart';
// import '../network/api_provider.dart';
// import '../util/app_helper.dart';
// import '../util/user.dart';
// import '../widgets/CommonApiLoader.dart';
// import 'EventDeeplink/event_invite_details_screen.dart';
// import 'event/my_event_screen.dart';
// import 'main_screen.dart';
//
// class PaymentScreen extends StatefulWidget {
//   final PaymentInfo paymentInfo;
//
//   const PaymentScreen({Key? key, required this.paymentInfo}) : super(key: key);
//
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   late PaymentInfo paymentInfo;
//
//   late Razorpay _razorPay;
//   PaymentSuccessResponse? _paymentSuccessResponse;
//   PaymentFailureResponse? _paymentFailureResponse;
//
//   ApiProvider apiProvider = ApiProvider();
//
//   GatewayKeyResponse? _gatewayKeyResponse;
//   OrderResponse? _orderResponse;
//
//   String amountInPaise = '0';
//   Map<String, dynamic> notes = {};
//
//   @override
//   void initState() {
//     super.initState();
//
//     paymentInfo = widget.paymentInfo;
//     _razorPay = Razorpay();
//
//     WidgetsBinding.instance!.addPostFrameCallback((_) async {
//       _initPayment();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CommonApiLoader(),
//       ),
//     );
//   }
//
//   Future _initPayment() async {
//     if (paymentInfo.paymentType != PaymentTypeOld.FoodVoucher &&
//         paymentInfo.paymentType != PaymentTypeOld.GiftOrVoucher &&
//         paymentInfo.paymentType != PaymentTypeOld.BuyWoohooVoucher) {
//       toastMessage('Invalid payment. Please try again');
//       Get.back();
//       return;
//     }
//
//     bool isSuccess = await getGatewayKey();
//
//     if (!isSuccess) {
//       toastMessage('Unable to get payment credentials. Please try again');
//       Get.back();
//       return;
//     }
//
//     isSuccess = await _getOrder();
//
//     if (!isSuccess) {
//       toastMessage('Unable to create order. Please try again');
//       Get.back();
//       return;
//     }
//
//     if (paymentInfo.paymentType == PaymentTypeOld.FoodVoucher) {
//       // isSuccess = await _getOrder();
//       // if (!isSuccess) {
//       //   toastMessage('Unable to create order. Please try again');
//       //   Get.back();
//       //   return;
//       // }
//
//       notes = {
//         'order_id': widget.paymentInfo.tableOrderId,
//         'email': widget.paymentInfo.email,
//         'phone': widget.paymentInfo.phone
//       };
//
//       // print(jsonEncode(notes));
//       // startPayment(onPaymentSuccess, onPaymentErrorFn);
//     } else if (paymentInfo.paymentType == PaymentTypeOld.GiftOrVoucher) {
//       // isSuccess = await _getOrder();
//       // if (!isSuccess) {
//       //   toastMessage('Unable to create order. Please try again');
//       //   Get.back();
//       //   return;
//       // }
//
//       notes = {
//         'eid': '${paymentInfo.eventId}',
//         'gid': '${paymentInfo.giftId}',
//         'pid': '${paymentInfo.eventParticipantId}'
//       };
//
//       // print(jsonEncode(notes));
//       // startPayment(onPaymentSuccess, onPaymentErrorFn);
//     } else if (paymentInfo.paymentType == PaymentTypeOld.BuyWoohooVoucher) {
//       // isSuccess = await _getOrder();
//       // if (!isSuccess) {
//       //   toastMessage('Unable to create order. Please try again');
//       //   Get.back();
//       //   return;
//       // }
//
//       notes = {
//         'orderId': '${_orderResponse!.razorPayOrderId}',
//         'productOrderId': '${_orderResponse!.tableOrderId}'
//       };
//
//       // print(jsonEncode(notes));
//       // startPayment(onPaymentSuccess, onPaymentErrorFn);
//     } else {
//       toastMessage('Unknown Payment type');
//       Get.back();
//       return;
//     }
//
//     print(jsonEncode(notes));
//     startPayment(onPaymentSuccess, onPaymentErrorFn);
//   }
//
//   Future<bool> getGatewayKey() async {
//     final response =
//         await apiProvider.getJsonInstance().get(Apis.getPaymentGatewayKey);
//     _gatewayKeyResponse = GatewayKeyResponse.fromJson(response.data);
//
//     return _gatewayKeyResponse!.success ?? false;
//   }
//
//   Future<bool> _getOrder() async {
//     String path;
//     if (paymentInfo.paymentType == PaymentTypeOld.FoodVoucher) {
//       path = '${Apis.getPaymentOrder}?amount=${paymentInfo.amount}&event_id=${paymentInfo.eventId}';
//
//       final response = await apiProvider.getJsonInstance().get(path);
//       _orderResponse = OrderResponse.fromJson(response.data);
//       paymentInfo.eventParticipantId = _orderResponse!.eventParticipantId ?? 0;
//
//       return (_orderResponse!.success ?? false);
//     } else if (paymentInfo.paymentType == PaymentTypeOld.GiftOrVoucher) {
//       path =
//           '${Apis.getPaymentOrder}?amount=${paymentInfo.amount}&event_id=${paymentInfo.eventId}&gift_id=${paymentInfo.giftId}&participant_email=${paymentInfo.participantEmail}';
//
//       final response = await apiProvider.getJsonInstance().get(path);
//       _orderResponse = OrderResponse.fromJson(response.data);
//       paymentInfo.eventParticipantId = _orderResponse!.eventParticipantId ?? 0;
//
//       return (_orderResponse!.success ?? false) &&
//           (_orderResponse!.eventParticipantId ?? 0) != 0;
//     } else if (paymentInfo.paymentType == PaymentTypeOld.BuyWoohooVoucher) {
//       path =
//           '${Apis.getPaymentOrderWoohoo}?product_id=${paymentInfo.voucherId}&amount=${paymentInfo.amount}&mobile=${paymentInfo.phone}&email=${paymentInfo.email}&vchr_user_name=${paymentInfo.name}&userId=${paymentInfo.userId}';
//
//       final response = await apiProvider.getJsonInstance().get(path);
//       _orderResponse = OrderResponse.fromJson(response.data);
//       // paymentInfo.tableOrderId = '${_orderResponse!.tableOrderId}';
//
//       return (_orderResponse!.success ?? false);
//     } else {
//       return false;
//     }
//
//     // if (paymentInfo.paymentType == PaymentTypeOld.FoodOrGift) {
//     //   path =
//     //       '${Apis.getPaymentOrder}?amount=${paymentInfo.amount}&event_id=${paymentInfo.eventId}';
//     // } else {
//     //   path =
//     //       '${Apis.getPaymentOrder}?amount=${paymentInfo.amount}&event_id=${paymentInfo.eventId}&gift_id=${paymentInfo.giftId}&participant_email=${paymentInfo.participantEmail}';
//     // }
//     // final response = await apiProvider.getJsonInstance().get(path);
//     // _orderResponse = OrderResponse.fromJson(response.data);
//     // paymentInfo.eventParticipantId = _orderResponse!.eventParticipantId ?? 0;
//     //
//     // return (_orderResponse!.success ?? false) &&
//     //     (_orderResponse!.eventParticipantId ?? 0) != 0;
//   }
//
//   onPaymentSuccess(PaymentSuccessResponse response) {
//     if (paymentInfo.paymentType == PaymentTypeOld.FoodVoucher) {
//       Get.offAll(() => MainScreen());
//       Get.to(() => MyEventScreen(
//             eventId: paymentInfo.eventId!,
//           ));
//     } else if (paymentInfo.paymentType == PaymentTypeOld.GiftOrVoucher) {
//       Get.offAll(() => EventInviteDetailsScreen(eventId: paymentInfo.eventId!,
//           ));
//     } else if (paymentInfo.paymentType == PaymentTypeOld.BuyWoohooVoucher) {
//       Get.offAll(() => MainScreen());
//
//       _showSuccessDialog(
//           msg:
//               'Payment completed successfully.\nAnd we are processing your voucher request.\n\nYou will be notified once the voucher is active.');
//       return;
//     }
//     _showSuccessDialog();
//   }
//
//   onPaymentErrorFn(PaymentFailureResponse response) {
//     String msg = '';
//     if (response.code == Razorpay.PAYMENT_CANCELLED) {
//       msg = 'Payment Has Been Cancelled';
//     } else if (response.code == Razorpay.NETWORK_ERROR) {
//       msg = 'Network Issues while payment request';
//     } else {
//       msg = 'Payment Error, Try after some time';
//     }
//     Get.back();
//
//     Get.dialog(
//       Center(
//         child: Material(
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(22),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.cancel_rounded,
//                   color: Colors.red.shade300,
//                   size: 70,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   '$msg',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   onExternalWalletResponse(ExternalWalletResponse response) {
//     print('_onExternalWallet:${response.walletName}');
//   }
//
//   // bool startPaymentDummy(Function onPaymentSuccess, Function onPaymentErrorFn) {
//   //   try {
//   //     _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
//   //         (PaymentSuccessResponse paymentSuccessResponse) {
//   //       _paymentSuccessResponse = paymentSuccessResponse;
//   //       onPaymentSuccess(_paymentSuccessResponse);
//   //     });
//   //     _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
//   //         (PaymentFailureResponse paymentFailureResponse) {
//   //       _paymentFailureResponse = paymentFailureResponse;
//   //       onPaymentErrorFn(_paymentFailureResponse);
//   //     });
//   //
//   //     _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWalletResponse);
//   //
//   //     var options = {
//   //       'key': '${_gatewayKeyResponse!.apiKey}',
//   //       // "order_id": "${_orderResponse!.orderId}",
//   //       'amount': paymentInfo.amount*100,
//   //       'currency': "INR",
//   //       'name': 'Prezenty',
//   //       'description': 'Payment',
//   //       'prefill': {
//   //         'name': '${User.userName}',
//   //         // 'contact': '${User.mobile ?? ''}',
//   //         'email': '${paymentInfo.participantEmail}'
//   //       },
//   //       'notes': notes
//   //     };
//   //
//   //     debugPrint(jsonEncode(options));
//   //
//   //     _razorPay.open(options);
//   //     return true;
//   //   } catch (e, s) {
//   //     Completer().completeError(e, s);
//   //     toastMessage( 'Unable to start payment. Please try again');
//   //     Get.back();
//   //     return false;
//   //   }
//   // }
//
//   bool startPayment(Function onPaymentSuccess, Function onPaymentErrorFn) {
//     try {
//       _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
//           (PaymentSuccessResponse paymentSuccessResponse) {
//         _paymentSuccessResponse = paymentSuccessResponse;
//         onPaymentSuccess(_paymentSuccessResponse);
//       });
//       _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
//           (PaymentFailureResponse paymentFailureResponse) {
//         _paymentFailureResponse = paymentFailureResponse;
//         onPaymentErrorFn(_paymentFailureResponse);
//       });
//
//       _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWalletResponse);
//
//       var options = {
//         'key': '${_gatewayKeyResponse!.apiKey}',
//         "order_id": "${_orderResponse!.razorPayOrderId}",
//         'amount': _orderResponse!.convertedAmount,
//         'currency': "INR",
//         'name': 'Prezenty',
//         'description': 'Payment',
//         'prefill': {
//           'name': '${User.userName}',
//           'contact': '${User.userMobile}',
//           'email': '${(paymentInfo.participantEmail ?? User.userEmail)}'
//         },
//         'notes': notes
//       };
//
//       debugPrint(jsonEncode(options));
//
//       _razorPay.open(options);
//       return true;
//     } catch (e, s) {
//       Completer().completeError(e, s);
//       toastMessage('Unable to start payment. Please try again');
//       Get.back();
//       return false;
//     }
//   }
//
//   _showSuccessDialog({String msg = 'Payment completed successfully'}) {
//     Get.dialog(
//       Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Material(
//             borderRadius: BorderRadius.circular(12),
//             child: Padding(
//               padding: const EdgeInsets.all(22),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.check_circle_rounded,
//                     color: Colors.green.shade300,
//                     size: 70,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     msg,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _razorPay.clear();
//     super.dispose();
//   }
// }
//
// class PaymentInfo {
//   late PaymentTypeOld paymentType;
//   var amount;
//   int? eventId;
//   int? giftId;
//   int? eventParticipantId;
//   String? participantEmail;
//
//   String? participantIds;
//   int? menuGiftId;
//   int? giftCount;
//   int? menuVegId;
//   int? vegCount;
//   int? menuNonVegId;
//   int? nonVegCount;
//
//   String? email;
//   String? phone;
//   String? tableOrderId;
//
//   String? name;
//   String? userId;
//   String? voucherId;
//
//   PaymentInfo.giftVoucher(
//       {required this.amount,
//       required this.eventId,
//       required this.giftId,
//       required this.participantEmail,
//       this.eventParticipantId = 0}) {
//     this.paymentType = PaymentTypeOld.GiftOrVoucher;
//   }
//
//   PaymentInfo.sendFood(
//       {required this.amount,
//       required this.eventId,
//       required this.phone,
//       required this.email,
//       required this.tableOrderId}) {
//     this.paymentType = PaymentTypeOld.FoodVoucher;
//   }
//
//   PaymentInfo.buyWoohooVoucher(
//       {required this.amount,
//       required this.voucherId,
//       required this.userId,
//       required this.name,
//       required this.phone,
//       required this.email}) {
//     this.paymentType = PaymentTypeOld.BuyWoohooVoucher;
//   }
// }
//
// enum PaymentTypeOld { GiftOrVoucher, FoodVoucher, BuyWoohooVoucher }
