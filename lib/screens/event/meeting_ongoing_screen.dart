// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:crypto/crypto.dart';
// import 'package:event_app/screens/splash_screen.dart';
// import 'package:event_app/util/app_helper.dart';
// import 'package:event_app/util/shared_prefs.dart';
// import 'package:event_app/util/user.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
//
// class MeetingOngoingScreen extends StatefulWidget {
//   final bool isFromNotification;
//   final int eventId;
//   final String eventTitle;
//   const MeetingOngoingScreen({Key? key, this.isFromNotification=false, required this.eventId, required this.eventTitle}) : super(key: key);
//
//   @override
//   _MeetingOngoingScreenState createState() => _MeetingOngoingScreenState();
// }
//
// class _MeetingOngoingScreenState extends State<MeetingOngoingScreen> {
//
//   String userEmail='',userName='';
//
//   setUserFromSp(){
//     if(User.apiToken.isEmpty){
//     //   //todo check
//     //   List<GuestUserParticipation> guestUserParticipationList = SharedPrefs.getGuestUserParticipationList();
//     //   for(GuestUserParticipation element in guestUserParticipationList){
//     //     if(widget.eventId == element.eventId){
//     //       userEmail = element.email;
//     //       userName = 'User_${Random().nextInt(1000)}';
//     //       break;
//     //     }
//     //   }
//     }
//     if(userEmail.isEmpty) {
//       userEmail = 'User';
//       userName = 'User_${Random().nextInt(1000)}';
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
//
//       if(User.apiToken.isEmpty){
//         await SharedPrefs.init();
//       }
//       if(User.apiToken.isEmpty){
//         setUserFromSp();
//       }else{
//         userEmail = User.userEmail;
//         userName = User.userName;
//       }
//
//       // JitsiMeet.addListener(JitsiMeetingListener(
//       //     onConferenceWillJoin: _onConferenceWillJoin,
//       //     onConferenceJoined: _onConferenceJoined,
//       //     onConferenceTerminated: _onConferenceTerminated,
//       //     onError: _onError));
//
//       _joinMeeting();
//     });
//   }
//
//   @override
//   void dispose() {
//     JitsiMeet.removeAllListeners();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: SizedBox(),
//         actions: [
//           CloseButton(
//             color: secondaryColor,
//           ),
//         ],
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: WillPopScope(
//         onWillPop: ()async{
//           return false;
//         },
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                 'assets/images/ic_go_live.png',
//                 height: 60,
//                 width: 60,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 'Live stream ongoing..',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: primaryColor),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _joinMeeting() async {
//     String? serverUrl;
//
//     // Enable or disable any feature flag here
//     // If feature flag are not provided, default values will be used
//     // Full list of feature flags (and defaults) available in the README
//     Map<FeatureFlagEnum, bool> featureFlags = {
//       FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
//     };
//     if (!kIsWeb) {
//       // Here is an example, disabling features for each platform
//       if (Platform.isAndroid) {
//         // Disable ConnectionService usage on Android to avoid issues (see README)
//         featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
//       } else if (Platform.isIOS) {
//         // Disable PIP on iOS as it looks weird
//         featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
//       }
//     }
//     // Define meetings options here
//     String subject= widget.eventTitle;
//     String userDisplayName = userName;
//     String emailId= userEmail;
//     String iosAppBarRGBAColor='#0080FF80';
//     String roomName=_getRoomId();
//     var options = JitsiMeetingOptions(room: roomName)
//       ..serverURL = serverUrl
//       ..subject = subject
//       ..userDisplayName = userDisplayName
//       ..userEmail = emailId
//       ..iosAppBarRGBAColor = iosAppBarRGBAColor
//       ..audioOnly = true
//       ..audioMuted = true
//       ..videoMuted = true
//       ..featureFlags.addAll(featureFlags)
//       ..webOptions = {
//         "roomName": roomName,
//         "width": "100%",
//         "height": "100%",
//         "enableWelcomePage": false,
//         "chromeExtensionBanner": null,
//         "userInfo": {"displayName": userName}
//       };
//
//     debugPrint("JitsiMeetingOptions: $options");
//     await JitsiMeet.joinMeeting(
//       options,
//       listener: JitsiMeetingListener(
//           onConferenceWillJoin: _onConferenceWillJoin,
//           onConferenceJoined: _onConferenceJoined,
//           onConferenceTerminated: _onConferenceTerminated,
//           onError: _onError,
//           genericListeners: [
//             JitsiGenericListener(
//                 eventName: 'readyToClose',
//                 callback: (dynamic message) {
//                   debugPrint("readyToClose callback");
//                 }),
//           ]),
//     );
//   }
//
//   String _getRoomId() {
//     return md5.convert(utf8.encode('event:${widget.eventId}')).toString();
//   }
//
//   void _onConferenceWillJoin(message) {
//     debugPrint("_onConferenceWillJoin broadcasted with message: $message");
//   }
//
//   void _onConferenceJoined(message) {
//     debugPrint("_onConferenceJoined broadcasted with message: $message");
//   }
//
//   void _onConferenceTerminated(message) {
//     if(widget.isFromNotification){
//       Get.offAll(()=>SplashScreen());
//     }else{
//       Get.back();
//     }
//     debugPrint("_onConferenceTerminated broadcasted with message: $message");
//   }
//
//   _onError(error) {
//     debugPrint("_onError broadcasted: $error");
//   }
//
// }