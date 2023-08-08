
import 'package:event_app/screens/drawer/notification_screen.dart';
import 'package:event_app/screens/splash_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


import 'screens/main_screen.dart';
import 'util/notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Notifications.init();



  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {

    runApp(MyApp());
  });
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(    
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          canvasColor: Color(0xfff2f6fa),
          //fontFamily: "Ubuntu",
          //Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // dividerTheme: DividerThemeData(thickness: 1,),
          appBarTheme: Theme.of(context)
              .appBarTheme
              .copyWith(systemOverlayStyle: SystemUiOverlayStyle.dark), colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor).copyWith(secondary: secondaryColor)),
      routes: {
        // '/': (BuildContext context) => Test(),
        '/': (BuildContext context) => SplashScreen(),
        //  '/home': (BuildContext context) => HomeScreen(),
          '/home': (BuildContext context) => MainScreen(),
        '/notification'  :(BuildContext context) => NotificationScreen(),
        // '/createEventStart': (BuildContext context) => EventWizardMainScreen(),
      },
      initialRoute: '/',
    );
  }
}
