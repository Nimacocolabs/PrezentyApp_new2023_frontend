
import 'package:event_app/bloc/profile_bloc.dart';

import 'package:event_app/util/app_helper.dart';

import 'package:flutter/material.dart';

import '../../models/hi_card/check_hi_card_balance_model.dart';


class HiCardBalanceScreen extends StatefulWidget {
    final String hiCardNo;
  final String hiCardPin;
  const HiCardBalanceScreen({Key? key,required this.hiCardNo,required this.hiCardPin}) : super(key: key);

  @override
  State<HiCardBalanceScreen> createState() => _HiCardBalanceScreenState();
}

class _HiCardBalanceScreenState extends State<HiCardBalanceScreen> {
ProfileBloc _profileBloc =ProfileBloc();
CheckHiCardBalanceModel? hiCardaBlanceData;
 

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getHiCardBalance();
    });
  }

 getHiCardBalance() async {
    hiCardaBlanceData = await _profileBloc.checkHiCardBalance(widget.hiCardNo,widget.hiCardPin);
    
   
setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  
),
body: SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
       Padding(
  padding: const EdgeInsets.all(20.0),
  child:   Center(
    child: Text("H! Rewards Balance",
    style: TextStyle(

      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20
    ),),
  ),
),
Divider(
  thickness: 2,
),
      Stack(
        children: [
         
          SizedBox(
            height: 120,
          ),
          ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      image: AssetImage(
                          "assets/cards/hi_card_blank.jpg"),
                      width: double.infinity,
                      height: screenHeight * 0.3,
                      fit: BoxFit.fill,
                    ),
                  ),

                  Positioned(
                    left: 30,
                    top:30,
                    child: Text("${widget.hiCardNo }",
        style: TextStyle(
          color: Colors.white,
             fontSize: 24, fontWeight: FontWeight.w600
        ), ),),
        Positioned(
          right: 60,
          top: 190,
          child: Text("PIN: ${widget.hiCardPin }",
     style: TextStyle(
      color: Colors.white,
             fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      Positioned(
       right:45,
        top: 150,
        child: 
      Text("Balance: ${hiCardaBlanceData?.data?.balance ??""}",
             style: TextStyle(
              color: Colors.white,
               fontSize: 20, fontWeight: FontWeight.w600)
             ),
      )
        ],
      )
  
           
    ],
  )),
    );
  }
}