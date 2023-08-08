
import 'package:event_app/bloc/wallet_bloc.dart';

import 'package:event_app/models/wallet&prepaid_cards/fetch_user_details_model.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EventRegistryScreen extends StatefulWidget {
  final String? virtualAccountBalance;
  const EventRegistryScreen({Key? key, required this.virtualAccountBalance})
      : super(key: key);

  @override
  State<EventRegistryScreen> createState() => _EventRegistryScreenState();
}

class _EventRegistryScreenState extends State<EventRegistryScreen> {
  String? virtualAccountBalance;
  bool? isLoading = true;
  fetchUserData? accountDetails;
  @override
  void initState() {
    super.initState();
    virtualAccountBalance = widget.virtualAccountBalance;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchUserEventregistryDetails();
    });
  }

  Future<fetchUserData?> fetchUserEventregistryDetails() async {
    // virtualAccountBalance = await ProfileBloc().getVirtualBalance(User.userId);
    accountDetails = await WalletBloc().fetchUserKYCDetails(User.userId);
    setState(() {
      isLoading = false;
    });
    return accountDetails;
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Event Registry",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 20,
                ),
                isLoading! ? Container() : _registryDetails()
              ]),
        ));
  }

  _registryDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Column(
        children: [
          _registryData(
              icon: Icons.add_card_sharp,
              title: 'Virtual Account Number',
              data: accountDetails?.vaNumber ?? ""),
          _registryData(
              icon: Icons.account_balance_sharp,
              title: 'Bank Provider',
              data: 'AXIS BANK'),
          _registryData(
              icon: Icons.lock_outline_sharp,
              title: 'IFSC Code',
              data: accountDetails?.vaIfsc),
          _registryData(
              icon: Icons.lock_outline_sharp,
              title: 'UPI',
              data: accountDetails?.vaUpi),
          _registryData(
              assetsPath: 'assets/images/ic_coins.png',
              title: 'Available Coins',
              data: virtualAccountBalance),
        ],
      ),
    );
  }

  _registryData(
      {required title, required data, IconData? icon, String? assetsPath}) {
    return
        // mainAxisAlignment: MainAxisAlignment.start,
        // children: [
        //   Image.asset(
        //     assetPath,
        //     height: 20,
        //     width: 20,
        //   ),
        Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        assetsPath != null
            ? Image(
                image: AssetImage(assetsPath),
                height: 25,
                width: 25,
              )
            : Icon(
                icon,
                color: primaryColor,
                size: 20,
              ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IntrinsicWidth(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black.withOpacity(0.5),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
