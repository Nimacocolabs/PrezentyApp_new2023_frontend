import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/user_details.dart';

import 'package:event_app/models/delete_account_otp_model.dart';
import 'package:event_app/models/user_sign_up_response.dart';

import 'package:event_app/models/wallet&prepaid_cards/wallet_details_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/drawer/happy_moments_screen.dart';
import 'package:event_app/screens/gifting_screen.dart';
import 'package:event_app/screens/login/reset_password_email_screen.dart';
import 'package:event_app/screens/main_screen.dart';

import 'package:event_app/screens/prepaid_cards_wallet/apply_kyc_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_prepaid_card_list_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/screens/profile/change_password_screen.dart';
import 'package:event_app/screens/profile/delete_account_screen.dart';
import 'package:event_app/screens/profile/edit_profile_screen.dart';
import 'package:event_app/screens/profile/event_registry_screen.dart';
import 'package:event_app/screens/profile/invite_and_earn.dart';
import 'package:event_app/screens/profile/kyc_documents_screen.dart';
import 'package:event_app/screens/profile/my_HI_card_details_screen.dart';
import 'package:event_app/screens/profile/prepaid_wallet_details_screen.dart';
import 'package:event_app/screens/profile/profile_details_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.showAppBar = true}) : super(key: key);

  final bool showAppBar;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc _profileBloc;
  late WalletBloc _walletBloc;
  String? virtualAccountBalance;
  String accountId = User.userId;
  DeleteAccountOtpData? deleteData;
  WalletDetails? walletData;
  UserSignUpResponse? userImage;

  final TextEditingController panNumberControl = TextEditingController();
  final TextEditingController aadharNumberControl = TextEditingController();
  final TextEditingController filePasswordControl = TextEditingController();
  static final RegExp _numericRegExp = RegExp('[0-9]');
  static final RegExp alphaRegExp = RegExp('[a-zA-Z]');
  FormatAndValidate formatAndValidate = FormatAndValidate();
  final _formKey = GlobalKey<FormState>();
  File? pickedXmlFile;
  FilePickerResult? pickerResult;
  bool? prepaidCardUserOrNot;
  bool? prepaidCardUserOrNotToken;
  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    _walletBloc = WalletBloc();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await _walletBloc.getWalletDetails(User.userId);
      // virtualAccountBalance = await _profileBloc.getVirtualBalance(User.userId);
      _profileBloc.getProfileInfo();

      getVirtualAccountBalance();
      getPrepaidCardUserOrNotToken();
      getPrepaidCardUserOrNot();
      getUserImage();

      // fetchUserKYCDetails();
    });
  }

  // Future<fetchUserData?> fetchUserKYCDetails() async {
  //   fetchUserData? userDetails =
  //       await WalletBloc().fetchUserKYCDetails(User.userId);

  //   setState(() {
  //     kycUserData = userDetails;
  //   });
  //   return kycUserData;
  // }

  Future getVirtualAccountBalance() async {
    virtualAccountBalance = await _profileBloc.getVirtualBalance(User.userId);
    setState(() {});
  }

  getPrepaidCardUserOrNot() async {
    prepaidCardUserOrNot = await _profileBloc.confirmWalletUser(accountId);
    setState(() {});
  }
  getPrepaidCardUserOrNotToken() async {
    prepaidCardUserOrNotToken = await _profileBloc.tokencard(accountId);
    setState(() {});
  }
 getUserImage() async {
    userImage = await _profileBloc.getProfileInfo();
    print("the user image is ${ userImage}");
    setState(() {});
  }
  pickXMLFile() async {
    pickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (pickerResult != null) {
      pickedXmlFile = File(pickerResult!.files.single.path!);
    }
  }

  moveToProfileDetailsScreenScreen() {
    Get.to(() => ProfileDetailsScreen());
  }

  moveToMyIDDocumentsScreen() {
    Get.to(() => KYCDocumentsScreen());
  }

  moveToEventRegistryScreen() {
    Get.to(() => EventRegistryScreen(
          virtualAccountBalance: virtualAccountBalance ?? "0",
        ));
  }

  moveToMyHICardDetailsScreen() {
    Get.to(() => MyHICardDetailsScreen());
  }

  moveToInviteAndEarn() {
    Get.to(() => InviteAndEarnScreen());
  }

  moveToPrepaidWalletDetailsScreen() async {
    AppDialogs.loading();
    bool? response = await _profileBloc.confirmWalletUser(accountId);
    if (response == true) {
      AppDialogs.closeDialog();
      Get.to(() => PrepaidWalletDetailsScreen());
    } else {
      AppDialogs.closeDialog();
      showDialog(
        context: context,
        builder: (context) {
          return LayoutBuilder(
            builder: (context, contraints) {
              return AlertDialog(
                content: SizedBox(
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Icon(
                        Icons.cancel_rounded,
                        color: Colors.red.shade300,
                        size: 70,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'You are not a prepaid user'.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Buy one of our cards to proceed',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: secondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text('Visit Our Prepaid Cards'),
                          onPressed: () {
                            Get.to(
                                () => ApplyPrepaidCardListScreen(
                                    isUpgrade: false),
                                transition: Transition.fade);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  moveToUpdateProfileScreen(String? baseUrl, UserDetails? userDetails) async {
    bool? nav = await Get.to(
        () => EditProfileScreen(userDetails: userDetails!, baseUrl: baseUrl!));

    if (nav ?? false) {
      _profileBloc.getProfileInfo();
    }
  }

  moveToUpdatePasswordScreen(
      String? email, bool? isFromProfile, UserDetails? userDetails) {
    if (userDetails!.hasPassword!) {
      Get.to(() => ChangePasswordScreen());
    } else {
      Get.to(() =>
          ResetPasswordEmailScreen(email: User.userEmail, isFromProfile: true));
    }
  }

  moveToDeleteAccountScreen() {
    Get.to(() => DeleteAccountScreen());
  }

  validatePANCard(value) {
    String? pan = value!.isEmpty ||
            value.length != 10 ||
            !alphaRegExp.hasMatch(value.substring(0,
                2)) //First three characters i.e. "XYZ" in the above PAN are alphabetic series running from AAA to ZZZ
            ||
            !alphaRegExp.hasMatch(value.substring(
                3)) //Fourth character i.e. "P" stands for Individual status of applicant.
            ||
            !alphaRegExp.hasMatch(value.substring(
                4)) //Fifth character i.e. "K" in the above PAN represents first character of the PAN holder's last name/surname.
            ||
            !_numericRegExp.hasMatch(value.substring(5,
                8)) //Next four characters i.e. "8200" in the above PAN are sequential number running from 0001 to 9999.
            ||
            !alphaRegExp.hasMatch(value.substring(
                9)) //Last character i.e. "S" in the above PAN is an alphabetic check digit.
        ? "Enter 10 digit valid PAN Card number"
        : null;

    return pan;
  }

  //

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
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
                        return _buildUserWidget(resp);
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
                })));
    return widget.showAppBar
        ? Scaffold(
            appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
            bottomNavigationBar: CommonBottomNavigationWidget(),
            body: child,
          )
        : child;
  }

  Widget _buildUserWidget(UserSignUpResponse data) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Material(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Column(children: [
                        SizedBox(height: 20),
                        Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.black87,
                            radius: 80,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  '${data.baseUrl}${data.userDetails!.imageUrl}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/ic_avatar.png',
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${data.userDetails!.name ?? ''}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              if (data.userDetails!.userVerified == "Yes")
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: CachedNetworkImage(
                                      width: 33,
                                      imageUrl:
                                          'https://prezenty.in/prezentycards-live/public/app-assets/image/verified.png'),
                                ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text("  My profile management",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 5,
                            ),
                            profileManagementCards(
                                cardName: "Profile Details",
                                cardIcon: Icons.account_circle_rounded,
                                moveToScreen: () {
                                  moveToProfileDetailsScreenScreen();
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            profileManagementCards(
                                cardName: "My ID Documents",
                                cardIcon: Icons.fact_check_rounded,
                                moveToScreen: () {
                                  moveToMyIDDocumentsScreen();
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            // profileManagementCards(
                            //     cardName: "Event Registry",
                            //     cardIcon: Icons.event_rounded,
                            //     moveToScreen: () {
                            //       moveToEventRegistryScreen();
                            //     }),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            Card(
                              //color: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              elevation: 2,
                              margin: EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Get.to(() => MyHICardDetailsScreen());
                                    },
                                    child: Row(
                                      children: [
                                        Image(
                                          image: AssetImage(
                                            'assets/images/hi_icon.png',
                                          ),
                                          width: 33,
                                          height: 35,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "My H! Rewards",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            profileManagementCards(
                                cardName: "Prepaid Wallet Details",
                                cardIcon: Icons.account_balance_wallet_outlined,
                                moveToScreen: () {
                                  moveToPrepaidWalletDetailsScreen();
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            profileManagementCards(
                                cardName: "Invite and Earn",
                                cardIcon: Icons.people,
                                moveToScreen: () {
                                  moveToInviteAndEarn();
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            profileManagementCards(
                                cardName: "Edit Profile",
                                cardIcon: Icons.edit,
                                moveToScreen: () {
                                  moveToUpdateProfileScreen(
                                      data.baseUrl, data.userDetails);
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            profileManagementCards(
                                cardName: "Update Password",
                                cardIcon: Icons.password_rounded,
                                moveToScreen: () {
                                  moveToUpdatePasswordScreen(
                                      User.userEmail, true, data.userDetails);
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            profileManagementCards(
                                cardName: "Delete Account",
                                cardIcon: Icons.delete,
                                moveToScreen: () {
                                  moveToDeleteAccountScreen();
                                })
                          ],
                        ),
                      ]),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileManagementCards(
      {required String cardName,
      IconData? cardIcon,
      Widget? image,
      required Function moveToScreen}) {
    return Card(
      //color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.height * 0.05,
          child: OutlinedButton(
            onPressed: () {
              moveToScreen();
            },
            child: Row(
              children: [
                Icon(cardIcon),
                SizedBox(
                  width: 8,
                ),
                Text(
                  cardName,
                  style: TextStyle(color: primaryColor, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

 
}
