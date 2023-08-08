import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/send_food_bloc.dart';
import 'package:event_app/models/send_food_participant_list_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/woohoo/woohoo_voucher_list_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/CommonApiResultsEmptyWidget.dart';
import 'package:event_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendFoodVoucherListParticipants extends StatefulWidget {
  final int eventId;
  final String eventAccount;

  const SendFoodVoucherListParticipants({Key? key, required this. eventId, required this.eventAccount, }) : super(key: key);

  @override
  _SendFoodVoucherListParticipantsState createState() => _SendFoodVoucherListParticipantsState();
}

class _SendFoodVoucherListParticipantsState extends State<SendFoodVoucherListParticipants>  {

  SendFoodVoucherBloc _bloc = SendFoodVoucherBloc();
  List<String> selectedList = [];

  @override
  void initState() {
    super.initState();
print("id of event  =${widget.eventId}");
    _bloc.getParticipantList(widget.eventId);
  }


  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            child: _buildUserWidget(),
          ),
        ),),
    );
  }

  _buildUserWidget() {
    return Column(
      children: [
      Container(
        margin: EdgeInsets.fromLTRB(12,8,8,0),
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Send Food Vouchers',
                style: TextStyle(
                    fontSize: 16,
                    // color: color2,
                    fontWeight: FontWeight.w500),
              ),
            ),
            // GestureDetector(
            //   onTap: () async {
            //    bool? b =  await Get.to(()=>ChooseFoodVoucherScreen(isEdit: true,));
            //
            //    if(b??false){
            //      // Get.close(2);
            //      Get.off(()=>MyEventDetailsScreen(eventId: widget.eventId,reloadFiles: false,));
            //    }
            //   },
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 8,),
            //     padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
            //     decoration: BoxDecoration(
            //         color: secondaryColor,
            //         borderRadius: BorderRadius.circular(8)
            //     ),
            //     child: Text('Edit Food Voucher',style: TextStyle(color: Colors.white),),),
            // ),
          ],
        ),
      ),
        Expanded(
          child: StreamBuilder<ApiResponse<dynamic>>(
              stream: _bloc.participantListStream,
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if (snapshot.hasData) {
                  switch (snapshot.data!.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator(),);
                    case Status.COMPLETED:
                      return _buildList( _bloc.participantsList);
                    case Status.ERROR:
                      return Text('${snapshot.data!.message!}');
                  }
                }
                return SizedBox();
              }
          ),

        ),


      ],
    );
  }





Widget _buildList(List<Participant> list){
  if(list.isEmpty) return CommonApiResultsEmptyWidget('No participants to send food voucher');

    return  Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildEachParticipantItem(list[index]);
            },
          ),
        ),
        Container(
          height: 50.0,
          width: double.infinity,
          color: secondaryColor,
          child: CommonButton(
              buttonText: "Next",
              bgColorReceived: secondaryColor,
              borderColorReceived: secondaryColor,
              textColorReceived: Colors.white,
              buttonHandler: _validate
          ),
        ),
      ],
    );
}


  _buildEachParticipantItem(Participant participant) {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              value: selectedList.any((element) => element == participant.id),
              onChanged: (value) {
                if(selectedList.contains(participant.id)){
                  selectedList.remove(participant.id!);
                }else{
                  if(selectedList.length >= 5){
                    toastMessage('Maximum 5 vouchers can only be sent at a time');
                    return;
                  }
                  selectedList.add(participant.id??'');
                }
                setState(() { });
              }),
          ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 50,
                height: 50,
                child:ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${participant.email}',
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/ic_person_avatar.png'),
                  ),
                ),
              )),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              alignment: FractionalOffset.centerLeft,
              child: Text(
                '${participant.name}',
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            flex: 1,
          ),

          if(selectedList.any((element) => element == participant.id))
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                // color: secondaryColor,
                border: Border.all(
                  color: Colors.black.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if(participant.count>1){
                      participant.count--;
                      setState(() {});
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage('assets/images/ic_minus.png'),
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                FittedBox(
                  child: Text('${participant.count}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black )),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: (){
                    if(participant.count==4){
                      toastMessage('Select maximum of 4');
                    }
                    else{
                      participant.count++;
                      setState(() {});
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage('assets/images/ic_add.png'),
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  _validate() async {
      if(selectedList.isEmpty){
        toastMessage('Please select at least one participant to send food voucher');
      }else {

        List<Participant> selectedParticipantList = [];

        _bloc.participantsList.forEach((element) {
          if(selectedList.contains(element.id)){
            selectedParticipantList.add(element);
          }
        });

        Get.to(() => WoohooVoucherListScreen(redeemData: RedeemData.sendFood(widget.eventId, selectedParticipantList,widget.eventAccount),showBackButton:true,showAppBar: true,eventId: widget.eventId.toString(),));

        // if(data!=null){
        //   woohooVoucherId = '${data['id']}';
        //   denomination='${data['denomination']}';
        //   WoohooProductDetail productDetail = data['product'];
        //
        //   _createOrder(productDetail);
        //
        //   // int? id = await Get.to(()=>SendFoodVoucherInvoiceScreen(orderID:orderId, participants: list, eventId: widget.eventId,woohooVoucherId : data['id']));
        //   // if(id!=null){
        //   //   orderId = id;
        //   // }
        // }
      }
  }

  // List<Participant> selectedParticipantList = [];
  // String woohooVoucherId = '';
  // String denomination ='';

}