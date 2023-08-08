import 'dart:async';

import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/spin_wheel_rules_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'dart:math' as math;

import 'package:get/get.dart';

import '../models/spin_user_input_model.dart';



class SpinAndWinScreen extends StatefulWidget {

  final int instTableID;
  final List<SpinList> spinList;

  const SpinAndWinScreen({Key? key, required this.instTableID, required this.spinList}) : super(key: key);

  @override
  _SpinAndWinScreenState createState() => _SpinAndWinScreenState();
}

class _SpinAndWinScreenState extends State<SpinAndWinScreen> {
  StreamController<int> selected = StreamController<int>.broadcast();
  SpinList? selectedSpinItem ;
    List<SpinList> spinList =[];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    spinList = widget.spinList;
    spinList.shuffle() ;
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.to(() => MainScreen());
              },
              image: User.userImageUrl,
            ),
       body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
                            colors: [Color.fromRGBO(65, 201, 151, 0.8), Color.fromRGBO(213, 213, 97, 0.9)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Text('Spin the wheel to win BIG',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),

              StreamBuilder<Object>(
                  stream: selected.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                      int value = snapshot.data as int;
                      selectedSpinItem = spinList[value];
                    }
                    return SizedBox();
                  }
                  ) ,
              Flexible(
                child: FortuneWheel(
                  animateFirst: false,
                  selected: selected.stream,
                  onAnimationEnd: _spinCompleted,
                  indicators: <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment.topCenter,
                      child: TriangleIndicator(color: secondaryColor.shade500),
                    ),
                  ],
                  items: [
                    for(int i =0;i<spinList.length;i++)
                       FortuneItem(child: Text(spinList[i].title??'',
                         style: TextStyle(fontSize: 11, color: Colors.black),),
                      style: FortuneItemStyle(
                          color: i % 2 == 0
                              ? Colors.orange.shade200
                              : Colors.lime.shade100
                      ),),
                  ],
                ),
              ),
              

              ElevatedButton(
                  onPressed: () {
                   
                    setState(() {
                      selected.add(
                        Fortune.randomInt(0, spinList.length),
                      );
                    });
                  },
                  child: Text(
                    "Play",
                  )),

              OutlinedButton(
                style:OutlinedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  primary: Colors.white
                ) ,
                  onPressed: () {
                   Get.offAll(() => MainScreen());
                  },
                  child: Text(
                    "May be later",
                  )),

                  ElevatedButton(onPressed: (){
                     Get.to(() => SpinWheelRulesScreen());
                  }, child: Text("Rules of the game"))

            ],
          ),
        ),
      ),
    );
  }

  _spinCompleted() async {
    bool b = await ProfileBloc().insertSpinItem(widget.instTableID,selectedSpinItem?.id??0);
    if(b){
      Get.back(result: true);
    }
  }
}



