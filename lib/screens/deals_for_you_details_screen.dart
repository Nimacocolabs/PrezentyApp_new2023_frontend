import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/woohoo/woohoo_product_bloc.dart';
import 'package:event_app/models/woohoo/deals_for_you_products_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_details_screen.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealsForYouDetailsScreen extends StatefulWidget {
  final bool isDealsForYou;
  final bool isBackToCampus;
  const DealsForYouDetailsScreen({Key? key,required this.isDealsForYou,required this.isBackToCampus}) : super(key: key);

  @override
  State<DealsForYouDetailsScreen> createState() => _DealsForYouDetailsScreenState();
}

class _DealsForYouDetailsScreenState extends State<DealsForYouDetailsScreen> {
   WoohooProductBloc _woohooBloc = WoohooProductBloc();
    
 
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
   _woohooBloc.dealsForYouProducts();
   _woohooBloc.backToCampusProducts();
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
    child: Text("Offers for you",
    style: TextStyle(

      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20
    ),),
  ),
),

widget.isDealsForYou ?
SizedBox(
      width: screenWidth,
      
      child: StreamBuilder<ApiResponse<dynamic>>(
          stream:_woohooBloc.dealsProductsStream,
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
                  DealsForYouProductsModel response =
                      snapshot.data!.data!;

                  
                final productsResponse = response.data;
                  
                  return dealsForYouProductsList(productsResponse!);

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
      )
      : SizedBox(
      width: screenWidth,
      
      child: StreamBuilder<ApiResponse<dynamic>>(
        stream:_woohooBloc.backToCampusProductStream,
        builder: (context, snapshot) {
          print("aaaa");
          if (snapshot.hasData && snapshot.data?.status != null) {
            switch (snapshot.data!.status!) {
              case Status.LOADING:
                print("ccccc");
                return CommonApiLoader();
              case Status.COMPLETED:
                print("dddd");
                DealsForYouProductsModel response =
                    snapshot.data!.data!;

                
              final productsResponse = response.data;
                
                return backToCampusProductsList(productsResponse!);

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
    ),
      )
    );  
  }
dealsForYouProductsList(List<DealsForYouProductsData> dealsProductsList){
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
            itemCount: dealsProductsList.length,
       itemBuilder: (BuildContext context,int index){
        
        return InkWell(
 onTap: () async {
 if(User.apiToken.isEmpty){
  await Get.to(() => LoginScreen(isFromWoohoo: false));
 }
 else{
 await Get.to(() => WoohooVoucherDetailsScreen(
                      productId: dealsProductsList[index].productId ?? 0,
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
                                imageUrl: '${dealsProductsList[index].imageUrl}',
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
                          child: Text('${dealsProductsList[index].title ?? ''}\n',
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
 backToCampusProductsList(List<DealsForYouProductsData> backToCampusProductsList){
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
            itemCount: backToCampusProductsList.length,
       itemBuilder: (BuildContext context,int index){
        
        return InkWell(
 onTap: () async {
 if(User.apiToken.isEmpty){
  await Get.to(() => LoginScreen(isFromWoohoo: false));
 }
 else{
 await Get.to(() => WoohooVoucherDetailsScreen(
                      productId: backToCampusProductsList[index].productId ?? 0,
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
                                imageUrl: '${backToCampusProductsList[index].imageUrl}',
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
                          child: Text('${backToCampusProductsList[index].title ?? ''}\n',
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