import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/models/my_voucher_response.dart';
import 'package:event_app/screens/woohoo/card_balance_screen.dart';
import 'package:event_app/screens/woohoo/transaction_history_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyVoucherDetailScreen extends StatefulWidget {
  final MyVoucher voucher;
  final String image;
  const MyVoucherDetailScreen({Key? key, required this.voucher, required this.image}) : super(key: key);

  @override
  _MyVoucherDetailScreenState createState() => _MyVoucherDetailScreenState();
}

class _MyVoucherDetailScreenState extends State<MyVoucherDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                      widget.voucher.invNo??'Order ${widget.voucher.id!}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  width: 12,
                ),
                _status(widget.voucher.status!),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                      '$rupeeSymbol ${widget.voucher.amount}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  width: 12,
                ),
                Text(
                  '${DateHelper.formatDateTime(DateHelper.getDateTime(widget.voucher.createdAt!), 'dd-MMM-yyyy  hh:mm a')}',
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
                        imageUrl: widget.image,
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
                    child: Text(widget.voucher.product!.name!,
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                ],
              ),
            ),

            _buildUser(),

            Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:  [

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
                                Text(
                                  widget.voucher.isGifted == 0
                                      ? widget.voucher.cardNo ?? ''
                                      :'${(widget.voucher.cardNo ?? '').replaceAllMapped(RegExp(r'.(?=.{4})'), (match) => '*')}',
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
                                Text(
                                  widget.voucher.isGifted == 0
                                      ? widget.voucher.cardPin ?? ''
                                      : '${(widget.voucher.cardPin ?? '').replaceAllMapped(RegExp(r'.(?=.{0})'), (match) => '*')}',
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
                            '$rupeeSymbol ${widget.voucher.amount}',
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
                                '${DateHelper.formatDateTime(DateHelper.getDateTime(widget.voucher.issueDate!), 'dd-MMM-yyyy')}',
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
                                '${DateHelper.formatDateTime(DateHelper.getDateTime(widget.voucher.validity!), 'dd-MMM-yyyy')}',
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


                    if(widget.voucher.activationUrl!=null && (widget.voucher.giftedBy!=null||widget.voucher.isGifted == 0))
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
                                      SelectableText('${widget.voucher.activationCode}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,),),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    onPressed: ()async{
                                      String url = '${widget.voucher.activationUrl}';
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

                    if(widget.voucher.giftedBy!=null && widget.voucher.isGifted == 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    Get.to(()=>CardBalanceScreen(cardNo: widget.voucher.cardNo??'', cardPin: widget.voucher.cardPin??''));
                                  },
                                  child: Text('Check balance',),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: (){
                                    Get.to(()=>TransactionHistoryScreen(cardNo: widget.voucher.cardNo??'', cardPin: widget.voucher.cardPin??''));
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
            ),


            Divider(),
            InkWell(
              onTap: (){
                if (widget.voucher.product!.description != null){
                  _showContentBottomSheet('Description',  widget.voucher.product!.description ?? '');
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Description',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15)),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Icon(Icons.arrow_forward,color: Colors.grey,)
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){
                if (widget.voucher.product!.tnc!.content != null){
                  _showContentBottomSheet('Terms & conditions', widget.voucher.product!.tnc!.content!);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Terms & conditions',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15)),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Icon(Icons.arrow_forward,color: Colors.grey,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildUser(){
    String title ,name, email, phone;
    if(widget.voucher.giftedBy!=null)
    {
      title = 'Gifted By';
      name = widget.voucher.giftedBy!.name!;
      email = widget.voucher.giftedBy!.email!;
      phone = widget.voucher.giftedBy!.phone!;
    }else{
      title = widget.voucher.isGifted==1?'Gifted To': 'Recipient';
      name = widget.voucher.recipientName!;
      email = widget.voucher.recipientEmail!;
      phone = widget.voucher.recipientMobile!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${email}',
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/ic_person_avatar.png'),
                      ),
                    ),)),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(email,
                    style: TextStyle(
                        fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 2),
                  Text(phone,
                    style: TextStyle(
                        fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  _showContentBottomSheet(String title, String content
      ) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (builder) {
          return Container(
            constraints: BoxConstraints(minHeight: 200,maxHeight: screenHeight*.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(title,
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    CloseButton(),
                  ],
                ),
                Divider(height: 1,),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      HtmlWidget(content),
                    ],
                  ),
                ),

              ],
            ),
          );
        });
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
