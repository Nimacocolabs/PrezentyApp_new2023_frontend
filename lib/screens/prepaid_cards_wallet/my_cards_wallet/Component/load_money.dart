// import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_tabs.dart';
// import 'package:event_app/util/app_helper.dart';
// import 'package:event_app/util/user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class LoadMoney extends StatefulWidget {
//   const LoadMoney({Key? key}) : super(key: key);
//
//   @override
//   State<LoadMoney> createState() => _LoadMoneyState();
// }
//
// enum PaymentMethod { net, debit, upi }
//
// class _LoadMoneyState extends State<LoadMoney> {
//   WalletTab wT = WalletTab();
//
//   @override
//   void initState() {
//     _officialValidDoc = 0;
//     _validDocNumber.text.isNotEmpty ? _validDocNumber.text = "" : null;
//     amountControl.text.isNotEmpty ? _validDocNumber.text = "" : null;
//     loadMoney = false;
//     selectPaymentMethod = false;
//     amountEntered = false;
//     super.initState();
//   }
//
//   final _formKey = GlobalKey<FormState>();
//   int? _officialValidDoc = 0;
//   String? officialValidDoc = "Select";
//   final _validDocNumber = TextEditingController();
//   bool loadMoney = false;
//   bool amountEntered = false;
//   final amountControl = TextEditingController();
//   bool selectPaymentMethod = false;
//   PaymentMethod _paymentMethod = PaymentMethod.net;
//   final _cardNumberControl = TextEditingController();
//   final _cardExpDateControl = TextEditingController();
//   final _cardCVVControl = TextEditingController();
//   final _cardNameControl = TextEditingController();
//   static final RegExp _alphaRegExp = RegExp('[a-zA-Z]');
//   static final RegExp _numericRegExp = RegExp('[0-9]');
//   static final RegExp _alphanumericRegExp = new RegExp(r'^[a-zA-Z0-9]+$');
//   @override
//   Widget build(BuildContext context) {
//     return loadMoney != true
//         ? _loadMoney()
//         : loadMoney == true && amountEntered != true
//             ? _loadMoneyAmount()
//             : amountEntered == true
//                 ? _loadMoneyPayment()
//                 : Container();
//   }
//
//   Widget _loadMoneyPayment() {
//     return Card(
//       child:
//           Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
//               Widget>[
//         ListTile(
//           title: const Text('Net Banking'),
//           leading: Radio(
//             activeColor: primaryColor,
//             value: PaymentMethod.net,
//             groupValue: _paymentMethod,
//             onChanged: (PaymentMethod? value) {
//               setState(() {
//                 _paymentMethod = value!;
//               });
//             },
//           ),
//           trailing: _paymentMethod == PaymentMethod.net
//               ? Icon(Icons.arrow_drop_up_outlined)
//               : Icon(Icons.arrow_drop_down_outlined),
//         ),
//         ListTile(
//           title: const Text('Credit/Debit'),
//           leading: Radio(
//             activeColor: primaryColor,
//             value: PaymentMethod.debit,
//             groupValue: _paymentMethod,
//             onChanged: (PaymentMethod? value) {
//               setState(() {
//                 _paymentMethod = value!;
//               });
//             },
//           ),
//           trailing: _paymentMethod == PaymentMethod.debit
//               ? Icon(Icons.arrow_drop_up_outlined)
//               : Icon(Icons.arrow_drop_down_outlined),
//         ),
//         _paymentMethod == PaymentMethod.debit
//             ? Padding(
//                 padding: const EdgeInsets.only(right: 20, left: 20.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         controller: _cardNumberControl,
//                         validator: (value) {
//                           return value!.isEmpty || value.length != 16
//                               ? "Enter 16 digit Card number"
//                               : null;
//                         },
//                         keyboardType: TextInputType.number,
//                         cursorHeight: 24,
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                         decoration: InputDecoration(
//                           hintText: "card number",
//                           contentPadding: EdgeInsets.only(left: 10, right: 10),
//                           enabledBorder: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                           border: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         controller: _cardExpDateControl,
//                         validator: (value) {
//                           return value!.isEmpty ? "Enter valid Date" : null;
//                         },
//                         keyboardType: TextInputType.datetime,
//                         cursorHeight: 24,
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                         decoration: InputDecoration(
//                           hintText: "Expiry Date",
//                           contentPadding: EdgeInsets.only(left: 10, right: 10),
//                           enabledBorder: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                           border: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         controller: _cardCVVControl,
//                         validator: (value) {
//                           return value!.isEmpty ? "Enter valid CVV" : null;
//                         },
//                         keyboardType: TextInputType.number,
//                         cursorHeight: 24,
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                         decoration: InputDecoration(
//                           hintText: "CVV",
//                           contentPadding: EdgeInsets.only(left: 10, right: 10),
//                           enabledBorder: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                           border: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextFormField(
//                         controller: _cardNameControl,
//                         validator: (value) {
//                           return value!.isEmpty
//                               ? "Enter valid Card Name"
//                               : null;
//                         },
//                         keyboardType: TextInputType.text,
//                         cursorHeight: 24,
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                         decoration: InputDecoration(
//                           hintText: "Name of Card",
//                           contentPadding: EdgeInsets.only(left: 10, right: 10),
//                           enabledBorder: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                           border: OutlineInputBorder(
//                               gapPadding: 0,
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide:
//                                   BorderSide(width: 2, color: primaryColor)),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Center(
//                           child: TextButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {}
//                         },
//                         child: Text(
//                           "Proceed to Pay",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         style: TextButton.styleFrom(
//                           backgroundColor: secondaryColor,
//                           fixedSize: Size(screenWidth, 50),
//                         ),
//                       ))
//                     ],
//                   ),
//                 ),
//               )
//             : Container(),
//         ListTile(
//           title: const Text('UPI'),
//           leading: Radio(
//             activeColor: primaryColor,
//             value: PaymentMethod.upi,
//             groupValue: _paymentMethod,
//             onChanged: (PaymentMethod? value) {
//               setState(() {
//                 _paymentMethod = value!;
//               });
//             },
//           ),
//           trailing: _paymentMethod == PaymentMethod.upi
//               ? Icon(Icons.arrow_drop_up_outlined)
//               : Icon(Icons.arrow_drop_down),
//         ),
//         _paymentMethod == PaymentMethod.upi
//             ? Padding(
//                 padding: const EdgeInsets.only(left: 20.0, right: 20),
//                 child: Center(
//                     child: TextButton(
//                   onPressed: () {
//                     //if (_formKey.currentState!.validate()) {
//
//                     // }
//                   },
//                   child: Text(
//                     "Proceed to Pay",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   style: TextButton.styleFrom(
//                     backgroundColor: secondaryColor,
//                     fixedSize: Size(screenWidth, 50),
//                   ),
//                 )),
//               )
//             : Container()
//       ]),
//     );
//   }
//
//   Widget _loadMoneyAmount() {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Current Balance",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87),
//               ),
//               Text(
//                 rupeeSymbol + "400",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 40,
//           ),
//           Text(
//             "Enter Amount",
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black54),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Form(
//             key: _formKey,
//             child: Container(
//               height: 70,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(width: 2, color: primaryColor),
//               ),
//               child: Center(
//                 child: TextFormField(
//                   textAlign: TextAlign.center,
//                   controller: amountControl,
//                   validator: (value) {
//                     return value!.isEmpty || value == '0'
//                         ? "Enter an amount > 0"
//                         : null;
//                   },
//                   keyboardType: TextInputType.number,
//                   cursorHeight: 40,
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     prefix: Text(rupeeSymbol),
//                     hintText: ' enter amount',
//                     contentPadding: EdgeInsets.only(left: 10, right: 10),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Center(
//               child: TextButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 setState(() {
//                   amountEntered = true;
//                 });
//               }
//             },
//             child: Text(
//               "Load Money",
//               style: TextStyle(fontSize: 16),
//             ),
//             style: TextButton.styleFrom(
//               backgroundColor: secondaryColor,
//               fixedSize: Size(screenWidth, 50),
//             ),
//           )),
//         ]),
//       ),
//     );
//   }
//
//   Widget _loadMoney() {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 User.userName,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   "Edit",
//                   style: TextStyle(fontSize: 15),
//                 ),
//                 style: TextButton.styleFrom(
//                   fixedSize: Size(50, 30),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7)),
//                   side: BorderSide(
//                       width: 2,
//                       style: BorderStyle.solid,
//                       color: secondaryColor.withOpacity(.8)),
//                   primary: secondaryColor,
//                 ),
//               )
//             ],
//           ),
//           Divider(
//             thickness: 1,
//             height: 40,
//           ),
//           Text(
//             "Mobile Phone Number",
//             style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black54,
//                 fontWeight: FontWeight.bold),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 User.userMobile,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   "Edit",
//                   style: TextStyle(fontSize: 15),
//                 ),
//                 style: TextButton.styleFrom(
//                   fixedSize: Size(50, 30),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7)),
//                   side: BorderSide(
//                       width: 2,
//                       style: BorderStyle.solid,
//                       color: secondaryColor.withOpacity(.8)),
//                   primary: secondaryColor,
//                 ),
//               )
//             ],
//           ),
//           Row(
//             children: [
//               Text(
//                 "|/ ",
//                 style:
//                     TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "We have this number verified",
//                 style:
//                     TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//               )
//             ],
//           ),
//           Divider(
//             thickness: 1,
//             height: 40,
//           ),
//           Text(
//             "Official Valid Document ID",
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black54),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 48,
//             width: screenWidth - 20,
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 2,
//                   color: primaryColor,
//                 ),
//                 borderRadius: BorderRadius.circular(8)),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton(
//                 underline: Container(),
//                 elevation: 0,
//                 // isDense: true,
//                 iconSize: 30,
//                 icon: Icon(Icons.arrow_downward_rounded),
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black54,
//                     fontSize: 16),
//                 value: _officialValidDoc,
//                 items: [
//                   DropdownMenuItem(
//                     child: Text(" select"),
//                     value: 0,
//                   ),
//                   DropdownMenuItem(
//                     child: Text(" Passport"),
//                     value: 1,
//                   ),
//                   DropdownMenuItem(
//                     child: Text(" Adhaar Card"),
//                     value: 2,
//                   ),
//                   DropdownMenuItem(
//                     child: Text(" PAN Card"),
//                     value: 3,
//                   )
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _officialValidDoc = value as int;
//
//                     value == 1
//                         ? officialValidDoc = "Passport"
//                         : value == 2
//                             ? officialValidDoc = "Adhaar Card"
//                             : value == 3
//                                 ? officialValidDoc = "PAN Card"
//                                 : value == 0
//                                     ? "select"
//                                     : null;
//                   });
//                 },
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           Form(
//             key: _formKey,
//             child: TextFormField(
//               controller: _validDocNumber,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               inputFormatters: officialValidDoc == "Adhaar Card"
//                   ? _formatAdhaar()
//                   : officialValidDoc == "Passport"
//                       ? _formatPassport()
//                       : officialValidDoc == "PAN Card"
//                           ? _formatPANCard()
//                           : null,
//               validator: (value) {
//                 return officialValidDoc == "select" || _officialValidDoc == 0
//                     ? "Select Valid Document"
//                     : officialValidDoc == "Adhaar Card"
//                         ? _validateAdhaar(value)
//                         : officialValidDoc == "Passport"
//                             ? _validatePassport(value)
//                             : officialValidDoc == "PAN Card"
//                                 ? _validatePANcard(value)
//                                 : null;
//               },
//               keyboardType: TextInputType.number,
//               cursorHeight: 24,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               decoration: InputDecoration(
//                 hintText: 'enter number',
//                 contentPadding: EdgeInsets.only(left: 10, right: 10),
//                 enabledBorder: OutlineInputBorder(
//                     gapPadding: 0,
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(width: 2, color: primaryColor)),
//                 border: OutlineInputBorder(
//                     gapPadding: 0,
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(width: 2, color: primaryColor)),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Center(
//               child: TextButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 setState(() {
//                   loadMoney = true;
//                 });
//               }
//             },
//             child: Text(
//               "Continue",
//               style: TextStyle(fontSize: 16),
//             ),
//             style: TextButton.styleFrom(
//               backgroundColor: secondaryColor,
//               fixedSize: Size(screenWidth, 50),
//             ),
//           ))
//         ]),
//       ),
//     );
//   }
//
//   _validateAdhaar(value) {
//     return value!.isEmpty ||
//             value.length != 12 ||
//             !_numericRegExp.hasMatch(value) ||
//             _alphaRegExp.hasMatch(value)
//         ? "Enter valid 12 digit Adhaar number"
//         : null;
//   }
//
//   _validatePANcard(value) {
//     return value!.isEmpty ||
//             value.length != 10 ||
//             !_alphaRegExp.hasMatch(value.substring(0,
//                 2)) //First three characters i.e. "XYZ" in the above PAN are alphabetic series running from AAA to ZZZ
//             ||
//             !_alphaRegExp.hasMatch(value.substring(
//                 3)) //Fourth character i.e. "P" stands for Individual status of applicant.
//             ||
//             !_alphaRegExp.hasMatch(value.substring(
//                 4)) //Fifth character i.e. "K" in the above PAN represents first character of the PAN holder's last name/surname.
//             ||
//             !_numericRegExp.hasMatch(value.substring(5,
//                 8)) //Next four characters i.e. "8200" in the above PAN are sequential number running from 0001 to 9999.
//             ||
//             !_alphaRegExp.hasMatch(value.substring(
//                 9)) //Last character i.e. "S" in the above PAN is an alphabetic check digit.
//         ? "Enter 10 digit valid PAN Card number"
//         : null;
//   }
//
//   _validatePassport(value) {
//     return value!.isEmpty ||
//             value.length != 8 ||
//             !(_alphaRegExp.hasMatch(value[0])) ||
//             !(_numericRegExp.hasMatch(value.substring(1, 8)))
//         ? "Enter 8 digit valid Passport ID"
//         : null;
//   }
//
//   _formatAdhaar() {
//     return [
//       LengthLimitingTextInputFormatter(12),
//       FilteringTextInputFormatter.digitsOnly
//     ];
//   }
//
//   _formatPANCard() {
//     return [
//       LengthLimitingTextInputFormatter(10),
//       FilteringTextInputFormatter.allow(_alphanumericRegExp)
//     ];
//   }
//
//   _formatPassport() {
//     return [
//       LengthLimitingTextInputFormatter(8),
//       FilteringTextInputFormatter.allow(_alphanumericRegExp)
//     ];
//   }
// }
