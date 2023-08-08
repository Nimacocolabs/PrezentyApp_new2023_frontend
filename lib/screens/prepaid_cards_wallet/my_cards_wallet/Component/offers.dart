import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../bloc/wallet_bloc.dart';
import '../../../../models/offer_response.dart';
import '../../../../network/api_response.dart';
import '../../../../widgets/CommonApiErrorWidget.dart';
import '../../../../widgets/CommonApiLoader.dart';
import '../../../../widgets/CommonApiResultsEmptyWidget.dart';

class Offers extends StatefulWidget {
  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  WalletBloc _walletBloc = WalletBloc();
  String viewExpand = "More";

  @override
  void initState() {
    super.initState();
    getOffersList();
  }

  Future getOffersList() async {
    _walletBloc.getOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const BackButton(),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(Icons.home_outlined),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: screenWidth,
        height: 30,
        color: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Offers",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
    SizedBox(
    height: 20,
    ),
    StreamBuilder<ApiResponse<dynamic>>(
    stream: _walletBloc.OfferListStream,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    switch (snapshot.data!.status!) {
    case Status.LOADING:
    return CommonApiLoader();
    case Status.COMPLETED:
    OffersResponse response = snapshot.data!.data!;
    if((response.data ??[]).isEmpty) {
    return Center(
        widthFactor: 2,
        heightFactor: 2,
        child:
    CommonApiResultsEmptyWidget('No offers to show'));
    }
    return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    primary: true,
    shrinkWrap: true,
    itemCount: (response.data ??[]).length,
    itemBuilder: ((context, index) {
    return _offersList(response.data![index]);
    }));
    case Status.ERROR:
    return CommonApiErrorWidget(
    "${snapshot.data!.message!}", getOffersList());
    }
    }
    return SizedBox();
    }),
    ],
    ),
    )
      )
    );
  }

  Widget _offersList(Data cardData) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 0, color: Colors.transparent),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: cardData.imageUrl ?? "",
                imageBuilder: (context, imageProvider) => Container(
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.black12,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.contain),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Center(
                  child: Image.asset('assets/images/no_image.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardData.title!,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HtmlWidget(
                cardData.description!,
              
              ),
            ),
                  // (viewExpand != 'More')
                  //     ? Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     cardDetailsData.longDescription!,
                  //     style: TextStyle(
                  //         color: Colors.black54, fontSize: 14, height: 2),
                  //   ),
                  // )
                  //     : Container(),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(),
                  //     GestureDetector(
                  //       onTap: () {
                  //         viewExpand != 'More'
                  //             ? viewExpand = 'More'
                  //             : viewExpand = 'Less';
                  //         setState(() {});
                  //       },
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(right: 10.0, bottom: 4),
                  //         child: Text(
                  //           viewExpand,
                  //           style: TextStyle(
                  //               color: primaryColor, fontWeight: FontWeight.w600),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                ],
            ),
          ),
      );

        }


  }


  // _listView() {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: 2,
  //       itemBuilder: (BuildContext context, index) {
  //         return Card(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10)),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "Offer ${index}",
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     "Lorem Ipsum is simply dummy \n Lorem Ipsum is simply dummy",
  //                     style: TextStyle(
  //                       color: Colors.blueGrey,
  //                       fontSize: 10,
  //                     ),
  //                   ),
  //                   (viewExpand != 'More')
  //                       ? Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text(
  //                             "long description long description long description long description long description long description long description long description long description long description long description",
  //                             style: TextStyle(
  //                                 color: Colors.black54,
  //                                 fontSize: 12,
  //                                 height: 2),
  //                           ),
  //                         )
  //                       : Container(),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Container(),
  //                       GestureDetector(
  //                         onTap: () {
  //                           viewExpand != 'More'
  //                               ? viewExpand = 'More'
  //                               : viewExpand = 'Less';
  //                           setState(() {});
  //                         },
  //                         child: Padding(
  //                           padding:
  //                               const EdgeInsets.only(right: 10.0, bottom: 4),
  //                           child: Text(
  //                             viewExpand,
  //                             style: TextStyle(
  //                                 color: primaryColor,
  //                                 fontWeight: FontWeight.w600),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ));
  //       });
