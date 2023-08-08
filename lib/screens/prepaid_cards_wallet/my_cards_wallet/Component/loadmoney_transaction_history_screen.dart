
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/wallet&prepaid_cards/load_money_transaction_history_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoadMoneyTransactionHistoryScreen extends StatefulWidget {
  final String? loadMoneyType;
  const LoadMoneyTransactionHistoryScreen({this.loadMoneyType});

  @override
  State<LoadMoneyTransactionHistoryScreen> createState() => _LoadMoneyTransactionHistoryScreenState();
}

class _LoadMoneyTransactionHistoryScreenState extends State<LoadMoneyTransactionHistoryScreen> {
 WalletBloc  _walletBloc = WalletBloc();
 

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    _walletBloc.loadMoneyTransactionHistory(accountId: User.userId,type: widget.loadMoneyType == "load" ?"load": "event");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ),
      bottomNavigationBar:CommonBottomNavigationWidget(),
      body: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Text(widget.loadMoneyType == "event" ? "Event Based Load Money History" : "Load Money History",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 20),),
            ),
          ),
          Divider(thickness: 2,),
        SizedBox(
      width: screenWidth,
     
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _walletBloc.loadMoneyTransactionHistoryStream,
          builder: (context, snapshot) {
            print("aaaa");
            if (snapshot.hasData && snapshot.data?.status != null) {
              print("bbbbb");
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  print("ccccc");
                  return CommonApiLoader();
                case Status.COMPLETED:
                  print("dddd");
                  LoadMoneyTransactionHistoryModel response =
                      snapshot.data!.data!;

                  final cardResponse = response.data;
                  // return Text("123456");

                  return transactionStatement(cardResponse);

                case Status.ERROR:
                  print("eeee");
                  return CommonApiResultsEmptyWidget(
                      "${snapshot.data?.message ?? ""}",
                      textColorReceived: Colors.black);
                default:
                  print("");
              }
            }
            return SizedBox();
          }),
    ),
      ],)),
    );
  }
  transactionStatement(List<LoadMoneyTransactionHistoryData>? transactionData){
    
if(transactionData!.isEmpty){
  return CommonApiResultsEmptyWidget("No transactions to show");
} else{
 return ListView.builder(
  physics: ScrollPhysics(),
      padding: MediaQuery.of(context).viewInsets,
                shrinkWrap: true,
    itemCount: transactionData.length,
    itemBuilder: (context, index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(elevation: 5,
        margin: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
      child:Padding( padding: const EdgeInsets.all(12.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
  _item(title: "Date: ",value: "${transactionData[index].transactionDate}"),
   SizedBox(height: 5,),
 _item(title: "Wallet Number: ",value: "${transactionData[index].walletNumber}"),
 SizedBox(height: 5,),
 widget.loadMoneyType == "load" ?
  _item(title: "Type: ",value: "${transactionData[index].type}")
  : _item(title: "Description: ",value: "${transactionData[index].description}"),
   SizedBox(height: 5,),
   _item(title: "Event ID: ",value: "${transactionData[index].eventId }"),
   SizedBox(height: 5,),
  _item(title: "Amount: ",value: "${rupeeSymbol} ${transactionData[index].amount}"),
   SizedBox(height: 5,),
  _item(title: "Transaction ID: ",value: "${transactionData[index].decentroTxnId}"),
   SizedBox(height: 5,),
  _item(title: "Status: ",value: "${transactionData[index].status}"),
      ],)
      
      ) ,),
    );
  },);
}
  }
   Widget _item({String? title, String? value}) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(
        title!,
        style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w600),
      ),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          value!,textAlign: TextAlign.right,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      )
    ]);
  }
}