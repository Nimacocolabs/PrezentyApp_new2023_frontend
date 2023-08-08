import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/send_food_participant_list_response.dart';
import 'package:event_app/models/woohoo/woohoo_create_order_response.dart';
import 'package:event_app/models/woohoo/woohoo_product_detail_response.dart';
import 'package:event_app/screens/event/my_event_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendFoodCreateOrderScreen extends StatefulWidget {
  final RedeemData redeemData;
  final String rzpPaymentId;
  final String? eventId;
  const SendFoodCreateOrderScreen(
      {Key? key,
      required this.redeemData,
      required this.rzpPaymentId,
      this.eventId})
      : super(key: key);

  @override
  _SendFoodCreateOrderScreenState createState() =>
      _SendFoodCreateOrderScreenState();
}

class _SendFoodCreateOrderScreenState extends State<SendFoodCreateOrderScreen> {
  WoohooProductBloc _bloc = WoohooProductBloc();
  List<Participant> _participants = [];
  List<int> _completed = [];
  List<int> _failed = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _participants = widget.redeemData.participants ?? [];
    print('eventId = ${widget.eventId}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _createOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _finish();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sending food vouchers',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                'Do not press back or exit the app',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Divider(
                height: 1,
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: SizedBox(
                      width: 100,
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: widget.redeemData.image ?? '',
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/no_image.png'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${widget.redeemData.productDetail!.name}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('$rupeeSymbol ${widget.redeemData.denomination}'),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                    child: Text(
                        '${(_currentIndex + 1) > _participants.length ? _participants.length : (_currentIndex + 1)}/${_participants.length}',
                        textAlign: TextAlign.right),
                  ),
                ],
              ),
              Divider(
                height: 1,
              ),
              Expanded(
                  child: ListView.separated(
                      itemCount: _participants.length,
                      separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),
                      itemBuilder: (context, index) {
                        Participant participant = _participants[index];

                        return ListTile(
                          title: Text(
                              '${participant.name} (${participant.count})'),
                          subtitle: Text('${participant.email}'),
                          selected: _currentIndex == index,
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${participant.email}',
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/images/ic_person_avatar.png'),
                                  ),
                                ),
                              )),
                          trailing: SizedBox(
                              height: 20,
                              width: 20,
                              child: _completed.contains(index)
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                    )
                                  : _failed.contains(index)
                                      ? Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.deepOrange,
                                        )
                                      : _currentIndex == index
                                          ? CircularProgressIndicator(
                                              strokeWidth: 2,
                                            )
                                          : SizedBox()),
                        );
                      })),
              if (_completed.length + _failed.length == _participants.length)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // if(_failed.length>0)
                    //   Padding(
                    //   padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    //   child: Text('${_failed.length} of your vouchers are not successful, contact us for more details',style: TextStyle(color: Colors.black54),),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                          onPressed: _finish,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Finish'),
                          )),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  _finish() {
    if (_completed.length + _failed.length == _participants.length) {
      Get.offAll(() => MainScreen());
      Get.to(() => MyEventScreen(eventId: widget.redeemData.eventId!));
    } else {
      toastMessage('Please wait while creating order');
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       content: Text('Are you sure want to cancel the process?'),
      //       actions: [
      //         OutlinedButton(
      //           child: Text('No'),
      //           onPressed: () {
      //             Get.back();
      //           },
      //         ),
      //         SizedBox(width: 8,),
      //         ElevatedButton(
      //           child: Text('Yes'),
      //           onPressed: () {
      //             Get.offAll(() => MainScreen());
      //             Get.to(() => MyEventScreen(eventId: widget.eventId));
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  _createOrder() async {
    try {
      dynamic response = await _bloc.createOrder(
          userId: User.userId,
          eventId: widget.eventId,
          woohooProductId: widget.redeemData.productId!,
          orderType: "FOOD",
          orderBody: getBody(_currentIndex),
          showLoading: false,
          rzpPaymentId: widget.rzpPaymentId);

      if (response == null) {
        _createNextOrder(false, 'ERROR');
        return;
      }

      if (response is WoohooCreateOrderResponse) {
        if (response.data!.status == 'COMPLETE') {
          _createNextOrder(true, response.data!.status!);
        } else {
          _createNextOrder(false, response.data!.status ?? 'FAILED');
        }
      } else {
        _createNextOrder(false, 'FAILED');
      }
    } catch (e, s) {
      _createNextOrder(false, 'TIMEOUT');
      Completer().completeError(e, s);
    }
  }

  _createNextOrder(bool isSuccess, String currentOrderStatus) {
    if (mounted) {
      if (isSuccess) {
        _completed.add(_currentIndex);
      } else {
        _failed.add(_currentIndex);
      }
      if (_currentIndex < _participants.length - 1) {
        _participants[_currentIndex].createOrderStatus = currentOrderStatus;
        _currentIndex++;
        setState(() {});
        _createOrder();
      } else {
        _currentIndex++;
        setState(() {});
        _bloc.sendInvoice('FOOD', '${widget.rzpPaymentId}');
      }
    }
  }

  Map<String, dynamic> getBody(int index) {
    String referenceNo = 'prezenty_${DateTime.now().millisecondsSinceEpoch}';

    Participant participant = _participants[index];
    int price = widget.redeemData.denomination!;
    int qty = participant.count;

    print(participant.name!);
    Map<String, dynamic> body = {
      "address": {
        "country": "IN",
        "firstname": participant.name!.split('  ')[0],
        "lastname": participant.name!.split('  ')[1],
        "email": "${participant.email}",
        "telephone": "+91${participant.phone}",
        "billToThis": true
      },
      "billing": {
        "email": "${participant.email}",
        "telephone": "+91${participant.phone}",
        "country": "IN",
        "firstname": participant.name!.split('  ')[0],
        "lastname": participant.name!.split('  ')[1],
      },
      "payments": [
        {"code": "svc", "amount": (price * qty)}
      ],
      "refno": referenceNo,
      "products": [
        {
          "sku": widget.redeemData.productDetail!.sku,
          "price": price,
          "qty": qty,
          "currency": 356,
          "giftMessage": 'Food Voucher',
        }
      ],
      "syncOnly": true,
      "deliveryMode": "API"
    };

    print(jsonEncode(body));
    return body;
  }
}
