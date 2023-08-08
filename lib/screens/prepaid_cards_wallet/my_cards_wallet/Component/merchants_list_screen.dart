import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../models/wallet&prepaid_cards/get_merchants_list_model.dart';

class MerchantListScreen extends StatefulWidget {
  const MerchantListScreen({Key? key}) : super(key: key);

  @override
  State<MerchantListScreen> createState() => _MerchantListScreenState();
}

class _MerchantListScreenState extends State<MerchantListScreen> {
  WalletBloc _walletBloc = WalletBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _walletBloc.getMerchantsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                "Merchants for you",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            width: screenWidth,
            child: StreamBuilder<ApiResponse<dynamic>>(
                stream: _walletBloc.GetMerchantsListStream,
                builder: (context, snapshot) {
                  print("aaaa");
                  if (snapshot.hasData && snapshot.data?.status != null) {
                    print("bbbbb");
                    print(snapshot.data!.status);
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        print("ccccc");
                        return CommonApiLoader();
                      case Status.COMPLETED:
                        print("dddd");
                        GetMerchantsListModel response = snapshot.data!.data!;

                        final merchantsResponse = response.data;

                        return merchantsList(merchantsResponse!);

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
      )),
    );
  }

  merchantsList(List<GetMerchantsListData> merchantsList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              shrinkWrap: true,
              itemCount: merchantsList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
//  await Get.to(() => WoohooVoucherDetailsScreen(
//                       productId: dealsProductsList[index].productId ?? 0,
//                       redeemData:RedeemData.buyVoucher()));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(children: [
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: '${merchantsList[index].imageUrl}',
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => SizedBox(
                                  child:
                                      Image.asset('assets/images/no_image.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.person_outline_rounded)),
                              Text('${merchantsList[index].name ?? ''}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.home_rounded)),
                              Expanded(
                                child: Text(
                                    '${merchantsList[index].address ?? ''}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.phone_outlined)),
                              Text('${merchantsList[index].phoneNumber ?? ''}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                );
              })
        ],
      ),
    );
  }
}
