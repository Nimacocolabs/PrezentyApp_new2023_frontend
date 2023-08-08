
import 'package:event_app/screens/woohoo/card_balance_screen.dart';
import 'package:event_app/screens/hi_card/hi_card_balance_screen.dart';
import 'package:event_app/screens/woohoo/transaction_history_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputCardNoPinScreen extends StatefulWidget {
  final bool isCardBalance;
    final bool isHiCardBalanceCheck;

  const InputCardNoPinScreen({Key? key, required this.isCardBalance,required this.isHiCardBalanceCheck})
      : super(key: key);

  @override
  _InputCardNoPinScreenState createState() => _InputCardNoPinScreenState();
}

class _InputCardNoPinScreenState extends State<InputCardNoPinScreen> {
  TextFieldControl _textFieldControlCardNo = TextFieldControl();
  TextFieldControl _textFieldControlPin = TextFieldControl();
    TextFieldControl _textFieldControlHiCardNumber = TextFieldControl();
      TextFieldControl _textFieldControlHiCardPin = TextFieldControl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:
      //       Text(widget.isCardBalance ? 'Check Balance' : 'Get Transactions'),
      // ),
      appBar: CommonAppBarWidget(
        title: "${widget.isCardBalance ? 'Check Balance' : 'Get Transactions'}",
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              'To view your ${widget.isCardBalance ? 'card balance' : 'transaction history'}, enter the card number and the security code(PIN) on the back of your ${widget.isHiCardBalanceCheck? 'H! Card':'gift card'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            widget.isHiCardBalanceCheck?
AppTextBox(
              textFieldControl: _textFieldControlHiCardNumber,
              hintText: 'H! Card Number',
            ):

            AppTextBox(
              textFieldControl: _textFieldControlCardNo,
              hintText: 'Gift Card Number',
            ), 
            SizedBox(
              height: 8,
            ),
            widget.isHiCardBalanceCheck?
            AppTextBox(
              textFieldControl: _textFieldControlHiCardPin,
              hintText: 'H! card PIN number',
            )
           : AppTextBox(
              textFieldControl: _textFieldControlPin,
              hintText: 'Pin Number',
            ),
            SizedBox(
              height: 12,
            ),
            widget.isHiCardBalanceCheck?
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: (){
          _hiCardValidation();
            }, child: Text("Check H! card balance"))
          :  ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: _validate,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(widget.isCardBalance
                    ? 'Check Balance'
                    : 'Get Transactions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validate() async {
    if (_textFieldControlCardNo.controller.text.trim().isEmpty ) {
      toastMessage('Please provide your card number');
    } else if (_textFieldControlPin.controller.text.trim().isEmpty ) {
      toastMessage('Please provide your security pin');
    } else {
      if (widget.isCardBalance) {
        _getCardBalance();
      } 
      
      else {
        _getTransaction();
      }
    }
  }


_hiCardValidation()async {
if(_textFieldControlHiCardNumber.controller.text.trim().isEmpty){
 toastMessage('Please provide your H! card number'); 
}
else if( _textFieldControlHiCardPin.controller.text.trim().isEmpty){
   toastMessage('Please provide your H! card security pin');
}
else{
  _getHiCardBalance();
}
}




  _getCardBalance() async {
    //bool? b = await Get.to(()=>CardBalanceScreen(cardNo: _textFieldControlCardNo.controller.text.trim(), cardPin: _textFieldControlPin.controller.text.trim(), isHiCardBalanceDetails: false,));
bool? b = await Get.to(() =>  CardBalanceScreen(cardNo: _textFieldControlCardNo.controller.text.trim(), cardPin: _textFieldControlPin.controller.text.trim(), ));
    if(b??false){
      showRetryDialog(context, _getCardBalance);
    }
  }

 _getHiCardBalance() async {
    //bool? b = await Get.to(()=>CardBalanceScreen(cardNo: _textFieldControlHiCardNumber.controller.text.trim(), cardPin: _textFieldControlHiCardPin.controller.text.trim(), isHiCardBalanceDetails: true,),);
//bool? b = await  Get.to(() => CardBalanceScreen(cardNo: "", cardPin: "", isHiCardBalanceDetails: true, hiCardNo: _textFieldControlHiCardNumber.controller.text.trim(), hiCardPin: _textFieldControlHiCardPin.controller.text.trim()));
  
  
bool? b = await Get.to(() =>  HiCardBalanceScreen(hiCardNo:  _textFieldControlHiCardNumber.controller.text.trim(),hiCardPin: _textFieldControlHiCardPin.controller.text.trim(),));
    
    if(b??false){
      showRetryDialog(context, _getHiCardBalance);
    }
  }
  _getTransaction() async {
    bool? b = await Get.to(()=>TransactionHistoryScreen(cardNo: _textFieldControlCardNo.controller.text.trim(), cardPin: _textFieldControlPin.controller.text.trim()));

    if(b??false){
      showRetryDialog(context, _getTransaction);
    }
  }

}

showRetryDialog(BuildContext context, Function onRetry) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Text('Unable to complete request. Try again?'),
        actions: [
          OutlinedButton(
            child: Text('Cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () {
              Get.back();
              onRetry();
            },
          ),
        ],
      );
    },
  );
}
