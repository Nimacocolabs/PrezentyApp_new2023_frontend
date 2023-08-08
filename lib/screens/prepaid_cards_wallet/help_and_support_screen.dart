
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  @override
  _HelpAndSupportScreenState createState() => _HelpAndSupportScreenState();

}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {


  @override
  void initState() {
    super.initState();

 
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
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [

          Text(
            'For Support/Enquiries',
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
                      await launchUrl( Uri.parse(termsAndConditionsCardUrl),mode: LaunchMode.externalApplication);
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
          )],
            ),
         ] ),
      ),
      ]),
   
    
    );
    
  }


}
