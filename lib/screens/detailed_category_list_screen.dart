import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/get_detailed_product_category_list_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/woohoo/input_card_no_pin_screen.dart';

import 'package:event_app/screens/woohoo/woohoo_voucher_details_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';


import 'login/login_screen.dart';

class DetailedProductCategoryListScreen extends StatefulWidget {
  final int categoryId;
  final RedeemData redeemData;
  const DetailedProductCategoryListScreen({Key? key,required this.categoryId,required this.redeemData}) : super(key: key);

  @override
  State<DetailedProductCategoryListScreen> createState() => _DetailedProductCategoryListScreenState();
}

class _DetailedProductCategoryListScreenState extends State<DetailedProductCategoryListScreen> {
  ProfileBloc _profileBloc =ProfileBloc();
  String? imageBaseUrl = "https://prezenty.in/prezenty/common/uploads/woohoo-images/";
  
  TextEditingController _textEditingControllerSearch = TextEditingController();

  
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    _profileBloc.getDetailedCategoryList(categoryId:  widget.categoryId);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
    body: SingleChildScrollView(child: 
    Column(
       mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
       Container(
                padding: EdgeInsets.all(8),
                color: primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    // onSubmitted: (value) {},
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: _textEditingControllerSearch,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search_rounded,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Search',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
              ),
              
 if (widget.redeemData.redeemType == RedeemType.BUY_VOUCHER)
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // scrollDirection: Axis.horizontal,
                    children: [
                      // _option('assets/images/brand.png', 'Brand Cards'),
                      // _option('assets/images/categories.png', 'Categories',onTap: _showBottomSheet),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() =>
                                InputCardNoPinScreen(isCardBalance: true,isHiCardBalanceCheck: false,));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.account_balance_wallet_outlined),
                                Text(
                                  'Card Balance',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        indent: 4,
                        endIndent: 4,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() =>
                                InputCardNoPinScreen(isCardBalance: false,isHiCardBalanceCheck: false,));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.assignment_outlined),
                                Text(
                                  'Transaction History',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),


             
SizedBox(
      width: screenWidth,
      //height: screenHeight*0.72,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream:_profileBloc.detailedProductsCategoryStream,
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
                  GetDetailedProductCategoryListModel response =
                      snapshot.data!.data!;

                  
                final productsResponse = response.data;
                  
                  return detailedCategoryProductsList(response);

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
    ],)));
   
  }

   detailedCategoryProductsList(GetDetailedProductCategoryListModel response){
  

 
   if ((response.data ?? []).isEmpty) {
      return CommonApiResultsEmptyWidget('No Result');
    }
  List<GetDetailedProductCategoryListData> productList = []; //response.data??[];

    String query = _textEditingControllerSearch.text.trim().toLowerCase();
    
    if (query.isEmpty) {
      productList = response.data??[] ;
    } else {
      (response.data ?? [] ).forEach((element) {
       
        if ((element.name ?? '').toLowerCase().contains(query))
          productList.add(element);
      });
    }
     if (productList.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('No result',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        ),
      ));
    }
return  SingleChildScrollView(
  child: Column(
    children: [
     GridView.builder(
       physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            shrinkWrap: true,
            itemCount: productList.length,
       itemBuilder: (BuildContext context,int index){
        return InkWell(
 onTap: () async {
   if(User.apiToken.isEmpty){
  await Get.to(() => LoginScreen(isFromWoohoo: false));
 }
 else{
  await Get.to(() => WoohooVoucherDetailsScreen(
                      productId: productList[index].id ?? 0,
                      redeemData:RedeemData.buyVoucher()));
 }

                 
                },
  borderRadius: BorderRadius.circular(12),
child: Stack(children: [
  Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(child: ClipRRect(
         borderRadius: BorderRadius.circular(12),
         child: Container(
          decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                imageUrl: '${imageBaseUrl}${productList[index].image}',
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
                                      child: Image.asset(
                                          'assets/images/no_image.png'),
                                          ),
                              

                                ),
         ),
      ),
      ),
       Padding(
                          padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                          child: Text('${productList[index].name ?? ''}\n',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              )),
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