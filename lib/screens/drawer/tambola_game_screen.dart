import 'dart:math';

import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class TambolaGameScreen extends StatefulWidget {
  const TambolaGameScreen({Key? key}) : super(key: key);

  @override
  State<TambolaGameScreen> createState() => _TambolaGameScreenState();
}

class _TambolaGameScreenState extends State<TambolaGameScreen> {

  Set<int> markedNumbers = {};
  Random random = Random();
  List<int> calledNumbers = [];
  List<int> generateNumbers=[12,30,9,7,1,18];

  int generateRandomNumber() {
    int randomNumber;
    do {
      randomNumber = random.nextInt(90) + 1;
    } while (calledNumbers.contains(randomNumber));
    return randomNumber;
  }

  void markNumber(int number) {
    setState(() {
      markedNumbers.add(number);
    });
  }

  void callNumber() {
    int randomNumber = generateRandomNumber();
    setState(() {
      calledNumbers.add(randomNumber);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
        title: "Tambola Game",
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Your lucky numbers are here! ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(height: 15),
              _buildGenerateBoard(),
              SizedBox(height: 260),
              _buildGameBoard(),
              // ElevatedButton(
              //   onPressed: callNumber,
              //   child: Text('Call Number'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black38,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount:18,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                int number = index + 1;
                bool isMarked = markedNumbers.contains(number);
                bool isCalled = calledNumbers.contains(number);
                return GestureDetector(
                  onTap: () {
                    if (!isMarked) {
                      markNumber(number);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: isMarked ? primaryColor : (isCalled ? Colors.grey : Colors.white),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      number.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateBoard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
       color: Colors.white,
      // color: primaryColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black38,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount:generateNumbers.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                // int number = index + 1;
                // bool isMarked = markedNumbers.contains(number);
                // bool isCalled = calledNumbers.contains(number);
                return GestureDetector(
                  onTap: () {
                    // if (!isMarked) {
                    //   markNumber(number);
                    // }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        // color: isMarked ? Colors.blue : (isCalled ? Colors.grey : Colors.white),
                      color: primaryColor
                        // color: Colors.grey
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      generateNumbers[index].toString(),
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
