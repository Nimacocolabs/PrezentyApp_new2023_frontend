//
// import 'package:event_app/screens/event/choose_food_voucher_screen.dart';
// import 'package:event_app/screens/event/create_dummy_screen.dart';
// import 'package:event_app/util/app_helper.dart';
// import 'package:event_app/util/date_helper.dart';
// import 'package:event_app/util/event_data.dart';
// import 'package:event_app/widgets/event_details_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'choose_gift_or_vouchers_screen.dart';
// import 'template_category_list_screen.dart';
//
// class EventWizardMainScreen extends StatefulWidget {
//   const EventWizardMainScreen({Key? key}) : super(key: key);
//
//   @override
//   _EventWizardMainScreenState createState() => _EventWizardMainScreenState();
// }
//
// class _EventWizardMainScreenState extends State<EventWizardMainScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         padding: EdgeInsets.all(12),
//         children: [
//           Text(
//             EventData.title??'',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Icon(
//                   CupertinoIcons.calendar,
//                   color: primaryColor,
//                   size: 22,
//                 ),
//               ),
//               SizedBox(
//                 width: 8,
//               ),
//               Text(
//                   '${DateHelper.formatDateTime(EventData.dateTime!, 'dd-MMM-yyy')}'),
//               SizedBox(
//                 width: 20,
//               ),
//               Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: Icon(CupertinoIcons.time, color: primaryColor, size: 22),
//               ),
//               SizedBox(
//                 width: 8,
//               ),
//               Text(
//                   '${DateHelper.formatDateTime(EventData.dateTime!, 'hh:mm a')}'),
//             ],
//           ),
//           Divider(
//             height: 32,
//           ),
//
//           Row(
//             children: [
//               Expanded(
//                 child:
//                 EventDetailsButton(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset('assets/images/ic_templates.png',height: 50,width: 50,),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         Text(
//                           'Add Template',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.w500),
//                         )
//                       ],
//                     ),
//                     onTap:() async {
//                   await Get.to(()=>TemplateCategoryListScreen());
//                   setState(() {});
//                 }),
//               ),
//               SizedBox(
//                 width: 12,
//               ),
//               Expanded(
//                 child: EventDetailsButton(
//                     onTap: EventData.eventImageFilePath == null && EventData.eventVideoFilePath == null
//                         ? null
//                         : () {
//                       Get.to(()=>CreateDummyScreen());
//                           },
//                     child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset('assets/images/ic_gift_vouchers.png',height: 50,width: 50,),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             'Add Gift or Vouchers',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500),
//                           )
//                         ],
//                       ),
//                     ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 16,
//           ),
//       EventDetailsButton(
//               onTap: EventData.giftOrVoucherList==null
//                   ? null
//                   : () async {
//                 Get.to(()=>CreateDummyScreen());
//                 // await Get.to(()=>ChooseFoodVoucherScreen());
//                 //       setState(() {});
//                     },
//               child: Row(
//                   children: [
//                     Image.asset('assets/images/ic_foods.png',height: 50,width: 50,),
//                     SizedBox(
//                       width: 16,
//                     ),
//                     Text(
//                       'Choose Food or Gifts',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.w500),
//                     )
//                   ],
//                 ),
//               ),
//           SizedBox(
//             height: 16,
//           ),
//           Text(
//             'Live Stream',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//       EventDetailsButton(
//               onTap: null,
//               // EventData.foodVoucherList ==null
//               //     ? null
//               //     : () async {
//               //         //await Get.to(TemplateCategoryListScreen());
//                       // setState(() {});
//                     // },
//               child:  Row(
//                   children: [
//                     Image.asset('assets/images/ic_live.png',height: 70,width: 70,),
//                     SizedBox(
//                       width: 16,
//                     ),
//                     Expanded(
//                       child: Text(
//                         'Go Live',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     Image.asset('assets/images/ic_go_live.png',height: 50,width: 50,),
//                   ],
//                 ),
//           ),
//
//           // ElevatedButton(onPressed: (){Get.to(CreateEventPreviewScreen());}, child: Text('preview')),
//         ],
//       ),
//     );
//   }
// }
//
//
//
