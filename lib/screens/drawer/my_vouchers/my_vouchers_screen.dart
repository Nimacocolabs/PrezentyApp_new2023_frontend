import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/models/my_voucher_response.dart';
import 'package:event_app/models/redeemed_voucher_list_response.dart';
import 'package:event_app/screens/drawer/my_vouchers/RedeemedVoucherDetailScreen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_app/bloc/voucher_report_bloc.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';

import 'my_voucher_detail_screen.dart';

class MyVouchersScreen extends StatefulWidget {
  final bool? showAppBar;
  const MyVouchersScreen({this.showAppBar});

  @override
  _MyVouchersScreenState createState() => _MyVouchersScreenState();
}

class _MyVouchersScreenState extends State<MyVouchersScreen> {
  VoucherReportBloc _bloc = VoucherReportBloc();
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _getDetails();
    _getRedeemedDetails();
  }

  Future _getRedeemedDetails() async {
    _bloc.getRedeemedVoucherList(User.userId);
  }

  Future _getDetails() async {
    _bloc.getMyVoucherOrders(User.userId, isSentVouchers: _tabIndex == 0);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       appBar:widget.showAppBar ?? false ?
       CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ) : null,
            // bottomNavigationBar: CommonBottomNavigationWidget(),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  color: primaryColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor.shade800,
                        borderRadius: BorderRadius.circular(50)),
                    margin: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (_tabIndex == 0) return;
                              setState(() {
                                _tabIndex = 0;
                              });
                              _getDetails();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _tabIndex == 0
                                      ? Colors.white
                                      : primaryColor.shade800,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Text('Sent')),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (_tabIndex == 1) return;
                              setState(() {
                                _tabIndex = 1;
                              });
                              _getDetails();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _tabIndex == 1
                                      ? Colors.white
                                      : primaryColor.shade800,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Text('Received')),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (_tabIndex == 2) return;
                              setState(() {
                                _tabIndex = 2;
                              });
                              _getRedeemedDetails();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _tabIndex == 2
                                      ? Colors.white
                                      : primaryColor.shade800,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Text('Redeemed')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              _tabIndex != 2
                  ? Expanded(
                      child: RefreshIndicator(
                      onRefresh: _getDetails,
                      child: StreamBuilder<ApiResponse<dynamic>>(
                          stream: _bloc.myVoucherOrderListStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data!.status!) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                case Status.COMPLETED:
                                  MyVoucherListResponse response =
                                      snapshot.data!.data;
                                  return _buildList(response.data!,
                                      response.basePathWoohooImages ?? '');
                                case Status.ERROR:
                                  return CommonApiErrorWidget(
                                      "${snapshot.data!.message!}",
                                      _getDetails);
                              }
                            }
                            return SizedBox();
                          }),
                    ))
                  : Container(),
              _tabIndex == 2
                  ? Expanded(
                      child: RefreshIndicator(
                      onRefresh: _getRedeemedDetails,
                      child: StreamBuilder<ApiResponse<dynamic>>(
                          stream: _bloc.redeemedVoucherListStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data!.status!) {
                                case Status.LOADING:
                                  return CommonApiLoader();
                                case Status.COMPLETED:
                                  RedeemedVoucherListResponse response =
                                      snapshot.data!.data;
                                  return _buildRedeemedVoucherList(
                                      response.data!,
                                      response.basePathWoohooImages ?? '');
                                case Status.ERROR:
                                  return CommonApiErrorWidget(
                                      "${snapshot.data!.message!}",
                                      _getRedeemedDetails);
                              }
                            }
                            return SizedBox();
                          }),
                    ))
                  : Container(),
            ],
          ),
        ));
  }

  Widget _buildRedeemedVoucherList(
      List<RedeemedVoucherData> list, String basePathWoohooImages) {
    if (list.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No vouchers'));
    } else {
      return ListView.builder(
        physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          itemCount: list.length,
          itemBuilder: (context, index) {

            RedeemedVoucherData voucher = list[index];

            String image = voucher.image != null
                ? '${basePathWoohooImages}${voucher.image}'
                : voucher.product!.image!;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(() => RedeemedVoucherDetailScreen(
                    voucher: voucher,
                    image: image,
                    order:  voucher.orders![0]
                  ));
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: image,
                            placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            errorWidget: (context, url, error) => SizedBox(
                                child:
                                    Image.asset('assets/images/no_image.png'))),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  voucher.payment!.invNoId ??
                                      'Order ${voucher.payment!.id}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                                SizedBox(
                                  width: 12,
                                ),
                                _status(voucher.payment!.status!),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  '$rupeeSymbol ${voucher.payment!.amount}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '${DateHelper.formatDateTime(DateHelper.getDateTime(voucher.payment!.createdAt!.toString().split('T').first), 'dd-MMM-yyyy')}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                                  'Event ID: ${voucher.orders![0].eventId}',
                                  style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                                ),
                                 SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('${voucher.product!.productName}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                           // //  if (voucher.orders.)
                           //  Padding(
                           //    padding: const EdgeInsets.only(top: 8.0),
                           //    child: Row(
                           //      children: [
                           //        Icon(
                           //          Icons.card_giftcard_rounded,
                           //          color: primaryColor,
                           //          size: 20,
                           //        ),
                           //        Text(
                           //          ' to ',
                           //          style: TextStyle(
                           //              fontWeight: FontWeight.w500,
                           //              color: primaryColor),
                           //        ),
                           //        // SizedBox(width: 4,),
                           //        Expanded(
                           //          child: Text(
                           //            '${voucher.orders![0].recipientName ?? ''}',
                           //            maxLines: 1,
                           //            overflow: TextOverflow.ellipsis,
                           //            softWrap: false,
                           //            style: TextStyle(
                           //                fontWeight: FontWeight.w500,
                           //                color: primaryColor),
                           //          ),
                           //        ),
                           //      ],
                           //    ),
                           //  ),
                           //  if (voucher.giftedBy != null)
                           //    Padding(
                           //      padding: const EdgeInsets.only(top: 8.0),
                           //      child: Row(
                           //        children: [
                           //          Icon(
                           //            Icons.card_giftcard_rounded,
                           //            color: primaryColor,
                           //            size: 20,
                           //          ),
                           //          Text(
                           //            ' by ',
                           //            style: TextStyle(
                           //                fontWeight: FontWeight.w500,
                           //                color: primaryColor),
                           //          ),
                           //          // SizedBox(width: 4,),
                           //          Expanded(
                           //            child: Text(
                           //              '${voucher.orders![0]!.giftedBy!.name}',
                           //              maxLines: 1,
                           //              overflow: TextOverflow.ellipsis,
                           //              softWrap: false,
                           //              style: TextStyle(
                           //                  fontWeight: FontWeight.w500,
                           //                  color: primaryColor),
                           //            ),
                           // //          ),
                           //        ],
                           //      ),
                           //    ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  Widget _buildList(List<MyVoucher> list, String basePathWoohooImages) {
    if (list.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No vouchers'));
    } else {
      return ListView.builder(
         physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          itemCount: list.length,
          itemBuilder: (context, index) {
            MyVoucher voucher = list[index];
            String image = voucher.image != null
                ? '${basePathWoohooImages}${voucher.image}'
                : voucher.product!.images!.mobile!;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(() => MyVoucherDetailScreen(
                        voucher: voucher,
                        image: image,
                      ));
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: image,
                            placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            errorWidget: (context, url, error) => SizedBox(
                                child:
                                    Image.asset('assets/images/no_image.png'))),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  voucher.invNo ?? 'Order ${voucher.id}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                                SizedBox(
                                  width: 12,
                                ),
                                _status(voucher.status!),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  '$rupeeSymbol ${voucher.amount}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '${DateHelper.formatDateTime(DateHelper.getDateTime(voucher.createdAt!), 'dd-MMM-yyyy')}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ), SizedBox(
                              height: 8,
                            ),
                            Text(
                                  'Event ID: ${voucher.eventId}',
                                  style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                                ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('${voucher.product!.name}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            if (voucher.isGifted == 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.card_giftcard_rounded,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    Text(
                                      ' to ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor),
                                    ),
                                    // SizedBox(width: 4,),
                                    Expanded(
                                      child: Text(
                                        '${voucher.recipientName}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (voucher.giftedBy != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.card_giftcard_rounded,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    Text(
                                      ' by ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor),
                                    ),
                                    // SizedBox(width: 4,),
                                    Expanded(
                                      child: Text(
                                        '${voucher.giftedBy!.name}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  _status(String status) {
    if (status == 'COMPLETE' || status == 'SUCCESS') {
      return Icon(
        Icons.check_circle_rounded,
        color: Colors.green.shade300,
      );
    } else if (status == 'FAILED') {
      return Icon(
        Icons.cancel_rounded,
        color: Colors.red.shade300,
      );
    } else {
      return Text(
        status,
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    }
  }
}

// class RedeemedVouchers extends StatefulWidget {
//   const RedeemedVouchers({Key? key}) : super(key: key);

//   @override
//   State<RedeemedVouchers> createState() => _RedeemedVouchersState();
// }

// class _RedeemedVouchersState extends State<RedeemedVouchers> {

//   VoucherReportBloc _bloc = VoucherReportBloc();

//   @override
//   void initState() {
//     super.initState();

//     _getRedeemedDetails();
//   }

//   Future _getRedeemedDetails() async {
//     _bloc.getRedeemedVoucherList(User.userId);
//   }

//   @override
//   void dispose() {
//     _bloc.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: RefreshIndicator(
//           onRefresh: _getRedeemedDetails,
//           child: StreamBuilder<ApiResponse<dynamic>>(
//               stream: _bloc.redeemedVoucherListStream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   switch (snapshot.data!.status!) {
//                     case Status.LOADING:
//                       return CommonApiLoader();
//                     case Status.COMPLETED:
//                       MyVoucherListResponse response = snapshot.data!.data;
//                       return _buildList(response.data!,response.basePathWoohooImages??'');
//                     case Status.ERROR:
//                       return CommonApiErrorWidget(
//                           "${snapshot.data!.message!}", _getRedeemedDetails());
//                   }
//                 }
//                 return SizedBox();
//               }),
//         )
//     );
//   }

//   Widget _buildList(List<MyVoucher> list,String basePathWoohooImages) {
//     if (list.isEmpty) {
//       return Center(
//           child: CommonApiResultsEmptyWidget('No vouchers')
//       );
//     } else {
//       return ListView.builder(
//           padding: EdgeInsets.all(8),
//           itemCount: list.length,
//           itemBuilder: (context,index){
//             MyVoucher voucher = list[index];
//             String image =voucher.image !=null
//                 ? '${basePathWoohooImages}${voucher.image}'
//                 : voucher.product!.images!.mobile!;

//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 4),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: (){
//                   Get.to(() => MyVoucherDetailScreen(voucher: voucher,image: image,));
//                 },
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 80,
//                       width: 100,
//                       child:
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.fill,
//                             imageUrl: image ,
//                             placeholder: (context, url) => Center(
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                               ),
//                             ),
//                             errorWidget: (context, url, error) => SizedBox(
//                                 child:
//                                 Image.asset('assets/images/no_image.png'))),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(child: Text(voucher.invNo??'Order ${voucher.id}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)),
//                                 SizedBox(width: 12,),
//                                 _status(voucher.status!),
//                               ],
//                             ),

//                             SizedBox(
//                               height: 6,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                     child: Text(
//                                       '$rupeeSymbol ${voucher.amount}',
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     )),

//                                 SizedBox(
//                                   height: 12,
//                                 ),

//                                 Text(
//                                   '${DateHelper.formatDateTime(DateHelper.getDateTime(voucher.createdAt!), 'dd-MMM-yyyy')}',
//                                   style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
//                               ],
//                             ),
//                             SizedBox(height: 8,),
//                             Row(
//                               children: [
//                                 Expanded(child: Text('${voucher.product!.name}',maxLines: 2,overflow: TextOverflow.ellipsis),),
//                               ],
//                             ),

//                             if(voucher.isGifted==1)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.card_giftcard_rounded,color: primaryColor,size: 20,),
//                                     Text(' to ',style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor),),
//                                     // SizedBox(width: 4,),
//                                     Expanded(
//                                       child: Text('${voucher.recipientName}',maxLines: 1,overflow: TextOverflow.ellipsis,
//                                         softWrap: false,style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor),),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                             if(voucher.giftedBy!=null)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.card_giftcard_rounded,color: primaryColor,size: 20,),
//                                     Text(' by ',style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor),),
//                                     // SizedBox(width: 4,),
//                                     Expanded(
//                                       child: Text('${voucher.giftedBy!.name}',maxLines: 1,overflow: TextOverflow.ellipsis,
//                                         softWrap: false,style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor),),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           });
//     }
//   }
//   _status(String status) {
//     if(status == 'COMPLETE'||status == 'SUCCESS'){
//       return Icon(Icons.check_circle_rounded,color: Colors.green.shade300,);
//     }else if(status == 'FAILED'){
//       return Icon(Icons.cancel_rounded,color: Colors.red.shade300,);
//     }else{
//       return Text(
//         status,
//         style: TextStyle(
//             fontWeight: FontWeight.w500),
//       );
//     }
//   }

// }
