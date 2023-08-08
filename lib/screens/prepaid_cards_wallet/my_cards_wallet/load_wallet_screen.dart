import 'package:event_app/models/wallet&prepaid_cards/wallet_details_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_payment_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadWalletScreen extends StatefulWidget {
  final WalletDetails walletDetails;

  const LoadWalletScreen({Key? key, required this.walletDetails}) : super(key: key);

  @override
  State<LoadWalletScreen> createState() => _LoadWalletScreenState();
}

class _LoadWalletScreenState extends State<LoadWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Icon(
            //         Icons.info_outline_rounded,
            //       ),
            //       SizedBox(
            //         width: 8,
            //       ),
            //       Expanded(
            //         child: Text(
            //           "Once the prepaid virtual/physical card is generated, you may load the wallet/account through net banking NEFT/IMPS through your bank account or via UPI id.",
            //           style:
            //               TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                style:ElevatedButton.styleFrom(shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))),
                onPressed: () async {
                  String? value = await AppDialogs.inputAmountBottomSheet(
                      "", "Enter the amount to be loaded into your wallet");
                  if (value != null) {
                    Get.to(WalletPaymentScreen(
                        accountid: User.userId, amount: value));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:12.0,horizontal:20),
                  child: Text("Pay by UPI"),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            // _walletLoadDetails(
            //     "Available Balance", rupeeSymbol +widget.walletDetails.balance.toString()),
            // _walletLoadDetails(
            //     "Account number", widget.walletDetails.virtualAccountNumber!),
                 
      //         Padding(
      //           padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1, bottom: 1),
      //           child: Card(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      //   color: secondaryColor[100],
      //   elevation: 0,
      //   margin: EdgeInsets.zero,
      //   child: Padding(
      //     padding: const EdgeInsets.all(20.0),
      //     child: Row(
      //       children: [
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //             Text("BANK PROVIDER",
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.w700,
      //                     color: secondaryColor[300])),
      //             SizedBox(
      //               height: 8,
      //             ),
      //             Text("AXIS BANK",
      //                 style: TextStyle(
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.w700,
      //                     color: secondaryColor[600])),
      //           ]),
      //       ],
      //     ),
      //   ),
      // ),
      //         ),
             
      //       _walletLoadDetails("IFSC CODE", widget.walletDetails.ifsc!),
      //       _walletLoadDetails("UPI ID", widget.walletDetails.upiid!),

      //       _walletLoadDetails("Monthly Load Limit",
      //           rupeeSymbol + widget.walletDetails.monthlyLoadLimit.toString()),
      //       _walletLoadDetails("Annual Load limit",
      //           rupeeSymbol + widget.walletDetails.annualLoadLimit.toString()),
      //       _walletLoadDetails("Monthly Transaction limit",
      //           rupeeSymbol + widget.walletDetails.monthyTrxLimit.toString()),
      //       _walletLoadDetails(
      //           "Monthly Balance limit",
      //           rupeeSymbol +
      //               widget.walletDetails.monthlyBalanceLimit.toString()),

//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: EdgeInsets.all(8),
//               child: Text(
//                 "Transaction methods",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[600],
//                     fontSize: 16),
//               ),
//             ),
//             _transferMethodInfo("IMPS",
//                 "All IMPS transactions can be settled immediately and the wallet will be updated instantly."),
//             _transferMethodInfo("NEFT",
//                 "All NEFT transactions can be settled immediately or within a few hours (usually 2 hours). The actual time required for the settlement of those transactions may vary from bank to bank."),
//             _transferMethodInfo("UPI",
//                 "All UPI enabled transactions can be settled immediately and the wallet will be updated instantly."),
// //             Text("""
// // Fund transfer/transaction charge may be applicable on NEFT/IMPS transfers that are initiated through digital modes of banking, i.e., Internet Banking, Mobile app /UPI. Depending on the channel you use for NEFT/IMPS, the charges may vary. Transaction charges associated with the different channels you may verify with your banking provider.
// //
// // IMPS Transfer-All IMPS transactions can be settled immediately and will update the wallet instantly.
// //
// // NEFT Transfer- All NEFT transactions can be settled immediately or within a few hours (usually 2 hours). The actual time required for the settlement of these transactions, however, may vary from bank to bank.
// //
// // UPI Transfer- All UPI enabled transactions can be settled immediately and will update the wallet instantly. """),
//             SizedBox(
//               height: 24,
//             ),
//             _bulletText(
//                 "Acceptance at all Rupay enabled merchant for POS & Online transactions across the country(India)."),
//                 _bulletText("Terms and conditions apply."),
//             // _bulletText("Load/reload any amount up to a maximum INR 120000"),
//             // _bulletText(
//             //     "Accepted at all Rupay enabled Merchants for in store and online transactions across the country"),
//             // _bulletText(
//             //     "Balance Enquiry /transaction details can be available through Prezenty app/web"),
//             SizedBox(
//               height: 20,
//             )
          ],
        ),
      ),
    );
  }

  _walletLoadDetails(String info, String data) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 1, bottom: 1),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        color: secondaryColor[100],
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(info,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: secondaryColor[300])),
                SizedBox(
                  height: 8,
                ),
                Text(data,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: secondaryColor[600])),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  _transferMethodInfo(String transferMethod, String transferMethodDescription) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.only(left: 12, right: 12),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 40.0, right: 4, top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.2,
              child: Text(
                transferMethod,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: secondaryColor[200]),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              transferMethodDescription,
              textAlign: TextAlign.start,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: secondaryColor[400]),
            ))
          ],
        ),
      ),
    );
  }

  _bulletText(String data) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.star,
            size: 14,
            color: Colors.grey[600],
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            data,
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible,
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ))
        ],
      ),
    );
  }
}
