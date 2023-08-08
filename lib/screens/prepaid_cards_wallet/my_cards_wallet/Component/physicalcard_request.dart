// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../../../../util/app_helper.dart';

// class RequestPhysicalCard extends StatefulWidget {
//   const RequestPhysicalCard({Key? key}) : super(key: key);

//   @override
//   State<RequestPhysicalCard> createState() => _RequestPhysicalCardState();
// }

// class _RequestPhysicalCardState extends State<RequestPhysicalCard> {
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();
//   final TextEditingController statecodeController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         leading: const BackButton(),
//         actions: [
//           GestureDetector(
//             child: const Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Icon(Icons.home_outlined),
//             ),
//           ),
//         ],
//       ),
//       bottomSheet: Container(
//         width: screenWidth,
//         height: 30,
//         color: primaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10),
//                 Text(
//                   "Request Physical Card",
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87),
//                 ),

//                 SizedBox(
//                   height: 20,
//                 ),
//                 _textField(textController: addressController,
//                     hint: "Enter address",
//                     line: 5),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 _textField(textController: pincodeController,
//                     hint: "Enter pincode",
//                     line: 1),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 _textField(textController: stateController,
//                     hint: "Enter city",
//                     line: 2),
//                 SizedBox(
//                   height: 20,
//                 ),

//                 _textField(textController: statecodeController,
//                     hint: "Enter statecode",
//                     line: 1),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   onPressed:(){
//                     print("Submit button pressed ");
//                   },
//                   style: TextButton.styleFrom(
//                     backgroundColor: secondaryColor,
//                   ),
//                   child: Text("Submit",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }

//   _textField(
//       {TextEditingController? textController, String? hint, int line = 1}) {
//     return TextField(
//       keyboardType: TextInputType.text,
//       controller: textController,
//       maxLines: line,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: primaryColor,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: primaryColor,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: primaryColor,
//             width: 3,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }
