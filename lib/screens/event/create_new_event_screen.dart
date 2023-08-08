import 'package:event_app/bloc/profile_bloc.dart';

import 'package:event_app/screens/info_video_screen.dart';

import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_button.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import 'template_category_list_screen.dart';


class CreateNewEventScreen extends StatefulWidget {
  final bool? showAppBar;
  const CreateNewEventScreen({this.showAppBar});

  @override
  _CreateNewEventScreenState createState() => _CreateNewEventScreenState();
}

class _CreateNewEventScreenState extends State<CreateNewEventScreen> {
  TextFieldControl _textFieldControlTitle = TextFieldControl();
  TextFieldControl _textFieldControlCreatedBy = TextFieldControl();
  DateTime _dateTime = DateTime.now();

  ProfileBloc _profileBloc = ProfileBloc();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _checkUserHasPhoneNumber();
      _textFieldControlTitle.focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ?? false?
      CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ): null,
      // bottomNavigationBar: Container(
      //     height: 50.0,
      //     width: double.infinity,
      //     margin: EdgeInsets.all(8),
      //     child: CommonButton(
      //         buttonText: "Next",
      //         bgColorReceived: secondaryColor,
      //         borderColorReceived: secondaryColor,
      //         textColorReceived: Colors.white,
      //         buttonHandler: (){
      //           _validate();
      //         })
      // ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ElevatedButton(
      //       style: ElevatedButton.styleFrom(primary: secondaryColor),
      //       onPressed: (){
      //         _validate();
      //       }, child: Text('Next')),
      // ),
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: TitleWithSeeAllButton(title: 'Create Event')),
              IconButton(
                onPressed: (){
                  Get.to(() => InfoVideoScreen(videoId: 'create_event'));
                }, 
                icon: Icon(Icons.info_outline_rounded),
                color: Colors.grey,
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                AppTextBox(
                  textFieldControl: _textFieldControlTitle,
                  hintText: 'Title',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Created by',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                AppTextBox(
                  textFieldControl: _textFieldControlCreatedBy,
                  hintText: 'Created by',
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 8,
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DateTime dt = await DateHelper.pickDate(context,_dateTime);
                              if(_dateTime != dt) {
                                _dateTime =DateTime(dt.year,dt.month,dt.day,_dateTime.hour,_dateTime.minute);
                                setState(() {});
                              }
                            },
                            child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${DateHelper.formatDateTime(_dateTime, 'dd-MMM-yyy')}'),
                                Icon(CupertinoIcons.calendar),
                              ],
                            )
                          ),),
                        ],
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              DateTime dt = await DateHelper.pickTime(context,_dateTime);
                              if(_dateTime != dt) {
                                _dateTime = DateTime(_dateTime.year,_dateTime.month,_dateTime.day,dt.hour,dt.minute);
                                setState(() {});
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${DateHelper.formatDateTime(_dateTime, 'hh:mm a')}'),
                                    Icon(CupertinoIcons.time),
                                  ],
                                )
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 280,
                // ),
                 Padding(
                   padding: const EdgeInsets.only(top: 50),
                   child: ElevatedButton(style: ElevatedButton.styleFrom(primary: secondaryColor),
                    onPressed: (){
                      _validate();
                    }, child: Text("Next")),
                 ),

                SizedBox(
                  height: 20,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  _validate(){
    FocusScope.of(context).unfocus();
    String title = _textFieldControlTitle.controller.text.trim();
    if(title.isEmpty){
      toastMessage('Please provide a title for your event');
      _textFieldControlTitle.focusNode.requestFocus();
    }else if(_dateTime.isBefore(DateTime.now())){
      toastMessage('Please provide a valid date and time');
    }else{
     EventData.init(title, _dateTime, _textFieldControlCreatedBy.controller.text.trim());

     // Navigator.pushNamed(context, '/createEventStart');
     Get.to(()=>TemplateCategoryListScreen());
    }
  }

 // _checkUserHasPhoneNumber() async {
 //   bool? b = await _profileBloc.isUserHasPhoneNumber();
 //
 //   if(b == null){
 //     toastMessage('Unable to find your contact info');
 //     Get.offAll(() => MainScreen());
 //   } else if(!b){
 //     bool? b1 = await Get.to(()=>UpdatePhoneNumberScreen(),opaque: false);
 //
 //     if(b1 == null){
 //       toastMessage('Update your phone number to create new event');
 //       Get.offAll(() => MainScreen());
 //     }
 //   }
 // }

}
