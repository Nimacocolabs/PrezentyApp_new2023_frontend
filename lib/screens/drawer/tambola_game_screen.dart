import 'dart:async';
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
import 'package:timer_builder/timer_builder.dart';

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
  int card_id = 0;
  int num = 0;
  Map marked_api = {};
  String tambola_baseUrl = "https://www.prezenty.in/prezentycards-live/public";
  int marked_eachnumber = 0;
  bool isMarked = false;
  late List<dynamic> cardnumbers;
  // List MarkedNumbers_List = [];
  late List<dynamic> MarkedNumbers_List;
  List<dynamic> matchingNumbers = [];
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
      Uri.parse(
          'https://www.prezenty.in/prezentycards-live/public/api/tambolas/game'),
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
          'https://www.prezenty.in/prezentycards-live/public/api/tambolas/${tambola_id}/get-card?user_id=${User.userId}'));
      print("Response${joinresponse.body}");
      var join_response = json.decode(joinresponse.body);
      GameCard = join_response;
      print("JoinResponse--->${join_response}");
      cardnumbers = GameCard["card"];
      card_id = GameCard["card_id"];
      MarkedNumbers_List = GameCard["marked_numbers"];
      print("JoinResponse--->${MarkedNumbers_List}");
      if (GameCard['message'] == "Your tammbola card") {
        _buildGameBoard(
          cardnumbers,
        );
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
          'https://www.prezenty.in/prezentycards-live/public/api/tambolas/get-lottery-numbers'),
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

  // Future claim_row() async {
  //   Map<String, dynamic> myParameters = {
  //     'type': 'row',
  //     'win_numbers': '[18,14,13,15,18,16]',
  //     'user_id': '${User.userId}',
  //     'tambola_id': '${tambola_id}',
  //     'tambola_card_id': '${card_id}'
  //   };
  //   String jsonString = json.encode(myParameters);
  //
  //   final response = await http.post(
  //     Uri.parse(
  //         'https://c7f7-61-3-117-253.ngrok-free.app/api/tambolas/prizes/claim-row-prize'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonString,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Response data: ${response.body}');
  //     print("Success");
  //     Fluttertoast.showToast(msg: "You win");
  //   } else {
  //     print('Request failed with status code: ${response.statusCode}');
  //   }
  // }

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
                        return _buildGameBoard(
                          cardnumbers,
                        );
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  bool isRowCompleted(List<dynamic> row, Set<dynamic> markedNumbers) {
    // Check if all numbers in the row are marked with a primary color
    return row.every((number) => markedNumbers.contains(number));
  }
  Widget _buildGameBoard(List <dynamic>cardNumbers) {
   List<dynamic> primaryColorRows = [];
    return Column(
      children: [
        Card(
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
                      bool isMarked = markedNumbers.contains(number);
                      List<dynamic> combinedArray = [];
                      for (List<dynamic> nestedArray in cardNumbers) {
                        combinedArray.addAll(nestedArray);
                      }
                      bool isPrimaryColor = matchingNumbers.contains(number);

                      // If the number is a matching number, add it to an array
                      if (isPrimaryColor) {
                        primaryColorRows.add(number);
                      }
                      return GestureDetector(
                        onTap: () async {
                          final String apiUrl =
                              'https://www.prezenty.in/prezentycards-live/public/api/tambolas/mark-numbers?tambola_id=${tambola_id}&user_id=${User.userId}&marked_number=${number}&card_id=${card_id}';
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
                            isMarked = markedNumbers.contains(number);
                            if (!isMarked) {
                              markNumber(number);
                            }
                            print('Marked successfully');
                          } else {
                            Fluttertoast.showToast(msg: "It is not match");
                            print('Failed marked');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: matchingNumbers.contains(number)
                                ? primaryColor
                                : (isMarked ? primaryColor : Colors.white),
                            // Change the color to red if the number is in matchingNumbers
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
        ),
        TextButton(onPressed: (){
          showAlertDialog(context,cardNumbers);
        }, child: Text("Claim Row"))
      ],
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
  showAlertDialog(BuildContext context, List cardNumbers,) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Claim Your Prize"),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            TextButton(onPressed: () async{
                Map<String, dynamic> myParameters = {
                  'type': 'row',
                  'win_numbers': '${cardnumbers[0]}',
                  'user_id': '${User.userId}',
                  'tambola_id': '${tambola_id}',
                  'tambola_card_id': '${card_id}'
                };
                String jsonString = json.encode(myParameters);
                 print("json=>${jsonString}");
                final response = await http.post(
                  Uri.parse(
                      '${tambola_baseUrl}/api/tambolas/prizes/claim-row-prize'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                  body: jsonString,
                );


                if (response.statusCode == 200) {
                  print('Response data: ${response.body}');
                  print("Success");
                  Fluttertoast.showToast(msg: "You win");
                } else {
                  print('Request failed with status code: ${response.statusCode}');
                }
            },child: Text("First Row Claim")),
            TextButton(onPressed: () async{
        Map<String, dynamic> myParameters = {
          'type': 'row',
          'win_numbers': '${cardnumbers[1]}',
          'user_id': '${User.userId}',
          'tambola_id': '${tambola_id}',
          'tambola_card_id': '${card_id}'
        };
        String jsonString = json.encode(myParameters);
        print("json=>${jsonString}");
        final response = await http.post(
          Uri.parse(
              '${tambola_baseUrl}/api/tambolas/prizes/claim-row-prize'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonString,
        );


        if (response.statusCode == 200) {
          print('Response data: ${response.body}');
          print("Success");
          Fluttertoast.showToast(msg: "You win");
        } else {
          print('Request failed with status code: ${response.statusCode}');
        }
    },child: Text("Second Row Claim")),
            TextButton(onPressed: () async{
    Map<String, dynamic> myParameters = {
    'type': 'row',
    'win_numbers': '${cardnumbers[2]}',
    'user_id': '${User.userId}',
    'tambola_id': '${tambola_id}',
    'tambola_card_id': '${card_id}'
    };
    String jsonString = json.encode(myParameters);
    print("json=>${jsonString}");
    final response = await http.post(
    Uri.parse(
    '${tambola_baseUrl}/api/tambolas/prizes/claim-row-prize'),
    headers: <String, String>{
    'Content-Type': 'application/json',
    },
    body: jsonString,
    );


    if (response.statusCode == 200) {
    print('Response data: ${response.body}');
    print("Success");
    Fluttertoast.showToast(msg: "You win");
    } else {
    print('Request failed with status code: ${response.statusCode}');
    }
    },child: Text("Third Row Claim")),


          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
