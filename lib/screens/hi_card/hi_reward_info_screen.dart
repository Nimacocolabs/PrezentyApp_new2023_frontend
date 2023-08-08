import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/hi_card/hi_card_balance_model.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class HiRewardInfoScreen extends StatefulWidget {
  const HiRewardInfoScreen({Key? key}) : super(key: key);

  @override
  State<HiRewardInfoScreen> createState() => _HiRewardInfoScreenState();
}

class _HiRewardInfoScreenState extends State<HiRewardInfoScreen> {
  ProfileBloc _profileBloc = ProfileBloc();
  HiCardBalanceModel? hiCardDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       _profileBloc=ProfileBloc();
        getHiCardData();
    });
  }

 getHiCardData() async {
    hiCardDetails = await _profileBloc.getHICardBalance(User.userId);
    setState(() {});
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(),
bottomNavigationBar: CommonBottomNavigationWidget(),
body: SingleChildScrollView(child: Column(children: [
  Padding(padding: EdgeInsets.all(22),
  child: Column(children: [
    Center(
                 child: Text("Terms And Conditions",
                 style: TextStyle(
                  color:Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                 ),),
         
               ),
                       Divider(thickness: 1,),
  ],),
  ),
  hiCardDetails != null ?
  Padding(padding: const EdgeInsets.only(left: 8,right: 8,bottom: 12),
  child: Column(children: [
    HtmlWidget("${hiCardDetails?.data?.hiRewardTAndC}"),
  ],),) : Container(),
   
],),
),
    );
  }
}