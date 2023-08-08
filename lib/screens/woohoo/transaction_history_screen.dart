import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/woohoo/transaction_history_response.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String cardNo;
  final String cardPin;

  const TransactionHistoryScreen({Key? key, required this.cardNo,  required this.cardPin})
      : super(key: key);

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {

  WoohooProductBloc _bloc = WoohooProductBloc();
  TransactionHistoryData? transactionHistoryData;

  @override
  void initState() {
    super.initState();

WidgetsBinding.instance.addPostFrameCallback((_) async {
  _getTransactionHistory();
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
      appBar: AppBar(title: Text('Transaction history'),),
      body: SafeArea(
        child:
        transactionHistoryData == null
            ? CommonApiLoader()
            : ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          children: [
            Row(
              children: [
                Expanded(child: Text('Card No: ${transactionHistoryData!.cards![0].cardNumber}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.w600),)),
                SizedBox(width: 12,),
                Text('${transactionHistoryData!.cards![0].status}',style: TextStyle(fontSize: 16,fontWeight:FontWeight.w600),),
              ],
            ),
            SizedBox(height: 12,),
            Text('Activation Date: ${DateHelper.formatDateTime(DateHelper.getDateTime(transactionHistoryData!.cards![0].activationDate!.replaceAll('T', ' ')), 'dd-MMM-yyy')}',style: TextStyle(fontSize: 16),),

            SizedBox(height: 8),
            Text('Expiry Date: ${DateHelper.formatDateTime(DateHelper.getDateTime(transactionHistoryData!.cards![0].expiryDate!.replaceAll('T', ' ')), 'dd-MMM-yyy')}',style: TextStyle(fontSize: 16),),
            SizedBox(height: 8,),
            // Expanded(child: Text('Balance: ${transactionHistoryData!.data![0].cards![0].balance}',style: TextStyle(fontSize: 16),)),


            SizedBox(height: 12,),
            Text('Transactions',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
            SizedBox(height: 12,),

            ((transactionHistoryData!.cards![0].transactions??[]).isEmpty)?
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('No transactions',style: TextStyle(fontSize: 16),),
                )
           : ListView.builder(
                shrinkWrap: true,
                itemCount: transactionHistoryData!.cards![0].transactions!.length,
                itemBuilder: (context,index
            ){
                  Transactions transaction = transactionHistoryData!.cards![0].transactions![index];
              return  Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('${transaction.type}',style: TextStyle(fontSize: 16),),
                        ),
                        SizedBox(width: 12,),
                        Text('${transaction.status}',style: TextStyle(fontSize: 16),),
                      ],
                    ),
                    SizedBox(height: 12,),
   Row(
                      children: [
                        Expanded(
                          child: Text('Amount: ${transaction.additionalTxnFields!.currencySymbol} ${transaction.amount}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                        ),
                        SizedBox(width: 12,),
                        Text('Balance: ${transaction.additionalTxnFields!.currencySymbol} ${transaction.balance}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                      ],
                    ),
                    SizedBox(height: 8,),
Divider(),
                    SizedBox(width: 12,),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Invoice No:\n${transaction.invoiceNumber}',style: TextStyle(fontSize: 16),),
                        ),
                        SizedBox(width: 12,),
                        Text('Date:\n${DateHelper.formatDateTime(DateHelper.getDateTime(transaction.date!.replaceAll('T', ' ')), 'dd-MMM-yyy')}',textAlign: TextAlign.right,style: TextStyle(fontSize: 16),),
                      ],
                    ),
                    SizedBox(height: 12,),

                    Text('Outlet name: ${transaction.outletName}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            );}
            )
          ],
        ),
      ),
    );
  }


  _getTransactionHistory() async {
    transactionHistoryData = await _bloc.getTransactions(
        widget.cardNo,widget.cardPin);

    if (transactionHistoryData == null || transactionHistoryData!.cards == null) {
      Get.back(result:true);
    } else {
      setState(() { });
    }
  }
}
