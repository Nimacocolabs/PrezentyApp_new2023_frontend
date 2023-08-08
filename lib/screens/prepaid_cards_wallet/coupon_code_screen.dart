
import 'package:event_app/models/wallet&prepaid_cards/coupon_listing_model.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/app_helper.dart';
import '../../bloc/wallet_bloc.dart';

import '../../network/api_response.dart';
import '../../widgets/CommonApiLoader.dart';
import '../../widgets/CommonApiResultsEmptyWidget.dart';

class CouponCodeScreen extends StatefulWidget {
    CouponCodeScreen({ Key? key, required this.cardId }) : super(key: key);

  final int cardId;

  @override
  State<CouponCodeScreen> createState() => _CouponCodeScreenState();
}

class _CouponCodeScreenState extends State<CouponCodeScreen> {
  WalletBloc _walletBloc = WalletBloc();

  @override
  void initState() {
    super.initState();
    _walletBloc.getCouponListing(widget.cardId.toString());
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
          stream: _walletBloc.CouponListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  return SizedBox(
                      width: screenWidth,
                      height: screenHeight - 320,
                      child: CommonApiLoader());
                case Status.COMPLETED:
                  CouponListingModel resp = snapshot.data!.data;
                  return _buildList(resp.data ?? []);
                case Status.ERROR:
                  return SizedBox(
                    width: screenWidth,
                    height: screenHeight - 320,
                    child: Center(
                      child: CommonApiResultsEmptyWidget(
                          "${snapshot.data!.message!}",
                          textColorReceived: Colors.black),
                    ),
                  );
              }
            }
            return SizedBox(
                width: screenWidth,
                height: screenHeight - 320,
                child: CommonApiLoader());
          },
        ) ),
      );
  }

  Widget _buildList(List<CouponListingResponse> list) {
    if(list.isEmpty){
      return CommonApiResultsEmptyWidget('No coupons available now');
    }
    return ListView.separated(itemBuilder: (context,index){
      return _item(list[index]);
    }, separatorBuilder: (_,__)=>Divider(height:1), itemCount: list.length);
  }

  Widget _item(CouponListingResponse coupon){
   return Padding(
     padding: const EdgeInsets.all(12.0),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
           children: [
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal:12,vertical:8),
                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(8),
                        color: primaryColor.shade50),
                    child:
                    Text('${coupon.couponCode}', style: TextStyle(fontSize: 18,color:secondaryColor,fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Text('Save $rupeeSymbol${coupon.couponvalue}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500,)),
              SizedBox(height: 8,),
              Text('Expires on ${coupon.expiresOn}',style: TextStyle(fontSize: 16,)),
            ],
  ),
         ),

         ElevatedButton(
           style: ElevatedButton.styleFrom(primary: secondaryColor,visualDensity: VisualDensity.compact,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
           child: Padding(
             padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
             child: Text('Apply'),
           ),onPressed: (){
           Get.back(result:coupon.couponCode);
         },
         ),
       ],
     ),
   );
  }


}