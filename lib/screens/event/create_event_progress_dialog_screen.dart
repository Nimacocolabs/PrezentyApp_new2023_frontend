import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/create_event_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateEventProgressDialogScreen extends StatefulWidget {
  final dio.FormData formData;
  final bool isUpdate;
  const CreateEventProgressDialogScreen({Key? key, required this.formData, required this.isUpdate}) : super(key: key);

  @override
  _CreateEventProgressDialogScreenState createState() => _CreateEventProgressDialogScreenState();
}

class _CreateEventProgressDialogScreenState extends State<CreateEventProgressDialogScreen> {

  double _progressValue =0;

  @override
  void initState() {
    super.initState();
    if(widget.isUpdate){
      _updateEvent();
    }else{
      _createEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: WillPopScope(
        onWillPop: () async {
          return  false;
        },
        child: SafeArea(
          child: Center(
            child: Container(
              height: 200,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Image.asset(
                    'assets/images/ic_logo.png',
                    height: 36,
                    width: 36,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 18),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey.shade300,
                        value: _progressValue==1?null:_progressValue,
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoActivityIndicator(),
                        SizedBox(width: 12,),
                        Text(
                          widget.isUpdate?'Updating event':'Creating event',
                          style: TextStyle(color: secondaryColor, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _updateEvent() async {
    try {
      final response = await ApiProvider().getMultipartInstance().post('${Apis.updateEvent}',data: widget.formData,
        onSendProgress: _dioProcess,
      );
      Get.back(result: CommonResponse.fromJson(response.data));
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
  }

  _createEvent() async {
    try {
      final response = await ApiProvider().getMultipartInstance().post('${Apis.createEvent}',data: widget.formData,
        onSendProgress: _dioProcess,
      );

      CreateEventResponse data = CreateEventResponse.fromJson(response.data);
      if(data.success??false){
        Get.back(result: data);
      }else{
        toastMessage(data.message??'unable to create new event. please try again later');
        Get.back();
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
  }

  _dioProcess(int sent, int total) {
    // final progress = sent / total;
    _progressValue = double.parse((sent / total).toStringAsFixed(4));
    setState(() { });
  }
}
