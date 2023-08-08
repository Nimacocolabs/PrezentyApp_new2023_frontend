import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/woohoo/card_balance_response.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardBalanceScreen extends StatefulWidget {
  final String cardNo;
  final String cardPin;

  const CardBalanceScreen({Key? key, required this.cardNo,  required this.cardPin})
      : super(key: key);

  @override
  _CardBalanceScreenState createState() => _CardBalanceScreenState();
}

class _CardBalanceScreenState extends State<CardBalanceScreen> {
  WoohooProductBloc _bloc = WoohooProductBloc();
  CardBalanceData? cardBalanceData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkBalance();
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
      appBar: AppBar(
        title: Text('Card balance'),
      ),
      body: SafeArea(
        child:
        cardBalanceData == null
            ? CommonApiLoader()
            : ListView(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          children: [
            Row(
              children: [
                Expanded(
                    child: Text('Card No: ${cardBalanceData!.cardNumber}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
                SizedBox(
                  width: 12,
                ),
                Text('${cardBalanceData!.status}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                'Expiry: ${DateHelper.formatDateTime(DateHelper.getDateTime(cardBalanceData!.expiry!.replaceAll('T', ' ')), 'dd-MMM-yyy')}',
                style: TextStyle(
                  fontSize: 16,
                )),
            SizedBox(
              height: 30,
            ),
            Text(
              'Balance Amount: ${cardBalanceData!.currency!.symbol} ${cardBalanceData!.balance}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  _checkBalance() async {
    cardBalanceData = await _bloc.getCardBalance(
      widget.cardNo,widget.cardPin);

    if (cardBalanceData == null || cardBalanceData!.cardNumber == null) {
     Get.back(result:true);
    } else {
      setState(() { });
    }
  }

}
