import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrizesTambolaScreen extends StatefulWidget {
  const PrizesTambolaScreen({Key? key}) : super(key: key);

  @override
  State<PrizesTambolaScreen> createState() => _PrizesTambolaScreenState();
}

class _PrizesTambolaScreenState extends State<PrizesTambolaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        title: "Prizes",
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ListView.builder(
              padding: EdgeInsets.only(bottom: 8),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Titile",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset("assets/cards/hi_card.jpeg"),
                      ],
                    ),
                  ),
                );
              }),
        ],
      )),
    );
  }
}
