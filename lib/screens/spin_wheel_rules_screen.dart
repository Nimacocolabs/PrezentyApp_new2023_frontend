

import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/models/spin_wheel_rules_model.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';


class SpinWheelRulesScreen extends StatefulWidget {
  const SpinWheelRulesScreen({Key? key});

  @override
  State<SpinWheelRulesScreen> createState() => _SpinWheelRulesScreenState();
}

class _SpinWheelRulesScreenState extends State<SpinWheelRulesScreen> {
 AuthBloc _authBloc = AuthBloc();
 SpinWheelRulesData? spinWeheelRulesData;

 @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      
      getSpinWheelRules();
    });
  }
 
 Future<SpinWheelRulesData?> getSpinWheelRules() async {
    SpinWheelRulesData? data = (await _authBloc.spinWheelRules());
    setState(() {
      spinWeheelRulesData = data;
    });
    return spinWeheelRulesData;
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
      body: SingleChildScrollView(child: 
      Column(
        children: [
         Padding(
           padding: const EdgeInsets.all(22.0),
           child: Column(
             children: [
               Center(
                 child: Text("Rules of the Game",
                 style: TextStyle(
                  color:Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                 ),),
         
               ),
                       Divider(thickness: 1,),
                       
             ],
           ),

         ),
         spinWeheelRulesData != null ?
         Padding(
           padding: const EdgeInsets.only(left: 10,right: 10,bottom: 12),
           child: Column(
             children: [
               HtmlWidget('${spinWeheelRulesData!.conditions}',
               textStyle: TextStyle(color: Colors.black,fontSize: 16),),
               
             ],
           ),
         ):Container(),      
        ],
      )),
    );
  }
}