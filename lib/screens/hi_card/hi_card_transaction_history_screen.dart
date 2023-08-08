import 'package:event_app/screens/hi_card/redemption_history_screen.dart';
import 'package:event_app/screens/woohoo/input_card_no_pin_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class HICardTransactionScreen extends StatefulWidget {
  const HICardTransactionScreen({Key? key}) : super(key: key);

  @override
  State<HICardTransactionScreen> createState() => _HICardTransactionScreenState();
}

class _HICardTransactionScreenState extends State<HICardTransactionScreen> {
  TextFieldControl _textFieldControlHiCardNumber = TextFieldControl();
      TextFieldControl _textFieldControlHiCardPin = TextFieldControl();
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("H! Rewards Transaction History"),
      ),
      body: SafeArea(child: ListView(
        padding: EdgeInsets.all(12),
        children: [
  Text("To view your transaction history, enter the H! card number and the security PIN present on the back of your H! card.",
 style: TextStyle(fontSize: 16), ),
SizedBox(
              height: 12,
            ),

AppTextBox(
              textFieldControl: _textFieldControlHiCardNumber,
              hintText: 'H! Card Number',
            ),
 SizedBox(
              height: 8,
            ),
  
            AppTextBox(
              textFieldControl: _textFieldControlHiCardPin,
              hintText: 'H! card PIN number',
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: (){
                _validation();
              }, child: Text("Check H! card transactions"))
            
      ],)),
    );
  }

  _validation() async{
   
if(_textFieldControlHiCardNumber.controller.text.trim().isEmpty){
 toastMessage('Please provide your H! card number'); 
}
else if( _textFieldControlHiCardPin.controller.text.trim().isEmpty){
   toastMessage('Please provide your H! card security pin');
}
else{
  _getHICardTransaction();
}

  }

    _getHICardTransaction() async {
    bool? b = await Get.to(()=> HICardRedemptionHistoryScreen(hiCardNo: _textFieldControlHiCardNumber.controller.text.trim(),hiCardPin: _textFieldControlHiCardPin.controller.text.trim(),));

    if(b??false){
      showRetryDialog(context, _getHICardTransaction);
    }
  }
}