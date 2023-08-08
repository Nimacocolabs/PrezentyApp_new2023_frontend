import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/voucher_report_bloc.dart';
import 'package:event_app/models/send_food_order_list_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/receive_statement_response.dart';
import '../../../models/redeem_statement_response.dart';
import 'report_order_detail_screen.dart';

class ReportScreen extends StatefulWidget {
  final int eventId;

  const ReportScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  VoucherReportBloc _bloc = VoucherReportBloc();
  int _tabIndex = 0;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Reports'),
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
                              child: Center(child: Text('Receive')),
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
                              child: Center(child: Text('Sent Food')),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: InkWell(
                        //     borderRadius: BorderRadius.circular(50),
                        //     onTap: () {
                        //       if (_tabIndex == 2) return;
                        //       setState(() {
                        //         _tabIndex = 2;
                        //       });
                        //     },
                        //     child: Container(
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //           color: _tabIndex == 2
                        //               ? Colors.white
                        //               : primaryColor.shade800,
                        //           borderRadius: BorderRadius.circular(50)),
                        //       child: Center(child: Text('Redeem')),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )),
              Expanded(
                child: _tabIndex == 0
                    ? ReceivePage(eventId: widget.eventId)
                    : _tabIndex == 1
                        ? SentFoodPage(
                            eventId: widget.eventId, tabIndex: _tabIndex)
                        : _tabIndex == 2
                            ? RedeemPage(eventId: widget.eventId)
                            : Center(
                                child: Text("Undefined"),
                              ),
                flex: 1,
              ),
            ],
          ),
        ));
  }
}

class ReceivePage extends StatefulWidget {
  const ReceivePage({Key? key, required this.eventId}) : super(key: key);
  final int eventId;

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  VoucherReportBloc _bloc = VoucherReportBloc();

  @override
  void initState() {
    super.initState();
    _getReceive();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Future _getReceive() async {
    _bloc.getReceiveStatement(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getReceive,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _bloc.receiveStatementListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  return CommonApiLoader();
                case Status.COMPLETED:
                  ReceiveStatementResponse response = snapshot.data!.data;
                  return _buildReceiveTable(response.data);
                case Status.ERROR:
                  return CommonApiErrorWidget(
                      "${snapshot.data!.message!}", _getReceive);
              }
            }
            return SizedBox();
          }),
    );
  }

  _buildReceiveTable(List<ReceiveData>? data) {
    if (data == null) {
      return CommonApiErrorWidget("Something went wrong", _getReceive);
    } else if (data.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    }
    return DataTable(
      headingRowColor:
          MaterialStateColor.resolveWith((states) => Colors.blue.shade300),
      dataRowColor:
          MaterialStateColor.resolveWith((states) => Colors.pink.shade300),
      columnSpacing: 15.0,
      columns: [
        DataColumn(
          label: Text(
            "DATE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "EVENT ID",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "AMOUNT\nRECEIVED",
            maxLines: 2,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "NAME",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      rows: data
          .map(
            (mapValue) => DataRow(cells: [
              DataCell(Container(
                width: 70,
                child: Text(
                  mapValue.createdAt ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              )),
              DataCell(Container(
                width: 70,
                child: Text(
                  mapValue.eventId ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              )),
              DataCell(Container(
                width: 70,
                child: Text(
                  mapValue.amount ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              )),
              DataCell(
                Container(
                  width: 70,
                  child: Text(
                    mapValue.name ?? "",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ]),
          )
          .toList(),
    );
  }
}

class RedeemPage extends StatefulWidget {
  const RedeemPage({Key? key, required this.eventId}) : super(key: key);
  final int eventId;

  @override
  State<RedeemPage> createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
  VoucherReportBloc _bloc = VoucherReportBloc();

  @override
  void initState() {
    super.initState();
    _getRedeem();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Future _getRedeem() async {
    _bloc.getRedeemStatement(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getRedeem,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _bloc.redeemStatementListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  return CommonApiLoader();
                case Status.COMPLETED:
                  RedeemStatementResponse response = snapshot.data!.data;
                  return _buildRedeemTable(response.data);
                case Status.ERROR:
                  return CommonApiErrorWidget(
                      "${snapshot.data!.message!}", _getRedeem);
              }
            }
            return SizedBox();
          }),
    );
  }

  _buildRedeemTable(List<RedeemStatementData>? data) {
    if (data == null) {
      return CommonApiErrorWidget("Something went wrong", _getRedeem);
    } else if (data.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    }

    return DataTable(
      headingRowColor:
          MaterialStateColor.resolveWith((states) => Colors.blue.shade300),
      dataRowColor:
          MaterialStateColor.resolveWith((states) => Colors.pink.shade300),
      columnSpacing: 15.0,
      columns: [
        DataColumn(
          label: Text(
            "DATE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "EVENT ID",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "COINS\nREDEEMED",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "MERCHANT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
      rows: data
          .map(
            (mapValue) => DataRow(cells: [
              DataCell(Container(
                width: 70,
                child: Text(
                  mapValue.createdAt ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              )),
              DataCell(Container(
                width: 70,
                child: Text(
                  mapValue.eventId ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              )),
              DataCell(Container(
                width: 70,
                child: Text(
                  mapValue.amount ?? "",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              )),
              DataCell(
                Container(
                  width: 70,
                  child: Text(
                    mapValue.name ?? "",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ]),
          )
          .toList(),
    );
  }
}

class SentFoodPage extends StatefulWidget {
  const SentFoodPage({Key? key, required this.eventId, required this.tabIndex})
      : super(key: key);
  final int eventId;
  final int tabIndex;

  @override
  State<SentFoodPage> createState() => _SentFoodPageState();
}

class _SentFoodPageState extends State<SentFoodPage> {
  VoucherReportBloc _bloc = VoucherReportBloc();

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Future _getDetails() async {
    _bloc.getReportOrders(widget.eventId, isRedeemOrders: widget.tabIndex == 0);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getDetails,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream: _bloc.sendFoodOrderListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status!) {
                case Status.LOADING:
                  return CommonApiLoader();
                case Status.COMPLETED:
                  ReportOrderListResponse response = snapshot.data!.data;
                  return _buildList(
                      response.data!, response.basePathWoohooImages ?? '');
                case Status.ERROR:
                  return CommonApiErrorWidget(
                      "${snapshot.data!.message!}", _getDetails);
              }
            }
            return SizedBox();
          }),
    );
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

  Widget _buildList(List<ReportOrder> list, String basePathWoohooImages) {
    if (list.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No report'));
    } else {
      return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: list.length,
          itemBuilder: (context, index) {
            ReportOrder order = list[index];
            String image = order.image != null
                ? '${basePathWoohooImages}${order.image}'
                : order.product!.image!;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(
                    () => ReportOrderDetailScreen(
                      isFromRedeem: widget.tabIndex == 0,
                      order: order,
                      image: image,
                    ),
                  );
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
                                  order.payment!.invNo ??
                                      'Order ${order.payment!.id!}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                                SizedBox(
                                  width: 12,
                                ),
                                _status(order.payment!.status!),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  '$rupeeSymbol ${order.payment!.amount}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${DateHelper.formatDateTime(DateHelper.getDateTime(order.payment!.createdAt!), 'dd-MMM-yyyy')}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${order.product!.productName} (${(order.orders ?? []).length})',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
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
}
