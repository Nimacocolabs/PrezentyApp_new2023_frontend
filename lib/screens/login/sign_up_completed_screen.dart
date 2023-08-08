import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bloc/wallet_bloc.dart';
import '../../models/check_scratchcard_valid_or_not_model.dart';
import '../../util/user.dart';
import '../../widgets/app_text_box.dart';
import '../prepaid_cards_wallet/apply_kyc_screen.dart';

class SignUpCompletedScreen extends StatefulWidget {
  const SignUpCompletedScreen({Key? key}) : super(key: key);

  @override
  State<SignUpCompletedScreen> createState() => _SignUpCompletedScreenState();
}

class _SignUpCompletedScreenState extends State<SignUpCompletedScreen> {

  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [primaryColor, secondaryColor],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8,),
                  Text("Hello,",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      )),
                  SizedBox(height: 4,),
                  Text('${User.userName}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              )),
              SizedBox(width: 12,),
              CircleAvatar(
                backgroundColor: Colors.black87,
                radius: 40,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                  '${User.userImageUrlValueNotifier.value}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Center(
                    child: Image(
                      image: AssetImage(
                        'assets/images/ic_avatar.png',
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16,),
              Text('Greetings from preZenty!',style: TextStyle( fontSize: 16,fontWeight: FontWeight.w500),),
              SizedBox(height: 4,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Get access to a new way to earn, save and spend for teens and young adults!',style: TextStyle (fontSize: 16,color: Colors.black54),),
              ),
              SizedBox(height: 40,),



          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(49, 249, 152, 0.8),
                  Color.fromRGBO(159, 20, 211, 0.9)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
            ),
          child: Column(
            children: [
              SizedBox(height: 16,),
              Text('Do you have a scratch card or coupon code?',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              SizedBox(height: 8,),
Padding(
  padding: const EdgeInsets.all(12.0),
  child:   Row(
    children: [
      Expanded(
        child:
        InkWell(
          onTap: (){
            Get.offAll(()=>MainScreen());
          },
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Container(
            width: 100,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white54,
                borderRadius: BorderRadius.circular(40.0)),
            child: Text(
              "No",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      SizedBox(width: 24,),
      Expanded(child:
      InkWell(
        onTap: _showBottomSheet,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        child: Container(
          width: 100,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(40.0)),
          child: Text(
            "Yes",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      ),
    ],
  ),
),
            ],
          ),
          ),

              SizedBox(height: 40,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('''
• Validate your Scratch/Gift card
• Complete eKYC with your PAN card
• Authenticate mobile number via OTP
• Terms & Conditions Apply''',style: TextStyle(color: Colors.black54,height: 1.4,fontWeight: FontWeight.w500),),
              )
            ],
          ),
        ),
      ],
    );
  }


  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  _showBottomSheet(){
    final Rx<TextFieldControl> _textFieldControlScartchCode =
        TextFieldControl().obs;
          final Rx<TextFieldControl> _textFieldControlReferralCode =
        TextFieldControl().obs;
bool    _isSuccess=false;

    Get.bottomSheet(
        Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
            children: [
              SizedBox(
                height: 16,
              ),
              Text("Enter Scratch card number or Coupon code",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                  true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(color: Colors.grey.shade200,//primaryColor.shade100,
                  borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: AppTextBox(
                    enabled: true,
                    padding: EdgeInsets.zero,
                    textFieldControl: _textFieldControlScartchCode.value,
                    hintText: 'Card Number or coupon code',
                    keyboardType: TextInputType.name,
                    textAlign:TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
               Text("Enter Referral Code",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                  true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(color: Colors.grey.shade200,//primaryColor.shade100,
                  borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: AppTextBox(
                    enabled: true,
                    padding: EdgeInsets.zero,
                    textFieldControl: _textFieldControlReferralCode.value,
                    hintText: 'Referral Code',
                    keyboardType: TextInputType.name,
                    textAlign:TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              StatefulBuilder(
                builder: (context,setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: _isSuccess?
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: (){}
                          , child: Icon(Icons.check)):
                      ElevatedButton(
                        onPressed: () async {
                      try{
                        if(_controllerCenter.state==ConfettiControllerState.playing){
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        String scratchCode = _textFieldControlScartchCode.value.controller.text;
                        String typedReferralCode = _textFieldControlReferralCode.value.controller.text;

                        if(scratchCode.trim().isEmpty){
                          toastMessage('Enter your scratch code');
                          return;
                        }

                        CheckScratchcardValidOrNotModel? scratchValidOrNot = await WalletBloc().getScratchCodeValidOrNot(User.userId,"",scratchCode,referralCode: typedReferralCode);
 if(scratchValidOrNot?.data?.type == "coupon"){
    // _applyCardApplyCouponCode(enteredCouponCode: scratchCode,enteredReferralCode: typedReferralCode);
    Get.to(() => ApplyPrepaidCardListScreen(isUpgrade: false,isFromSignUp: true,signupCouponCode: scratchCode,signupReferralCode: typedReferralCode,));
  }
   else if(scratchValidOrNot?.statusCode == 500){
    toastMessage("${scratchValidOrNot?.message}");
  }
                      else if(scratchValidOrNot!=null)
                        {
                          _isSuccess = true;
                          setState((){});
                          _controllerCenter.play();
                          await Future.delayed(Duration(seconds: 4));
                          Get.offAll(()=> ApplyKycScreen(
                              razorPayId: scratchValidOrNot.data?.rzrPayId,
                              cardId: scratchValidOrNot.data?.cardId??'',
                              firstName: "",
                              lastName: "",
                              panNumber: ""));
                        }
                        else{
                          toastMessage("Entered Coupon code is invalid");
                        }
                      }catch(e,s){
                        Completer().completeError(e, s);
                      }
                    }, child: Text("Continue")),
                  );
                }
              ),
            ]),
      ),
    ),
      enableDrag: true,
      isScrollControlled: false,
    );
  }
}
