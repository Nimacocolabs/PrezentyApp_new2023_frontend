import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/models/send_food_order_list_response.dart';
import 'package:event_app/screens/woohoo/card_balance_screen.dart';
import 'package:event_app/screens/woohoo/transaction_history_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportOrderDetailScreen extends StatefulWidget {
  final ReportOrder order;
  final bool isFromRedeem;
  final String image;

  const ReportOrderDetailScreen({Key? key, required this.order, required this.isFromRedeem, required this.image})
      : super(key: key);

  @override
  _ReportOrderDetailScreenState createState() =>
      _ReportOrderDetailScreenState();
}

class _ReportOrderDetailScreenState extends State<ReportOrderDetailScreen> {
  List<Orders> recipientList = [];

  @override
  void initState() {
    super.initState();

    (widget.order.orders ?? []).forEach((element) {
      if (!recipientList
          .any((r) => element.recipientEmail == r.recipientEmail)) {
        recipientList.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                    widget.order.payment!.invNo??'Order ${widget.order.payment!.id!}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                width: 12,
              ),
              _status(widget.order.payment!.status??''),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                    '$rupeeSymbol ${widget.order.payment!.amount}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                width: 12,
              ),
              Text(
                '${DateHelper.formatDateTime(DateHelper.getDateTime(widget.order.payment!.createdAt!), 'dd-MMM-yyyy  hh:mm a')}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * .3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: widget.image ,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/no_image.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.order.product!.productName!,
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                ),
              ],
            ),
          ),
          Text(
            'Recipients (${recipientList.length})',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8,
          ),
          ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: ClampingScrollPhysics(),
              itemCount: recipientList.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                Orders recipient = recipientList[index];

                List<Orders> voucherList = [];

                widget.order.orders!.forEach((element) {
                  if (element.recipientEmail == recipient.recipientEmail) {
                    voucherList.add(element);
                  }
                });

                return Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${recipient.recipientEmail}',
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                Image.asset('assets/images/ic_person_avatar.png'),
                                          ),
                                        ),)),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: primaryColor),
                                    child: Text(
                                      '${voucherList.length}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  '${recipient.recipientName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '${recipient.recipientEmail}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '${recipient.recipientMobile}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: ClampingScrollPhysics(),
                            itemCount: voucherList.length,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              Orders order = voucherList[index];

                              return Card(
                                margin: EdgeInsets.only(bottom: 8, left: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    'Card No',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54),
                                                  ),
                                                  SizedBox(height: 4),

                                                  widget.isFromRedeem?
                                                  Text('${(order.cardNo ?? '')}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),):
                                                  Text( '${(order.cardNo ?? '').replaceAllMapped(RegExp(r'.(?=.{4})'), (match) => '*')}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Card Pin',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54),
                                                  ),
                                                  SizedBox(height: 4),
                                                  widget.isFromRedeem?
                                                  Text(
                                                    '${(order.cardPin ?? '')}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ):
                                                  Text(
                                                    '${(order.cardPin ?? '').replaceAllMapped(RegExp(r'.(?=.{0})'), (match) => '*')}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              '$rupeeSymbol ${order.amount}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Divider(
                                        height: 16,
                                        color: Colors.black12,
                                      ),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  'Issuance Date',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '${DateHelper.formatDateTime(DateHelper.getDateTime(order.issueDate!), 'dd-MMM-yyyy')}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  'Expiry Date',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '${DateHelper.formatDateTime(DateHelper.getDateTime(order.validity!), 'dd-MMM-yyyy')}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      if(widget.isFromRedeem && order.activationUrl!=null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Column(
                                          children: [
                                            Divider(color: Colors.black12,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Text('Activation Code',style: TextStyle(fontSize: 14,color: Colors.black54),),
                                                      SizedBox(height: 4),
                                                      SelectableText('${order.activationCode}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,),),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                                    ),
                                                    onPressed: ()async{
                                                      String url = '${order.activationUrl}';
                                                      if(await canLaunch(url)){
                                                        launch(url);
                                                      }else{
                                                        toastMessage('Unable to open $url');
                                                      }
                                                    }, child: Text('Activate')),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),


                                      if(widget.isFromRedeem)
                                      Column(
                                        children: [
                                          Divider(
                                            height: 12,
                                            color: Colors.black12,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: (){
                                                    Get.to(()=>CardBalanceScreen(cardNo: '${order.cardNo}', cardPin: '${order.cardPin}'));
                                                  },
                                                  child: Text('Check balance',),
                                                ),
                                              ),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: (){
                                                    Get.to(()=>TransactionHistoryScreen(cardNo: '${order.cardNo}', cardPin: '${order.cardPin}'));
                                                  },
                                                  child: Text('Transactions',),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ));
              }),
        ],
      ),
    );
  }

  _status(String status) {
    if(status == 'COMPLETE'||status == 'SUCCESS'){
      return Icon(Icons.check_circle_rounded,color: Colors.green.shade300,);
    }else if(status == 'FAILED'){
      return Icon(Icons.cancel_rounded,color: Colors.red.shade300,);
    }else{
      return Text(
        status,
        style: TextStyle(
            fontWeight: FontWeight.w500),
      );
    }
  }
}
