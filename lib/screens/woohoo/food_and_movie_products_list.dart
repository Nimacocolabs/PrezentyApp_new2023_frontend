import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/models/woohoo/get_food_and_movie_products_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_details_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bloc/woohoo/woohoo_product_bloc.dart';
import '../../util/app_helper.dart';
import '../../widgets/CommonApiResultsEmptyWidget.dart';
import '../login/login_screen.dart';

class FoodAndMovieProductsListScreen extends StatefulWidget {
  const FoodAndMovieProductsListScreen({Key? key}) : super(key: key);

  @override
  State<FoodAndMovieProductsListScreen> createState() => _FoodAndMovieProductsListScreenState();
}

class _FoodAndMovieProductsListScreenState extends State<FoodAndMovieProductsListScreen> {
  WoohooProductBloc _woohooBloc = WoohooProductBloc();
 

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
   _woohooBloc.getFoodAndMovieProducts();
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
      Column(children: [
Padding(
  padding: const EdgeInsets.all(20.0),
  child:   Center(
    child: Text("Food & Movie Products ",
    style: TextStyle(

      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20
    ),),
  ),
),
SizedBox(
      width: screenWidth,
      
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream:_woohooBloc.foodAndMovieProductsStream,
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
                  GetFoodAndMovieProductsModel response =
                      snapshot.data!.data!;

                  
                final productsResponse = response.data;
                  
                  return foodAndMovieProductsList(productsResponse!);

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



      ],)),
    );
  }

  foodAndMovieProductsList(List<GetFoodAndMovieProductsData> productsList){
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
            itemCount: productsList.length,
       itemBuilder: (BuildContext context,int index){
        return InkWell(
 onTap: () async {
 if(User.apiToken.isEmpty){
  await Get.to(() => LoginScreen(isFromWoohoo: false));
 }
 else{
 await Get.to(() => WoohooVoucherDetailsScreen(
                      productId: productsList[index].productId ?? 0,
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
                                imageUrl: '${productsList[index].imageUrl}',
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
                          child: Text('${productsList[index].title ?? ''}\n',
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