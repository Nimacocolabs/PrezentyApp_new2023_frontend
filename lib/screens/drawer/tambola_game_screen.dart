import 'dart:convert';
import 'dart:math';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;

class TambolaGameScreen extends StatefulWidget {
  const TambolaGameScreen({Key? key}) : super(key: key);

  @override
  State<TambolaGameScreen> createState() => _TambolaGameScreenState();
}

class _TambolaGameScreenState extends State<TambolaGameScreen> {
  Set<int> markedNumbers = {};
  Random random = Random();
  List<int> calledNumbers = [];
  List lotterynumbers = [];
  Map tambolaId_response = {};
  Map GameCard = {};
  Map lottery_response = {};
  String success_msg = "";
  int tambola_id=0;
  late List<dynamic> cardnumbers;
  @override
  void initState() {
    super.initState();
    print("initState called");
    getCardList();
    getLotteryList();
  }

  // int generateRandomNumber() {
  //   int randomNumber;
  //   do {
  //     randomNumber = random.nextInt(90) + 1;
  //   } while (calledNumbers.contains(randomNumber));
  //   return randomNumber;
  // }

  void markNumber(int number) {
    setState(() {
      markedNumbers.add(number);
    });
  }

  // void callNumber() {
  //   int randomNumber = generateRandomNumber();
  //   setState(() {
  //     calledNumbers.add(randomNumber);
  //   });
  // }

  Future getCardList() async {
    print("Get order");
    final response = await http.get(
      Uri.parse('https://7477-61-3-70-109.ngrok-free.app/api/tambolas/game'),
      headers: <String, String>{
        'Accept': "appilication/json",
      },
    );
    var res = json.decode(response.body);
    tambolaId_response = res;
    success_msg = tambolaId_response["message"];
    tambola_id = tambolaId_response["tombala_id"];
    if (success_msg == "New tambola game Id") {
      final joinresponse = await http.get(Uri.parse(
          'https://7477-61-3-70-109.ngrok-free.app/api/tambolas/${tambola_id}/get-card?user_id=${User.userId}'));
      print("Response${joinresponse.body}");
      var join_response = json.decode(joinresponse.body);
      GameCard = join_response;
      print("JoinResponse--->${join_response}");
      cardnumbers = GameCard["card"];
      print("JoinResponse--->${cardnumbers}");
      if (GameCard['message'] == "Your tammbola card") {
        _buildGameBoard(cardnumbers);
      }
    } else {
      throw Exception('Failed');
    }
    return response;
  }

  Future getLotteryList() async {
    print("Get order");
    final response = await http.get(
      Uri.parse(
          'https://7477-61-3-70-109.ngrok-free.app/api/tambolas/get-lottery-numbers'),
      headers: <String, String>{
        'Accept': "appilication/json",
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      lotterynumbers = jsonResponse['lottery_numbers'];
      _buildGenerateBoard(
          lotterynumbers); // Pass the lottery numbers to the method
    } else {
      throw Exception('Failed');
    }
    return response;
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
              Text(
                "Your lucky numbers are here! ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              FutureBuilder(
                  future: getLotteryList(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Expanded(
                          child: Text("${snapshot.data}"),
                          flex: 1,
                        );
                      } else {
                        return _buildGenerateBoard(lotterynumbers);
                        ;
                      }
                    }
                  }),
              SizedBox(height: 260),
              FutureBuilder(
                  future: getCardList(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Expanded(
                          child: Text("${snapshot.data}"),
                          flex: 1,
                        );
                      } else {
                        return _buildGameBoard(cardnumbers);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }


  // Widget _buildGameBoard(List cardnumbers) {
  //   print("Length--->${cardnumbers}");
  //   return Card(
  //     elevation: 2,
  //     shadowColor: Colors.black,
  //     color: Colors.grey[100],
  //     shape: RoundedRectangleBorder(
  //       side: BorderSide(
  //         color: Colors.black38,
  //       ),
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: Column(
  //         children: [
  //           GridView.builder(
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 6,
  //               crossAxisSpacing: 4.0,
  //               mainAxisSpacing: 4.0,
  //             ),
  //             itemCount:18,
  //             shrinkWrap: true,
  //             itemBuilder: (BuildContext context, int index) {
  //               int number = index + 1;
  //               bool isMarked = markedNumbers.contains(number);
  //               bool isCalled = calledNumbers.contains(number);
  //               return GestureDetector(
  //                 onTap: () {
  //                   if (!isMarked) {
  //                     markNumber(number);
  //                   }
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.black),
  //                     color: isMarked ? primaryColor : (isCalled ? Colors.grey : Colors.white),
  //                   ),
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     number.toString(),
  //                     style: TextStyle(fontSize: 18),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGameBoard(List cardnumbers) {
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
            for (var row in cardnumbers)
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: row.length,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: row.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  int number = row[index];
                  bool isMarked = markedNumbers.contains(number);
                  // bool isCalled = calledNumbers.contains(number);
                  return GestureDetector(
                    onTap: () {
                      if (!isMarked) {
                        markNumber(number);
                      }
                      _marked(number);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: isMarked
                            ? primaryColor
                            : Colors.white,
                        // (isCalled ? Colors.grey : Colors.white),
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

  Widget _buildGenerateBoard(List generateNumbers) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black38,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: generateNumbers.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            int number = generateNumbers[index];
            return GestureDetector(
              onTap: () {
                // Handle tap event if needed
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  number.toString(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _marked(int number)async {
    print("dddd");
    // Map<String, dynamic> formData = {
    //   'tambola_id': tambola_id.toString(),
    //   'user_id': User.userId,
    //   'marked_number':number
    // };
    final String apiUrl = 'https://7477-61-3-70-109.ngrok-free.app/api/tambolas/mark-numbers?tambola_id=${tambola_id}&user_id=${User.userId}&marked_number=${number}';
    var response = await http.post(
      Uri.parse(apiUrl),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Number Marked");
      print('marked successfully');
    }
    else {
      Fluttertoast.showToast(msg: "It is not match");
      print('Failed marked');
    }
  }
}
