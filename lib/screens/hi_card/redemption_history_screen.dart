
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/hi_card/hi_card_redemption_history_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:flutter/material.dart';


class HICardRedemptionHistoryScreen extends StatefulWidget {
  final String hiCardNo;
  final String hiCardPin;
  const HICardRedemptionHistoryScreen({Key? key, required this.hiCardNo, required this.hiCardPin }) : super(key: key);

  @override
  State<HICardRedemptionHistoryScreen> createState() => _HICardRedemptionHistoryScreenState();
}

class _HICardRedemptionHistoryScreenState extends State<HICardRedemptionHistoryScreen> {
 ProfileBloc _profileBloc =ProfileBloc();
 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
    
      _profileBloc.getHICardRedemptionHistory(widget.hiCardNo,widget.hiCardPin );
    });
   
  }
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
appBar: AppBar(),
body: SingleChildScrollView(child: 
Column(
  children: [
    Padding(
  padding: const EdgeInsets.all(20.0),
  child:   Center(
    child: Text("H! Rewards Transaction History",
    style: TextStyle(

      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20
    ),),
  ),
),
Divider(
  thickness: 2,
),
 SizedBox(
  width: screenWidth,
  height: screenHeight,
      child: StreamBuilder<ApiResponse<dynamic>>(
        stream:_profileBloc.hiCardRedemptionHistoryStream,
        builder: (context, snapshot) {
          print("aaaa");
          if (snapshot.hasData && snapshot.data?.status != null) {

            switch (snapshot.data!.status!) {
              case Status.LOADING:
                print("ccccc");
                return CommonApiLoader();
              case Status.COMPLETED:
                print("dddd");
                HiCardRedemptionHistoryModel response =
                    snapshot.data!.data!;

                
              final productsResponse = response.data;
                
                return hiCardRedemptionHistoryTable(productsResponse!);

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
  ],
)),
    );
  }

   hiCardRedemptionHistoryTable(List<HiCardRedemptionHistoryData>? redemptionData) {
    if (redemptionData == null) {
      return CommonApiErrorWidget("Something went wrong", hiCardRedemptionHistoryTable);
    } else if (redemptionData.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DataTable(
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Color.fromRGBO(122,21, 71, 0.9)),
          dataRowColor:
              MaterialStateColor.resolveWith((states) => Color.fromRGBO(171, 24, 99, 0.2)),
          columnSpacing: 15.0,
          columns: [
            DataColumn(
              label: Text(
                "Sl.No",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "DESCRIPTION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "AMOUNT",
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
          rows: redemptionData
              .map(
                (e) => DataRow(cells: [
                  DataCell(Container(
                    width: screenWidth*.1,
                    child: Text(
                      e.id.toString() ,
                      style: TextStyle(
                         color:Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(Container(
                    width: screenWidth*.3,
                    child: Text(
                     e.description ?? "",
                      style: TextStyle(
                   color:Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  )),
                  DataCell(Container(
                    width: screenWidth*.2,
                    child: Text(
                      e.amount ?? "",
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
                          DateHelper.formatDateTime(DateHelper.getDateTime( e.createdAt??""), 'dd-MMM-yyyy hh:mm a'),
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
      ),
    );
  }
}