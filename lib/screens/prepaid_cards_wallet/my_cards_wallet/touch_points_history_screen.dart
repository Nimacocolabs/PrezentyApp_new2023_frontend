import 'dart:async';

import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoints_earning_history_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/touchpoint_redemption_history_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/app_helper.dart';
import '../../../util/date_helper.dart';

class TouchPointsHistoryScreen extends StatefulWidget {
  const TouchPointsHistoryScreen({ Key? key }) : super(key: key);
   

  @override
  State<TouchPointsHistoryScreen> createState() => _TouchPointsHistoryScreenState();
}

class _TouchPointsHistoryScreenState extends State<TouchPointsHistoryScreen> {
      
       WalletBloc _walletBloc = WalletBloc();
   int _tabIndex = 0;
   String accountId = User.userId;
   


  

  @override
  void dispose() {
    _walletBloc.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text("Touch points history"),
      // ),
      appBar: CommonAppBarWidget(
        title: "Touch points history",
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ),
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
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _tabIndex == 0
                                      ? Colors.white
                                      : primaryColor.shade800,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Text('Earning history')),
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
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _tabIndex == 1
                                      ? Colors.white
                                      : primaryColor.shade800,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Text('Redemption history')),
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                  )),
              Expanded(
                child: _tabIndex == 0
                    ? EarningHistory()
                    : _tabIndex == 1
                        ? RedemptionHistory()
                            : Center(
                                child: Text("Undefined"),
                              ),
                flex: 1,
              ),
            ],
          ),
        )
    );
  }
}

class EarningHistory extends StatefulWidget {
  const EarningHistory({ Key? key }) : super(key: key);

  @override
  State<EarningHistory> createState() => _EarningHistoryState();
}

class _EarningHistoryState extends State<EarningHistory> {
    WalletBloc _walletBloc = WalletBloc();
    String accountId = User.userId;
 
  @override
  void initState() {
    super.initState();
    tpEarningHistory();
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    super.dispose();
  }
 
   Future  tpEarningHistory() async {
    _walletBloc.getTPEarningHistory(accountId);
  }
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<dynamic>>(
          stream: _walletBloc.TouchPointEarningHistoryStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  return CommonApiLoader();
                case Status.COMPLETED:
                  TouchPointsEarningHistoryModel response = snapshot.data!.data;
                  return _earningHistoryTable(response.data);
                case Status.ERROR:
                  return CommonApiErrorWidget(
                      "${snapshot.data!.message!}", tpEarningHistory);
              }
            }
            return SizedBox();
          });
    
   }
      
   _earningHistoryTable(List<TPEarningHistoryResponse>? data) {
    if (data == null) {
      return CommonApiErrorWidget("Something went wrong", tpEarningHistory);
    } else if (data.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    }

    return SingleChildScrollView(
      child: DataTable(
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.blue.shade300),
        dataRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
        columnSpacing: 15.0,
        columns: [
          DataColumn(
            label: Text(
              "COMMENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              "TRANSACTION \n AMOUNT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              "EARNED \n POINTS",
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              "DATE",
             style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        rows: data
            .map(
              (mapValue) => DataRow(cells: [
                DataCell(Container(
                  width: screenWidth*.2,
                  child: Text(
                    mapValue.description ?? "",
                    style: TextStyle(
                       color:Colors.black,
                      fontSize: 10,
                    ),
                  ),
                )),
                DataCell(Container(
                  width: screenWidth*.2,
                  child: Text(
                    mapValue.transactionAmount ?? "",
                    style: TextStyle(
                 color:Colors.black,
                      fontSize: 10,
                    ),
                  ),
                )),
                DataCell(Container(
                  width: screenWidth*.2,
                  child: Text(
                    mapValue.earnPoints ?? "",
                    style: TextStyle(
                    color:Colors.black,
                      fontSize: 10,
                    ),
                  ),
                )),
                DataCell(
                  Container(
                    height:40,
                    width: screenWidth*.2,
                    child: Center(
                      child: Text(
                        DateHelper.formatDateTime(DateHelper.getDateTime( mapValue.earnDate ?? ""), 'dd-MMM-yyyy hh:mm a'),
                        style: TextStyle(
                          color:Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }
}

class RedemptionHistory extends StatefulWidget {
  const RedemptionHistory({ Key? key }) : super(key: key);

  @override
  State<RedemptionHistory> createState() => _RedemptionHistoryState();
}

class _RedemptionHistoryState extends State<RedemptionHistory> {
  WalletBloc _walletBloc = WalletBloc();
     String accountId = User.userId;

  @override
  void initState() {
    super.initState();
    tpRedemptionHistory();
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    super.dispose();
  }

  Future  tpRedemptionHistory() async {
    _walletBloc.getTPRedemptionHistory(accountId);
  }


  @override
  Widget build(BuildContext context) {
  
    return  StreamBuilder<ApiResponse<dynamic>>(
          stream: _walletBloc.TouchPointRedemptionHistoryStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  return CommonApiLoader();
                case Status.COMPLETED:
                  TouchPointsRedemptionHistoryModel response = snapshot.data!.data;
                  return _redemptionHistoryTable(response.data);
                case Status.ERROR:
                  return CommonApiErrorWidget(
                      "${snapshot.data!.message!}", tpRedemptionHistory);
              }
            }
            return SizedBox();
          });
    
   }


  
  _redemptionHistoryTable(List<TPRedemptionResponse>? data) {
    if (data == null) {
      return CommonApiErrorWidget("Something went wrong", tpRedemptionHistory);
    } else if (data.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    }
    return SingleChildScrollView(
      child: DataTable(
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.blue.shade300),
          dataRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
          columnSpacing: 5.0,
          columns: [
            DataColumn(
              label: Text(
                "NAME OF \n PRODUCT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                " REDEEMED \n POINTS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "AMOUNT \n PAID",
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "TOTAL \n AMOUNT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "DATE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          rows: data
              .map(
                (mapValue) => DataRow(cells: [
                  DataCell(Container(
                    width: screenWidth*.2,
                    child: Text(
                      mapValue.productName ?? "",
                      style: TextStyle(
                         color:Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(Container(
                    width: screenWidth*.1,
                    child: Text(
                      mapValue.touchPoint ?? " 0",
                      style: TextStyle(
                   color:Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(Container(
                    width: screenWidth*.1,
                    child: Text(
                      mapValue.payAmount ?? "0",
                      style: TextStyle(
                      color:Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(
                    Container(
                      height:40,
                      width: screenWidth*.1,
                      child: Center(
                        child: Text(
                          mapValue.totalPaidAmount ?? "",
                          style: TextStyle(
                            color:Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                   DataCell(
                    Container(
                      height:40,
                      width: screenWidth*.2,
                      child: Center(
                        child: Text(
                          DateHelper.formatDateTime(DateHelper.getDateTime( mapValue.createdAt ?? ""), 'dd-MMM-yyyy hh:mm a'),
                          style: TextStyle(
                            color:Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
    );
  }
  
}