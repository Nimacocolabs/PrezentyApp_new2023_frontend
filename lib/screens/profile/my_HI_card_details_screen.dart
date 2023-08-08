import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/hi_card/hi_card_balance_model.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHICardDetailsScreen extends StatefulWidget {
  const MyHICardDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MyHICardDetailsScreen> createState() => _MyHICardDetailsScreenState();
}

class _MyHICardDetailsScreenState extends State<MyHICardDetailsScreen> {
  ProfileBloc _profileBloc = ProfileBloc();
  HiCardBalanceModel? hiCardData;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      _profileBloc = ProfileBloc();
    await getHiCardData();
    });
  }
 Future getHiCardData() async {
    hiCardData = await _profileBloc.getHICardBalance(User.userId);
    
    setState(() {});
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
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("My H! Reward Details",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18)),
            ),
            Divider(
              thickness: 2,
            ),
            detailsCard(
                icon: Icons.credit_card,
                title: "Card Number",
                subTitle:"${User.userHiCardNo}" 
                ),
            SizedBox(
              height: 3,
            ),
            detailsCard(
                icon: Icons.pin_outlined,
                title: "PIN ",
                subTitle: "${User.userHiCardPin}"
                ),
            SizedBox(
              height: 3,
            ),
            detailsCard(
              icon: Icons.money, 
              title: "H! Rewards",
               subTitle: "${User.userHiCardBalance}"),
                SizedBox(
              height: 3,
            ),
             detailsCard(
              icon: Icons.analytics_rounded , 
              title: "Serial Number",
               subTitle: "${hiCardData?.data?.serialNumber ?? ""}"),
          
                SizedBox(
              height: 3,
            ),
             detailsCard(
              icon: Icons.account_balance_outlined, 
              title: "RFID",
               subTitle: "${hiCardData?.data?.rfidNumber}"),
          ],
        ),
      )),
    );
  }

  detailsCard({
    required IconData icon,
    required String title,
    required String subTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: primaryColor,
                      size: 28,
                    ),
                    SizedBox(width: 10, height: 30),
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 38,
                  ),
                  child: Text(subTitle),
                )
              ]),
        ),
      ),
    );
  }
}
