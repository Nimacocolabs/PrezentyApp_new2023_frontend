import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PrizesTambolaScreen extends StatefulWidget {
  const PrizesTambolaScreen({Key? key, this.tambola_id}) : super(key: key);
  final tambola_id;
  @override
  State<PrizesTambolaScreen> createState() => _PrizesTambolaScreenState();
}

class _PrizesTambolaScreenState extends State<PrizesTambolaScreen> {
  Map reponse_prizes = {};
  List<dynamic>  listPrizes=[] ;


  Future getPrizesList() async {
    final response = await http.get(Uri.parse('https://b07d-117-201-128-139.ngrok-free.app/api/tambolas/prizes/${widget.tambola_id}/list'));
    print("Response${response.body}");
    var res = json.decode(response.body);
    reponse_prizes= res;
    listPrizes = reponse_prizes["prizes"];
    if (response.statusCode == 200) {
      _buildPrizeList(listPrizes);
    }
    else{
      throw Exception('Failed to load post');
    }
    return response;
  }
  @override
  Widget build(BuildContext context) {
    print("id-->${widget.tambola_id}");
    return Scaffold(
      appBar: CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
        title: "Prizes",
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Column(
          children: [
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: getPrizesList(),
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
                        return _buildPrizeList(listPrizes);
                      }
                    }
                  }),

          ],
        ),
            )),
      ),
    );
  }

  Widget _buildPrizeList(List prizes) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        padding: EdgeInsets.only(bottom: 8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: prizes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                  children: [
                    Text(
                      "Prize Name :${prizes[index]["prize_name"]}",
                      style: TextStyle(
                          fontSize: 15,fontWeight: FontWeight.w600
                      ),
                    ),
                   Spacer(),
                    Text(
                      "Type : ${prizes[index]["type"]}",
                      style: TextStyle(
                          fontSize: 15,fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Price : ${prizes[index]["price"]}",
                        style: TextStyle(
                            fontSize: 15,fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        "Number of prizes  : ${prizes[index]["no_of_prizes"]}",
                        style: TextStyle(
                            fontSize: 15,fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: prizes[index]["image_url"],
                    placeholder:
                        (context, url) =>
                        Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                    errorWidget:
                        (context, url, error) =>
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                              12),
                          child: Image(
                            image: AssetImage(
                                'assets/cards/hi_card.jpeg'),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
