import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/detailed_category_list_screen.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/get_product_category_list_model.dart';
import '../util/app_helper.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
ProfileBloc _profileBloc = ProfileBloc();
  String? imageBaseUrl = "https://prezenty.in/prezentycards-live/public/app-assets/image/category/";


 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
_profileBloc.getProductListCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: 
      Column(children: [
Padding(
  padding: const EdgeInsets.all(20.0),
  child:   Center(
    child: Text("OUR CATEGORIES",
    style: TextStyle(

      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20
    ),),
  ),
),
SizedBox(
      width: screenWidth,
      //height: screenHeight*0.72,
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream:_profileBloc.productsCategoryStream,
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
                  GetProductCategoryListModel response =
                      snapshot.data!.data!;

                  
                final productsResponse = response.data;
                  
                  return categoryProductsList(productsResponse!);

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

      Container(
        width: 180,
                height: 40,
        decoration: BoxDecoration(
          
           gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                               borderRadius: BorderRadius.circular(30.0)
        ),
        child: InkWell(onTap: () async {
           if(User.apiToken.isEmpty){
  await Get.to(() => LoginScreen(isFromWoohoo: false));
 }
 else{
  await  Get.to(() => WoohooVoucherListScreen(
                        redeemData: RedeemData.buyVoucher(),
                        showBackButton: true,showAppBar: true,));
 }

        },
         child: Center(child: Text("View all vouchers",
        style: TextStyle(
          color: Colors.white
        ),))),
      )

      ],)),
    );
  }
  categoryProductsList(List<GetProductCategoryListData> categoryProductsList){
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
            itemCount: categoryProductsList.length,
       itemBuilder: (BuildContext context,int index){
        return InkWell(
 onTap: () async {

  await Get.to(() => DetailedProductCategoryListScreen(categoryId: categoryProductsList[index].id ?? 0,redeemData: RedeemData.buyVoucher()));
               
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
                                imageUrl: '${imageBaseUrl}${categoryProductsList[index].image}',
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
                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 15),
                          
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