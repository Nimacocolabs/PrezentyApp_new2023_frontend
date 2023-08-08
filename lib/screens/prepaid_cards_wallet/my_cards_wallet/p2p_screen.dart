import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import '../../../models/wallet&prepaid_cards/existing_payee_model.dart';
import '../../../util/app_helper.dart';
import '../../../util/user.dart';

class P2PScreen extends StatefulWidget {
  const P2PScreen({Key? key}) : super(key: key);

  @override
  State<P2PScreen> createState() => _P2PScreenState();
}

class _P2PScreenState extends State<P2PScreen> {
  WalletBloc _walletBloc = WalletBloc();
  final Rx<TextFieldControl> _textFieldControlWalletNo = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldControlAmount = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldPayeeName = TextFieldControl().obs;
  final Rx<TextFieldControl> _textFieldPayeeWalletNo = TextFieldControl().obs;

  double? tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _walletBloc.getExistingPayees(accountId: User.userId);
    _walletBloc.getFavouritePayeesList(accountId: User.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarWidget(
        onPressedFunction: () {
Get.to(() => WalletHomeScreen(isToLoadMoney: false,));
        },
        image: User.userImageUrl,
      ),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          FlutterCarousel(
            items: [
              headerTiles(
                  tileIcon: Icons.group_add_rounded,
                  tileName: "Manage\nPayees"),
              headerTiles(
                  tileIcon: Icons.autorenew_rounded,
                  tileName: "   P2P\nTransfer"),
              headerTiles(
                  tileIcon: Icons.history_rounded,
                  tileName: "P2P Transfer\nHistory"),
              headerTiles(tileIcon: Icons.favorite, tileName: "Favourites"),
            ],
            options: CarouselOptions(
              floatingIndicator: true,
              showIndicator: true,
              enlargeCenterPage: true,
              height: 170,
              initialPage: 0,
              onScrolled: ((value) {
                print("value is ${value}");
                setState(() {
                  tabIndex = value;
                });
              }),
              viewportFraction: 0.4,
              enableInfiniteScroll: false,
              autoPlay: false,
              autoPlayInterval: Duration(milliseconds: 100),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Divider(
            thickness: 3,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              tabIndex == 0 || tabIndex == 1
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 90, right: 90, bottom: 10),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            
                            addPayeeWidget();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor])),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.person_add_alt,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Add New Payee",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              tabIndex == 0 || tabIndex == 1
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 200, top: 8),
                      child: Text(
                        "All Payees",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 19),
                      ),
                    )
                  : Container(),
              tabIndex == 0 || tabIndex == 1
                  ? Divider(
                      thickness: 2,
                    )
                  : Container(),
              SizedBox(
                width: screenWidth,
                child: StreamBuilder<ApiResponse<dynamic>>(
                    stream: _walletBloc.getExistingPayeeStream,
                    builder: (context, snapshot) {
                      print("aaaa");
                      if (snapshot.hasData && snapshot.data?.status != null) {
                        print("bbbbb");
                        switch (snapshot.data!.status!) {
                          case Status.LOADING:
                            print("ccccc");
                            return CommonApiLoader();
                          case Status.COMPLETED:
                            print("dddd");
                            ExistingPayeeModel response = snapshot.data!.data!;

                            final cardResponse = response.data;
                            // return Text("123456");

                            // return existingPayeesList(cardResponse!);
                            return tabIndex == 0 || tabIndex == 1
                                ? existingPayeesList(cardResponse!)
                                : Container();

                          case Status.ERROR:
                            print("eeee");
                            return  tabIndex == 0 || tabIndex == 1 ?
                            CommonApiResultsEmptyWidget(
                                "${snapshot.data?.message ?? ""}",
                                textColorReceived: Colors.black) :Container();
                          default:
                            print("");
                        }
                      }
                      return SizedBox();
                    }),
              ),
            ],
          ),
          Container(
            child: IndexedStack(
              index: tabIndex!.toInt(),
              children: [
                Container(
                  width: screenWidth,

                  //child: managePayeeWidget(),
                ),
                Container(
                  width: screenWidth,
                  // child: managePayeeWidget(),
                ),
                Container(
                  width: screenWidth,
                  height: 350,
                  color: Colors.brown,
                ),
                Container(
                  width: screenWidth,
                  child: favouriteWidget(),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  headerTiles({String? tileName, IconData? tileIcon}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(14)),

      width: 300,

      //height: 80,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Icon(
            tileIcon,
            color: primaryColor,
            size: 42,
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tileName!,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // managePayeeWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       children: [

  //       ],
  //     ),
  //   );
  // }

  existingPayeesList(List<ExistingPayeeData> existingPayeeData) {
    if (existingPayeeData.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No Payee Added'));
    } else {
      return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          padding: MediaQuery.of(context).viewInsets,
          itemCount: existingPayeeData.length,
          itemBuilder: ((BuildContext context, index) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.person,
                        color: primaryColor,
                        size: 30,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "${existingPayeeData[index].beneficiaryName ?? ""}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 10, right: 8),
                          child: Row(
                            children: [
                              Text(
                                "${existingPayeeData[index].walletNumber ?? ""}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              existingPayeeData[index].favorite == "yes"
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.yellow.shade600,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.yellow.shade600,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                    tabIndex == 0? 
                    Padding(
                      padding: const EdgeInsets.only(left: 90),
                      child: IconButton(
                          onPressed: () {
                            showMoreOptions(
                                favouriteValue:
                                    existingPayeeData[index].favorite,
                                id: existingPayeeData[index].id);
                          },
                          icon: Icon(Icons.more_vert)),
                    ) : Padding(
                      padding: const EdgeInsets.only(left: 60,top: 30),
                      child: TextButton(onPressed: (){
                        instantTransferBottomSheet();
                      }, child: Text("Transfer",style: TextStyle(fontSize: 17),)),
                    )
                  ],
                ),
              ),
            );
          }));
    }
  }

  showMoreOptions({String? favouriteValue, int? id}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        builder: ((context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                      addOrRemoveFavourites(
                          favValue: favouriteValue, idValue: id);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.favorite_border_outlined,
                            color: primaryColor,
                            size: 35,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            favouriteValue == "yes"
                                ? "Remove from favourites"
                                : "Add to favourites",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      deleteBeneficiaryWidget(Id: id);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_sharp,
                            color: primaryColor,
                            size: 35,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Delete Payee",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }

  addOrRemoveFavourites({String? favValue, int? idValue}) async {
    if (favValue == "no") {
      CommonResponse addBeneficiaryToFavouriteData =
          await _walletBloc.addBeneficiaryToFavourite(id: idValue.toString());
      if (addBeneficiaryToFavouriteData.statusCode == 200) {
    _addedToFavourites();   

Get.close(2);
        Get.to(() => P2PScreen());
        toastMessage("${addBeneficiaryToFavouriteData.message}");
         
       
      } else {
        toastMessage("Something went wrong. Please try again later");
      }
    } else {
      CommonResponse removeBeneficiaryToFavouriteData = await _walletBloc
          .removeBeneficiaryToFavourite(id: idValue.toString());
      if (removeBeneficiaryToFavouriteData.statusCode == 200) {
    
 _removedFromFavourites();
     Get.close(2);
        Get.to(() => P2PScreen());
          toastMessage("${removeBeneficiaryToFavouriteData.message}");
       
      } else {
        toastMessage("Something went wrong. Please try again later");
      }
    }
  }

  deleteBeneficiaryWidget({int? Id}) async {
    CommonResponse deleteBeneficiaryData =
        await _walletBloc.deleteBeneficiary(id: Id.toString());
    if (deleteBeneficiaryData.statusCode == 200) {
      Get.close(2);
      Get.to(() => P2PScreen());
      toastMessage('${deleteBeneficiaryData.message}');
      return Get.dialog(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete,
                      color: primaryColor,
                      size: 70,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${deleteBeneficiaryData.message}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  addPayeeWidget() {
    _textFieldPayeeName.value.controller.clear();
    _textFieldPayeeWalletNo.value.controller.clear();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        builder: (context) {
          return SingleChildScrollView(
            child: StatefulBuilder(
                builder: ((BuildContext context, setState) => SafeArea(
                        child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  "Add Payee Details",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                "Enter Payee Name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AppTextBox(
                                keyboardType: TextInputType.name,
                                textFieldControl: _textFieldPayeeName.value,
                                hintText: "Enter payee name",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                "Enter Payee Wallet Number",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AppTextBox(
                                keyboardType: TextInputType.number,
                                textFieldControl: _textFieldPayeeWalletNo.value,
                                hintText: "Enter payee wallet number",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 20),
                              child: Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        validateAddPayeeDetails(
                                            payeeName: _textFieldPayeeName
                                                .value.controller.text
                                                .trim(),
                                            payeeWalletNo:
                                                _textFieldPayeeWalletNo
                                                    .value.controller.text
                                                    .trim());
                                      },
                                      child: Text("Submit"))),
                            )
                          ],
                        ),
                      ),
                    )))),
          );
        });
  }

  validateAddPayeeDetails({String? payeeName, String? payeeWalletNo}) async {
    if (payeeName!.isEmpty) {
      toastMessage("Enter payee name");
    } else if (payeeWalletNo!.isEmpty) {
      toastMessage("Enter payee wallet number");
    } else {
      CommonResponse existingPayeeData =
          await _walletBloc.checkWalletPayeeExistOrNot(
              accountId: User.userId, walletNumber: payeeWalletNo);
      if (existingPayeeData.statusCode == 200) {
        CommonResponse addBeneficiaryData =
            await _walletBloc.addWalletBeneficiary(
                accountId: User.userId,
                beneficiaryName: payeeName,
                walletNumber: payeeWalletNo);
        if (addBeneficiaryData.statusCode == 200) {
          Get.close(2);
          Get.to(() => P2PScreen());
          toastMessage("${addBeneficiaryData.message}");
        } else {
          toastMessage("${addBeneficiaryData.message}");
        }
      } else {
        toastMessage("${existingPayeeData.message}");
      }
    }
// Get.back();
  }

  instantTransferBottomSheet() {
    _textFieldControlWalletNo.value.controller.clear();
    _textFieldControlAmount.value.controller.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: StatefulBuilder(
            builder: (context, setState) => SafeArea(
                child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                   
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                  child: Text(
                                "Transfer Now",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              )),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Enter the receiver's wallet number",
                                style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                              ),
                              AppTextBox(
                                textFieldControl:
                                    _textFieldControlWalletNo.value,
                                keyboardType: TextInputType.number,
                                hintText:
                                    "Enter the Receiver's Wallet Number",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Enter the amount", style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                              ),
                              AppTextBox(
                                textFieldControl:
                                    _textFieldControlAmount.value,
                                keyboardType: TextInputType.number,
                                hintText: "Enter the amount",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 90, right: 90),
                                child: ElevatedButton(
                                    onPressed: () {}, child: Text("Submit")),
                              )
                            ]),
                      )
                    ]),
              ),
            )),
          ));
        });
  }

  _addedToFavourites() {
    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.yellow.shade700,
                    size: 70,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Added to Favourites',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _removedFromFavourites() {
    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    color: Colors.yellow.shade700,
                    size: 70,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Removed from Favourites',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  favouriteWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 200, top: 8),
          child: Text(
            "Favourite Payees",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 19),
          ),
        ),
        Divider(
          thickness: 2,
        ),
        SizedBox(
          width: screenWidth,
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _walletBloc.getFavouritePayeesListStream,
              builder: (context, snapshot) {
                print("aaaa");
                if (snapshot.hasData && snapshot.data?.status != null) {
                  print("bbbbb");
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      print("ccccc");
                      return CommonApiLoader();
                    case Status.COMPLETED:
                      print("dddd");
                      ExistingPayeeModel response = snapshot.data!.data!;

                      final cardResponse = response.data;
                      // return Text("123456");

                      return favouritePayeesList(cardResponse!);

                    case Status.ERROR:
                      print("eeee");
                      return CommonApiResultsEmptyWidget(
                          "${snapshot.data?.message ?? ""}",
                          textColorReceived: Colors.black);
                    default:
                      print("");
                  }
                }
                return SizedBox();
              }),
        ),
      ],
    );
  }

  favouritePayeesList(List<ExistingPayeeData> existingPayeeData) {
    if (existingPayeeData.isEmpty) {
      return Center(child: CommonApiResultsEmptyWidget('No Payee Added'));
    } else {
      return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          padding: MediaQuery.of(context).viewInsets,
          itemCount: existingPayeeData.length,
          itemBuilder: ((BuildContext context, index) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.person,
                        color: primaryColor,
                        size: 30,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "${existingPayeeData[index].beneficiaryName ?? ""}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 10, right: 8),
                          child: Row(
                            children: [
                              Text(
                                "${existingPayeeData[index].walletNumber ?? ""}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.yellow.shade600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 90),
                      child: IconButton(
                          onPressed: () {
                            showMoreOptions(
                                favouriteValue:
                                    existingPayeeData[index].favorite,
                                id: existingPayeeData[index].id);
                          },
                          icon: Icon(Icons.more_vert)),
                    )
                  ],
                ),
              ),
            );
          }));
    }
  }
}
