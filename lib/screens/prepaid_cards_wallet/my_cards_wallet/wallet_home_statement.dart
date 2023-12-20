import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_statement_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:flutter/material.dart';

class WalletStatementList extends StatefulWidget {
  const WalletStatementList(
      {Key? key, required this.fromDate, required this.toDate,required this.entityId})
      : super(key: key);
  final String fromDate;
  final String toDate;
  final String entityId;

  @override
  _WalletStatementListState createState() => _WalletStatementListState();
}

class _WalletStatementListState extends State<WalletStatementList>
    with LoadMoreListener {
  late WalletBloc _walletBloc;
  bool isLoadingMore = false;
  

  // String? birthDateInString;
  // DateTime? birthDate;
  // bool? isDateSelected;

  @override
  void initState() {
    super.initState();

    _walletBloc = WalletBloc(listener: this);
    _walletBloc.getStatementList(false,
        entityId: widget.entityId, fromDate: widget.fromDate, toDate: widget.toDate);
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    super.dispose();
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: _walletBloc.statementStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              return SizedBox(
                  width: screenWidth,
                  height: screenHeight - 320,
                  child: CommonApiLoader());
            case Status.COMPLETED:
              WalletStatementResponse resp = snapshot.data!.data;
              return _buildList();
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
    );
  }

  Widget _item(String title, String value) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(
        title,
        style: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          value,textAlign: TextAlign.right,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      )
    ]);
  }

  Widget _buildList() {
    List<Transactions> list = _walletBloc.statementList;
    return
      list.isEmpty
        ? Padding(
          padding: const EdgeInsets.all(50.0),
          child: CommonApiResultsEmptyWidget("No transactions to show"),
        )
        :
      Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical:8),
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  list[index].transaction!.time.toString(),
                                    // list[index].timestamp.toString().split(' ').first,
                                    style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8),
                                  if(list[index].transaction!.type == "CREDIT" )
                                   Expanded(
                                     child: Text(
                                      "+" +" "+ rupeeSymbol + "${list[index].transaction!.amount}",
                                       textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 14, color: Colors.green,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if(list[index].transaction!.type == "DEBIT" )
                                  Expanded(
                                     child: Text(
                                      "-" + " "+rupeeSymbol + "${list[index].transaction!.amount}",
                                       textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 14, color: Colors.red,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: 5,
                            ),
                            _item(
                                '${list[index].transaction!.transactionType}',
                              "transactionType"
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // if (list[index].bankReferenceNumber != null)
                            //   Padding(
                            //     padding: const EdgeInsets.only(bottom: 5.0),
                            //     child: _item("Bank Ref ID",
                            //         "bankReferenceNumber"),
                            //         // '${list[index].bankReferenceNumber}'),
                            //   ),
                            _item(
                              "Transaction ID",
                              '${list[index].transaction!.txRef}',
                            ),
                            // item(
                            //   "Transaction ID",
                            //   '${list[index].transaction!.externalTransactionId}',
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            // _item(
                            //   "Closing Balance",
                            //   rupeeSymbol + ''${list[index].openingBalance}'',
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            _item(
                              "Current Balance",
                              rupeeSymbol + '${list[index].transaction!.balance}',
                                  // '${list[index].closingBalance}',
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _item(
                              "Transaction Status",
                              '${list[index].transaction!.transactionStatus}',
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ));
                },
              ),
            if(isLoadingMore)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            if(_walletBloc.hasNextPage && !isLoadingMore)
              TextButton(onPressed: _loadMoreEntries, child: Text('Load More')),
          ],
        );
  }


  _loadMoreEntries(){
    if (_walletBloc.hasNextPage) {
      _walletBloc.getStatementList(true,
          entityId: widget.entityId,
          fromDate: widget.fromDate,
          toDate: widget.toDate);
    }
  }

}
