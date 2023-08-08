
import 'package:event_app/bloc/auth_bloc.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/fetch_cvv.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../test_screen.dart';
import '../util/app_helper.dart';

class SplashScreen extends StatefulWidget {
  final bool isFromLogout;

  const SplashScreen({Key? key, this.isFromLogout = false}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double iconWidth = 80;
  bool showProgress = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setScreenDimensions(context);
      // iconWidth = screenWidth * .2;
      // showProgress = true;
      // setState(() {});

      // SharedPreferences.setMockInitialValues({});

      if (User.apiToken.isEmpty) await SharedPrefs.init();
      await EventData.initPath();
      await SharedPrefs.init();
      showProgress = true;
      setState(() {});

      //todo remove
      // Get.off(()=>TestScreen());
      //  return;

      
      await AuthBloc().checkAppVersion(widget.isFromLogout);
     

      showProgress = false;
      setState(() {});

      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: AnimatedContainer(
                      width: iconWidth,
                      duration: Duration(milliseconds: 400),
                      child: Image.asset(
                        'assets/images/ic_logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 26,
                      width: 26,
                      child: showProgress
                          ? CircularProgressIndicator(strokeWidth: 3)
                          : SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Powered by',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            SizedBox(height: 8),
            InkWell(
              child: Image.asset(
                'assets/images/decentro image.png',
                width: 0.5,
                height: 15,
              ),
              //  onTap: () => launch("https://decentro.tech/"),

              //'Cocoalabs India Pvt Ltd',
              // 'DECENTRO',
              // textAlign: TextAlign.center,
              // style: TextStyle(
              //   fontWeight: FontWeight.w600,
            ),
            SizedBox(
              height: 16,
            ),
            FutureBuilder<String>(
                future: _getAppVersion(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  String version = '';
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData)
                    version = snapshot.data == null
                        ? ''
                        : 'Version : ${snapshot.data}';
                  return Text(
                    '$version',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                  );
                }),
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
