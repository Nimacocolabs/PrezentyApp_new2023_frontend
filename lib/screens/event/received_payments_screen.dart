import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/models/event_gifts_received_model.dart';
import 'package:event_app/models/received_payments_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/event/image_editor_screen.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main_screen.dart';

class ReceivedPaymentsScreen extends StatefulWidget {
  final int eventId;
  final bool isFromNotification;

  const ReceivedPaymentsScreen({Key? key, required this.eventId, this.isFromNotification = false})
      : super(key: key);

  @override
  _ReceivedPaymentsScreenState createState() => _ReceivedPaymentsScreenState();
}

class _ReceivedPaymentsScreenState extends State<ReceivedPaymentsScreen> {
  EventBloc _bloc = EventBloc();

  @override
  void initState() {
    super.initState();
   // _bloc.getReceivedPayments(widget.eventId);
    _bloc.eventGiftsReceived(widget.eventId);
  }

  _onBackPressed() {
    if(widget. isFromNotification){
      if(User.apiToken.isEmpty){
        Get.offAll(()=>LoginScreen(isFromWoohoo: false,));
      }else{
        Get.offAll(()=>MainScreen());
      }
    }else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        _onBackPressed();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: secondaryColor,
                ),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Image.asset('assets/images/ic_coins.png',height: 12,),
                    Icon(Icons.star,color: Colors.yellow,),
                    Text(' 1 = ${rupeeSymbol}1',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _bloc.eventGiftsReceivedStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      return CommonApiLoader();
                    case Status.COMPLETED:
                      EventGiftsReceivedModel resp = snapshot.data!.data;
                      return _buildList(resp);
                    case Status.ERROR:
                      return CommonApiErrorWidget(snapshot.data!.message!, () {
                        _bloc.eventGiftsReceived(widget.eventId);
                      });
                  }
                }
                return SizedBox();
              }),
        ),
      ),
    );
  }

  Widget _buildList(EventGiftsReceivedModel response) {
    if ((response.data ?? []).isEmpty) {
      return CommonApiResultsEmptyWidget('No Result');
    }

    double totalAmt = 0;
    response.data!.forEach((element) {
      totalAmt+=double.parse(element.amount!);
    });

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 2),
        itemCount: response.data!.length,
              itemBuilder: (context,index){
                EventGiftsReceivedData item = response.data![index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${item.email}',
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/ic_person_avatar.png'),
                            ),
                          ),),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('${item.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 6,
                              ),
                              Text('${item.phone}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(DateHelper.formatDateTime(DateHelper.getDateTime(item.createdAt!), 'dd-MMM-yyyy  hh:mm a'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle()),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                 // Image.asset('assets/images/ic_coins.png',height: 12,),
                                 Icon(Icons.star,color: Colors.yellow,),
                                  Text(' ${item.amount}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        Divider(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 30),
          child: Row(
            children: [
              Expanded(child: Text('Total Received '),),
              SizedBox(
                width: 12,
              ),
              //Image.asset('assets/images/ic_coins.png',height: 12,),
              Icon(Icons.star,color: Colors.yellow,),
              Text(' $totalAmt',
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        //   child: Row(
        //     children: [
        //       Expanded(child: Text('Available Balance:')),
        //       SizedBox(
        //         width: 12,
        //       ),
        //       Image.asset('assets/images/ic_coins.png',height: 12,),
        //       Text(' ${response.amount??'---'}',
        //           maxLines: 1,
        //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12)),
        //     ),
        //     onPressed: () {
        //       // Get.to(()=>WoohooVoucherListScreen(
        //       //     redeemData: RedeemData.giftRedeem(widget.eventId, response.amount??0
        //       //     ),showBackButton:true));
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(16),
        //       child: Text('Redeem Now'),
        //     ),
        //   ),
        // ),
      ],
    );
  }

}
