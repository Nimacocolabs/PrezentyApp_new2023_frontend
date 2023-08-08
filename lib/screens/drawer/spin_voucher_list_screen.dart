import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/spin_user_input_model.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/spin_voucher_list_response.dart';
import '../../network/api_response.dart';
import '../../util/date_helper.dart';
import '../../util/user.dart';
import '../../widgets/CommonApiErrorWidget.dart';
import '../../widgets/CommonApiLoader.dart';
import '../spin_gifts_won_screen.dart';

class SpinVoucherListScreen extends StatefulWidget {
  const SpinVoucherListScreen({Key? key}) : super(key: key);

  @override
  State<SpinVoucherListScreen> createState() => _SpinVoucherListScreenState();
}

class _SpinVoucherListScreenState extends State<SpinVoucherListScreen> {
  ProfileBloc _bloc = ProfileBloc();

  @override
  void initState() {
    super.initState();

    _bloc.getSpinVoucherList(User.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            return _bloc.getSpinVoucherList(User.userId);
          },
          child: StreamBuilder<ApiResponse<SpinVoucherListResponse>>(
              stream: _bloc.spinVoucherStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      return CommonApiLoader();
                    case Status.COMPLETED:
                      return _buildContent(snapshot.data?.data?.data ?? []);
                    case Status.ERROR:
                      return CommonApiErrorWidget(snapshot.data!.message!, () {
                        _bloc.getSpinVoucherList(User.userId);
                      });
                  }
                }
                return SizedBox();
              }),
        ),
      ),
    );
  }

  _buildContent(List<SpinVoucherData> list) {
    if (list.isEmpty) {
      return CommonApiResultsEmptyWidget('No result');
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap:true,
            padding: EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              SpinVoucherData item = list[index];
              DateTime spinDate = DateHelper.getDateTime(item.spinDate??'');
              print(item.spinDate);
              return Card(
                child: ListTile(
                  onTap: () async {
                   DateTime currentDateTime =  await _bloc.getCurrentDateTime();
                    if(spinDate.isBefore(currentDateTime.subtract(Duration(hours: 1)))){
                      toastMessage('The voucher is expired');
                      list.removeAt(index);
                      setState(() {  });
                      return;
                    }
                    Get.to(() => SpinGiftsWonScreen(
                       currentDate:currentDateTime.toString(),
                        email: User.userEmail,
                        phone: User.userMobile,
                        insTableId: item.id ?? 0,
                        spinData: item,
                        spinDate: item.spinDate ?? ''));
                  },
                  title: Text(item.title ?? ''),
                  subtitle: Text(
                    item.shortDescription ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text('Expire at\n'
                  +DateHelper.formatDateTime(
                    spinDate.add(Duration(hours:1)),
                     'hh:mm a'),textAlign: TextAlign.center,),
                ),
              );
            }),
      ],
    );
  }
}
