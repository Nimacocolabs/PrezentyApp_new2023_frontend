import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetailsScreen extends StatefulWidget {
  ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
     ProfileBloc _profileBloc = ProfileBloc() ;
   WalletBloc _walletBloc = WalletBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileBloc = ProfileBloc();
    _walletBloc = WalletBloc();
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await _walletBloc.getWalletDetails(User.userId);
      // virtualAccountBalance = await _profileBloc.getVirtualBalance(User.userId);
      _profileBloc.getProfileInfo();
      // getWalletDetails();

      // getVirtualAccountBalance();

      // fetchUserKYCDetails();
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text("Profile Details",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18)),
              ),
              Divider(
                thickness: 2,
              ),

              Container(
        child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: primaryColor,
            onRefresh: () {
              return _profileBloc.getProfileInfo();
            },
            child: StreamBuilder<ApiResponse<dynamic>>(
                stream: _profileBloc.profileStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        return CommonApiLoader();
                      case Status.COMPLETED:
                        UserSignUpResponse resp = snapshot.data!.data;
                        return contactDetailsWdiget(resp);
                      case Status.ERROR:
                        return CommonApiResultsEmptyWidget(
                            "${snapshot.data!.message!}",
                            textColorReceived: Colors.black);
                    }
                  }
                  return Container(
                    child: Center(
                      child: Text(""),
                    ),
                  );
                }))),
        
            ]),
      ),
    );
  }

  Widget contactDetailsWdiget (UserSignUpResponse data){
    return  Container(
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
                                    Icon(Icons.account_box_outlined,
                                    color: primaryColor,
                                    size: 28),
                                    SizedBox(width: 10, height: 30),
                                    Text("Name",
                                        style: TextStyle(
                                          fontSize:16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                               
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                  child: Text(
                                    "${data.userDetails!.name ?? ''}",

                                    style: TextStyle(
                                      fontSize: 14
                                      
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height:10,
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
                                  data.userDetails!.phoneNumber == null
                            ? Text('- - -')
                            : 
                                Row(
                                  children: [
                                      Image(
                                    image:
                                        AssetImage('assets/images/ic_call.png'),
                                    height: 20,
                                    width: 20,
                                  ),
                                    SizedBox(width: 10, height: 30),
                                    Text("Mobile Number",
                                        style: TextStyle(
                                          fontSize:16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                               data.userDetails!.phoneNumber == null
                                      ? Text('- - -')
                                      : 
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(29, 0, 0, 0),
                                  
                                  child: Text(
                                    "+${data.userDetails!.countryCode} - ${data.userDetails!.phoneNumber}",

                                    style: TextStyle(
                                      fontSize: 14
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height:10,
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
                                    image:
                                        AssetImage('assets/images/ic_email.png'),
                                    height: 20,
                                    width: 20,
                                  ),
                                    SizedBox(width: 10, height: 30),
                                    Text("Email ID",
                                        style: TextStyle(
                                          fontSize:16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                               
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(29, 0, 0, 0),
                                  child: Text(
                                    "${data.userDetails!.email ?? ''}",

                                    style: TextStyle(
                                      fontSize: 14
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height:10,
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
                              Icons.location_on_outlined,
                              color: primaryColor,
                              size: 28,
                            ),
                                    SizedBox(width: 10, height: 30),
                                    Text("Address",
                                        style: TextStyle(
                                          fontSize:16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                               
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(39, 0, 0, 0),
                                  child: Text(
                                    "${data.userDetails!.address ?? ''}",

                                    style: TextStyle(
                                      fontSize: 14
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      

                      
                     


                      
                    ],
                  ),
                ),
              );
  }
}
