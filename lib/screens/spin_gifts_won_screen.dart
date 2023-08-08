import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';

import '../models/spin_voucher_list_response.dart';

class SpinGiftsWonScreen extends StatefulWidget {
  SpinGiftsWonScreen(
      {Key? key,
      required this.currentDate,
      required this.email,
      required this.phone,
      required this.spinData,
      required this.spinDate,
      required this.insTableId})
      : super(key: key);

  final String currentDate;
  final String email;
  final String phone;
  final int insTableId;
  final String spinDate;
  final SpinVoucherData spinData;

  @override
  State<SpinGiftsWonScreen> createState() => _SpinGiftsWonScreenState();
}

class _SpinGiftsWonScreenState extends State<SpinGiftsWonScreen> {
  CountdownTimerController? controller;
  int endTime = 0;

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  _startTimer() {
    DateTime currentDate = DateHelper.getDateTime(widget.currentDate);
    DateTime spinDate = DateHelper.getDateTime(widget.spinDate);
    int diff = spinDate.difference(currentDate).inMinutes;

    if(diff>60){
      print('Spin expired');
      Get.back();
      return;
    }

    endTime = DateTime.now().add(Duration(minutes: 60+diff)).millisecondsSinceEpoch;
    controller = CountdownTimerController(endTime: endTime, onEnd: _onTimerEnd);
    setState(() {});
  }

  _onTimerEnd() {
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _profileBloc.insertSpinUserAttempt(widget.email, widget.phone);
      _startTimer();
    });
  }

  @override
  void dispose() {
    if (controller != null) {
      if (controller!.isRunning) controller!.disposeTimer();

      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),        body: ListView(padding: EdgeInsets.all(12), shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 12,
              ),
              Text(
                widget.spinData.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image(
                  image: AssetImage('assets/images/gift_won_image.png'),
                  width: double.infinity,
                  height: screenHeight * 0.28,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("${widget.spinData.shortDescription ?? ""}",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              SizedBox(
                height: 20,
              ),
              _buildTimerUi(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: OutlinedButton(
                          onPressed: () {
                           // Get.back();
                           Get.offAll(() => MainScreen());
                          },
                          child: Text("May be later"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            ProfileBloc().getUserSpinItem(
                                widget.insTableId, widget.spinData.type ?? '');
                          },
                          child: Text("Get now"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            ]));
  }

  Widget _buildTimerUi() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text("Deal ends in:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: 12,
          ),
          CountdownTimer(
            controller: controller,
            endTime: endTime,
            widgetBuilder: (context, remainingTime) {
              if (remainingTime?.sec == null) {
                return Text('00 : 00',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600));
              }
              return Text(
                '${twoDigits(remainingTime?.min ?? 0)} : ${twoDigits(remainingTime?.sec ?? 0)}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              );
            },
          ),
        ],
      ),
    );
  }
}
