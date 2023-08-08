import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextFieldControl _textFieldControlMessage = TextFieldControl();
  TextFieldControl _textFieldControlEmail = TextFieldControl();
  TextFieldControl _textFieldControlPhone = TextFieldControl();
  TextFieldControl _textFieldControlName = TextFieldControl();

  @override
  void initState() {
    super.initState();

    _textFieldControlName.controller.text = User. userName;
    _textFieldControlEmail.controller.text = User. userEmail;
    _textFieldControlPhone.controller.text = User. userMobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [

          Text(
            'Feedback/Query',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  autofocus: false,
                  controller: _textFieldControlName.controller,
                  focusNode: _textFieldControlName.focusNode,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                  autofocus: false,
                    controller: _textFieldControlEmail.controller,
                    focusNode: _textFieldControlEmail.focusNode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                  autofocus: false,
                    controller: _textFieldControlPhone.controller,
                    focusNode: _textFieldControlPhone.focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)],
                    decoration: InputDecoration(
                      // prefixIcon: Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 0),
                      //   child: Text('+91', style: TextStyle(fontSize: 16, color: Colors.black)),
                      // ),
                      hintText: 'Phone',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                  autofocus: false,
                    controller: _textFieldControlMessage.controller,
                    focusNode: _textFieldControlMessage.focusNode,
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 8,
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      // disabledBorder: InputBorder.none,
                      // enabledBorder: InputBorder.none,
                      // errorBorder: InputBorder.none,
                      // focusedBorder: InputBorder.none,
                      // focusedErrorBorder: InputBorder.none,
                      hintText: 'Type message here..',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: _validate,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Send'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 50,
          ),

          Text(
            'For Support/Enquiries',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          InkWell(
            onTap: () async {
              String uri = 'tel:0091 6235 006 006';
              if (await canLaunchUrl(Uri.parse(uri))) {
                await launchUrl(Uri.parse(uri));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.call_rounded,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Call ( Monday to Saturday 9 am to 5pm IST)',
                          style: TextStyle(color: Colors.black45),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '0091 6235 006 006',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Divider(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String uri = 'mailto:support@prezenty.in';
              if (await canLaunchUrl(Uri.parse(uri))) {
                await launchUrl(Uri.parse(uri));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.email_rounded,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(color: Colors.black45),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text('support@prezenty.in',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: 12,
                      ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Corporate office/Communication address',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text('''
Prezenty Infotech Private Limited
26 S R T Road, Shivajinagar, Bangalore,
Karnataka,
India-560062''',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        )),
                    SizedBox(
                      height: 12,
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                )),
              ],
            ),
          ),

          InkWell(
            onTap: () async {
              String uri = 'https://prezenty.in/Faq';
              if (await canLaunchUrl(Uri.parse(uri))) {
                await launchUrl(Uri.parse(uri));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.contact_support,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Frequently asked questions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(termsAndConditionsCardUrl))) {
                      await launchUrl(Uri.parse(termsAndConditionsCardUrl),mode: LaunchMode.externalApplication);
                    } else {
                      toastMessage('Unable to open url $termsAndConditionsUrl');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Terms & conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(privacyPolicyUrl))) {
                      await launchUrl(Uri.parse(privacyPolicyUrl),mode: LaunchMode.externalApplication);
                    } else {
                      toastMessage('Unable to open url $privacyPolicyUrl');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Privacy policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _validate() async {
    String text = _textFieldControlMessage.controller.text.trim();
    String name = _textFieldControlName.controller.text.trim();
    String email = _textFieldControlEmail.controller.text.trim();
    String phone = _textFieldControlPhone.controller.text.trim();


    if(!name.isValidName()){
      toastMessage('Name should contain only alphabets and spaces');
      _textFieldControlName.focusNode.requestFocus();
    }else if(!email.isValidEmail()){
      toastMessage('Enter a valid email id');
      _textFieldControlEmail.focusNode.requestFocus();
    }else if(!phone.isValidMobileNumber()){
      toastMessage('Enter a valid phone number');
      _textFieldControlPhone.focusNode.requestFocus();
    } else if(text.isEmpty){
      toastMessage('Enter a message');
      _textFieldControlMessage.focusNode.requestFocus();
    }else{
      bool b = await EventBloc().sendFeedbackMessage(User.userId, name,email,phone,text);
      if (b) {
        setState(() {
          _textFieldControlMessage.controller.text = '';
          _textFieldControlName.controller.text = User. userName;
          _textFieldControlEmail.controller.text = User. userEmail;
          _textFieldControlPhone.controller.text = User. userMobile;
        });
      }
    }
  }
}
