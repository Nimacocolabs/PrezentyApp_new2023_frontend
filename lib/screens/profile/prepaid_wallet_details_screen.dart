import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/fetch_physical_card_details_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/fetch_user_details_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/get_physical_card_status_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/wallet_details_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/request_physical_card.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrepaidWalletDetailsScreen extends StatefulWidget {
  PrepaidWalletDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PrepaidWalletDetailsScreen> createState() =>
      _PrepaidWalletDetailsScreenState();
}

class _PrepaidWalletDetailsScreenState
    extends State<PrepaidWalletDetailsScreen> {
  ProfileBloc _profileBloc = ProfileBloc();
  WalletBloc _walletBloc = WalletBloc();
  String accountId = User.userId;
  fetchUserData? kycUserData;
  WalletDetails? walletData;
  FetchPhysicalCardDetailsModel? physicalCardData;
  GetPhysicalCardStatusModel?  physicalCardStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchUserKYCDetails();
      getWalletDetails();
      getPhysicalCardDetails();
      getPhysicalCardStatus();
    });
  }

  Future<fetchUserData?> fetchUserKYCDetails() async {
    fetchUserData? userDetails =
        await WalletBloc().fetchUserKYCDetails(User.userId);

    setState(() {
      kycUserData = userDetails;
    });
    return kycUserData;
  }

  Future getWalletDetails() async {
    walletData = await _walletBloc.getWalletDetails(User.userId);
    setState(() {});
  }

  Future getPhysicalCardDetails() async {
    physicalCardData = await _profileBloc.fetchPhysicalCardDetails(accountId);
    print("*****");
    print("${physicalCardData?.apply.toString()}");
    print("???????????");
    setState(() {
      
    });
  }


    Future getPhysicalCardStatus() async {
    physicalCardStatus = await _profileBloc.getPhysicalCardStatus(accountId);
    print("*****");
    print("${physicalCardData?.apply.toString()}");
    print("???????????");
    setState(() {
      
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
    appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Prepaid Wallet Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ),
                Divider(
                  thickness: 2,
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/cards/horizontal_with_logo.png'),
                                        height: 28,
                                        width: 28,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("Card Name",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(39, 0, 0, 0),
                                    child: Text(
                                      '${walletData?.cardName ?? ""}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                          Icons.account_balance_wallet_outlined,
                                          color: primaryColor,
                                          size: 28),
                                      SizedBox(width: 10, height: 30),
                                      Text("Wallet Number",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(39, 0, 0, 0),
                                    child: Text(
                                      "${kycUserData?.walletNumber?? ""}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.onetwothree_outlined,
                                        color: primaryColor,
                                        size: 35,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("Account Number",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(43, 0, 0, 0),
                                    child: Text(
                                      "${kycUserData?.vaNumber ?? ""}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_outlined,
                                        color: primaryColor,
                                        size: 28,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("IFSC Code",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(39, 0, 0, 0),
                                    child: Text(
                                      '${kycUserData?.vaIfsc ?? ""}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/livquick.jpg'),
                                        height: 28,
                                        width: 28,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("PPI Provider",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Text(
                                      'Livquik',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/Rupay_image.png'),
                                        height: 33,
                                        width: 33,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("Network",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(45, 0, 0, 0),
                                    child: Text(
                                      "RuPay",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.credit_card,
                                        color: primaryColor,
                                        size: 28,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("Virtual card",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(43, 0, 0, 0),
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.credit_score_outlined,
                                        color: primaryColor,
                                        size: 28,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("Physical Card",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  physicalCardData?.data?.length == 0
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              39, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(
                                               "Applied : ${physicalCardStatus?.apply == "no" ? "NO": "YES (${physicalCardStatus?.cardstatus})"} ",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: 110,
                                              ),
                                              physicalCardStatus?.apply == "no"?
                                              ElevatedButton(
                                                  onPressed: () {
                                                    
                                                      Get.to(() =>
                                                          RequestPhysicalCard(
                                                            kitNumber: _walletBloc
                                                                .walletDetailsData!
                                                                .kitNo!,
                                                            cardNumber: _walletBloc
                                                                .walletDetailsData!
                                                                .cardDetails!
                                                                .cardNumber!,
                                                          ));
                                                    
                                                  },
                                                  child: Text("Apply now")) :Container()
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.currency_rupee_outlined,
                                        color: primaryColor,
                                        size: 28,
                                      ),
                                      SizedBox(width: 10, height: 30),
                                      Text("Available Wallet Balance",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(39, 0, 0, 0),
                                    child: Text(
                                      '${rupeeSymbol} ${walletData?.balanceInfo?.balance ?? ""}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.domain_verification_outlined,
                                          color: primaryColor, size: 28),
                                      SizedBox(width: 10, height: 30),
                                      Text(" PAN Number",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(39, 0, 0, 0),
                                    child: Text(
                                      '${(kycUserData?.prepaidPanNumber ?? "").replaceAllMapped(RegExp(r'.(?=.{4})'), (match) => '*')}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
