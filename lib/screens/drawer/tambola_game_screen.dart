import 'dart:convert';
import 'dart:math';
import 'package:event_app/screens/drawer/prizes_tambola_screen.dart';
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
  int tambola_id = 0;
  int card_id=0;
  Map marked_api = {};
  bool isMarked = false;
  late List<dynamic> cardnumbers;
  // List MarkedNumbers_List = [];
  late List<dynamic> MarkedNumbers_List;
  @override
  void initState() {
    super.initState();
    print("initState called");
    getCardList();
    getLotteryList();
  }

  void markNumber(int number) {
    markedNumbers.add(number);
  }

  Future getCardList() async {
    print("Get order");
    final response = await http.get(
      Uri.parse('https://b07d-117-201-128-139.ngrok-free.app/api/tambolas/game'),
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
          'https://b07d-117-201-128-139.ngrok-free.app/api/tambolas/${tambola_id}/get-card?user_id=${User.userId}'));
      print("Response${joinresponse.body}");
      var join_response = json.decode(joinresponse.body);
      GameCard = join_response;
      print("JoinResponse--->${join_response}");
      cardnumbers = GameCard["card"];
      card_id = GameCard["card_id"];
      MarkedNumbers_List = GameCard["marked_numbers"];
      print("JoinResponse--->${cardnumbers}");
      if (GameCard['message'] == "Your tammbola card") {
        _buildGameBoard(cardnumbers, MarkedNumbers_List);
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
          'https://b07d-117-201-128-139.ngrok-free.app/api/tambolas/get-lottery-numbers'),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/images/prizes.png",
                    height: 40,
                    width: 40,
                  )),
              InkWell(
                onTap: () {
                  Get.to(() => PrizesTambolaScreen(tambola_id: tambola_id));
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "View Prizes",
                      style: TextStyle(color: primaryColor),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
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
                      }
                    }
                  }),
              SizedBox(height: 200),
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
                        return _buildGameBoard(cardnumbers, MarkedNumbers_List);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameBoard(List cardNumbers, List MarkedNumbers) {
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
            for (var row in cardNumbers)
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
                  print("number${number}");
                  bool isMarked = markedNumbers.contains(number);
                  int marked = MarkedNumbers[index];
                  print("marked${marked}");
                   bool isAlreadyMarked = markedNumbers.contains(marked);
                    isAlreadyMarked = true;
                    markedNumbers.add(marked);
                  List<int> combinedArray = [];
                  for (List<int> nestedArray in cardNumbers) {
                    combinedArray.addAll(nestedArray);
                    print("CardNumbers--->${combinedArray}");
                  }
                  bool allNumbersPresent = markedNumbers.every((number) {
                    return cardNumbers.any((cardList) => cardList.contains(number));
                  });
                  if (allNumbersPresent) {
                    print("All marked numbers are present in cardNumbers.");
                  } else {
                    print("Not all marked numbers are present in cardNumbers.");
                  }
                  return GestureDetector(
                    onTap: () async {
                      final String apiUrl =
                          'https://b07d-117-201-128-139.ngrok-free.app/api/tambolas/mark-numbers?tambola_id=${tambola_id}&user_id=${User.userId}&marked_number=${number}&card_id=${card_id}';
                      print("Url-->${apiUrl}");
                      var response = await http.post(
                        Uri.parse(apiUrl),
                      );
                      if (response.statusCode == 200) {
                        Fluttertoast.showToast(msg: "Number Marked");
                        var res = json.decode(response.body);
                        marked_api = res;
                        setState(() {
                          isMarked = true;
                          markedNumbers.add(number);
                        });
                        // isMarked = markedNumbers.contains(number);
                        // if (!isMarked) {
                        //   markNumber(number);
                        // }
                        print('Marked successfully');
                      } else {
                        Fluttertoast.showToast(msg: "It is not match");
                        print('Failed marked');
                      }

                    },
                    child:
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color:(isMarked || marked== number)? primaryColor :Colors.white
                          // int.parse(MarkedNumbers[index])== number
                        // isMarked  ? primaryColor : Colors.white ||
                        //color     MarkedNumbers.length==0 ? Colors.white : primaryColor,
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
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                number.toString(),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
