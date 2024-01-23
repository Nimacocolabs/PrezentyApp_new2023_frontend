import 'dart:async';
import 'dart:convert';

import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/gateway_key_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/apply_card_tax_info_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/get_physical_order_id_model.dart';
import 'package:event_app/models/wallet&prepaid_cards/request_physical_card_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/state_data_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/user_permanent_address_model.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_kyc_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/getsucessupi.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/Component/upiresponse.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/succes_or_failed_common_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestPhysicalCard extends StatefulWidget {
  const RequestPhysicalCard(
      {Key? key, required this.kitNumber, required this.cardNumber,required this.entityid})
      : super(key: key);
  final String kitNumber;
  final String cardNumber;
  final String entityid;

  @override
  State<RequestPhysicalCard> createState() => _RequestPhysicalCardState();
}

enum Address { permanent, temporary }

class _RequestPhysicalCardState extends State<RequestPhysicalCard> {
  WalletBloc _walletBloc = WalletBloc();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController addressControl = TextEditingController();

  final TextEditingController pinNumberControl = TextEditingController();
  final TextEditingController permanentPinNumberControl =
      TextEditingController();
  final TextEditingController cityControl = TextEditingController();
  FormatAndValidate formatAndValidate = FormatAndValidate();
  UserPermanentAddressData? permanentAddressData;
  String accountId = User.userId;
  String? state;
  String? permanentState;
  States? dropDownValue;
  States? permanentDropdownValue;
  int? stateCode;
  int? permanentStateCode;
  String? permanentAddressValue;
  bool permanentAddress = true;
  Address _address = Address.permanent;
    late Razorpay _razorPay;
    OrderModel? orderModelData;
     ApplyCardTaxInfoData? taxInfoData;
    

  Future _getStateList() async {
    _walletBloc.getStateList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getStateList();
      userPermanentAddress();
      getPhysicalCardRequestAmount();
//getupcard("");
      setState(() {});
    });
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == "AppLifecycleState.resumed") {
        // The app has resumed from the background
        // Call your API for status check here
        await getupistatus();
      }
      return null;
    });
  }

  @override
  void dispose() {
    _walletBloc.dispose();

    super.dispose();
  }

  Future userPermanentAddress() async {
    permanentAddressData = await _walletBloc.getUserPermanentAddress(accountId);
    permanentAddress = true;
    setState(() {});
    print(permanentAddressData);
  }
   Future getPhysicalCardRequestAmount() async {
    taxInfoData = await _walletBloc.getPhysicalCardRequestAmount(accountId);

    setState(() {});
  }

_requestPhysicalCardModalSheet() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: StatefulBuilder(
                builder: (BuildContext context, setState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Payment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListView(shrinkWrap: true, children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        rupeeSymbol +
                                            ' ${taxInfoData?.amount ?? "0"}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'GST',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${taxInfoData?.gst ?? "0"}%',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Payable Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        rupeeSymbol +
                                            ' ' +
                                            (taxInfoData?.payableAmount ?? '0'),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                    //   await requestCardPayment(widget.kitNumber,widget.entityid);
                              showPaymentConfirmationDialog(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  'Pay  $rupeeSymbol${taxInfoData?.payableAmount ?? 0}'),
                            ),
                          ),
                        ),
                      ],
                    )),
          );
        });
  }
  void showPaymentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Confirmation'),
          content: Text('Are you sure you want to make the payment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                await getupcard("10");
                // Perform the payment logic here
                // For example, you can call a function to initiate the payment
                // If the payment is successful, you can close the dialog
                // If the payment fails, you can show an error message or handle it accordingly
                // For this example, let's just close the dialog

              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();

              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Center(
              child: TextButton(
            onPressed: () async {
              if (!permanentAddress) {
                if (state == 'Select State') {
                  toastMessage('Select state');
                  return;
                }

                if (!_formKey.currentState!.validate()) {
                  toastMessage("Enter all fields");
                  return;
                }
              }
              await _requestPhysicalCardModalSheet();
              
            },
            child: Text(
              "Request Physical Card",
              style: TextStyle(fontSize: 16),
            ),
            style: TextButton.styleFrom(
              primary: secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: secondaryColor,
                      width: 2,
                      style: BorderStyle.solid)),
              fixedSize: Size(screenWidth, 50),
            ),
          )),
        ),
      ),
     appBar: CommonAppBarWidget(
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Deliver Card to address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      dense: false,
                      title: const Text('Permanent'),
                      leading: Radio<Address>(
                        value: Address.permanent,
                        groupValue: _address,
                        onChanged: (Address? value) {
                          setState(() {
                            _address = value!;
                            permanentStateCode=permanentAddressData!.stateCode;
                            permanentAddressValue=permanentAddressData!.addressCard;
                            permanentDropdownValue = null;
                            permanentAddress = true;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      dense: false,
                      title: const Text('Temporary'),
                      leading: Radio<Address>(
                        value: Address.temporary,
                        groupValue: _address,
                        onChanged: (Address? value) async {
                          await _getStateList();
                          setState(() {
                            dropDownValue = null;
                            _address = value!;
                            permanentAddress = false;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              permanentAddress
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Permanent Address',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText:
                                    "${permanentAddressData?.addressCard ?? ""}",
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: Colors.black12)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8)),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Pin Code',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText:
                                    "${permanentAddressData?.pinCode ?? ""}",
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: Colors.black12)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8)),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'City',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "${permanentAddressData?.city ?? ""}",
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: Colors.black12)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8)),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Select State",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                         Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "${permanentAddressData?.stateName  ?? ""}",
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: Colors.black12)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8)),
                          ),
                        ),
                       
                      ],
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textField(
                              //focus,
                              field: "Temporary Address",
                              labelText: "Enter address",
                              control: addressControl,
                              validate: formatAndValidate.validateAddress,
                              format: formatAndValidate.formatAddress()),
                          textField(
                              //focus,
                              field: "Pin Code",
                              labelText: "Enter pin code",
                              control: pinNumberControl,
                              keyboardInputType: TextInputType.number,
                              validate: formatAndValidate.validatePinCode,
                              format: formatAndValidate.formatPinCode()),
                          textField(
                              //focus,
                              field: "City",
                              labelText: "Enter city",
                              control: cityControl,
                              validate: formatAndValidate.validateName,
                              keyboardInputType: TextInputType.name),
                          Text(
                            "Select State",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<ApiResponse<dynamic>>(
                              stream: _walletBloc.getStateListStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status!) {
                                    case Status.LOADING:
                                      return CommonApiLoader();
                                    case Status.COMPLETED:
                                      StateCodeResponse response =
                                          snapshot.data!.data!;
                                      return _stateList(response);
                                    case Status.ERROR:
                                      return CommonApiErrorWidget(
                                          "${snapshot.data!.message!}",
                                          _getStateList());
                                  }
                                }
                                return SizedBox();
                              }),
                        ],
                      )),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _requestPhysicalCard() async {
    if (permanentAddress) {
      try {
        RequestPhysicalCardResponse response =
            await _walletBloc.requestPhysicalCard(
                User.userId, widget.kitNumber, widget.cardNumber, '0',stateCode: permanentAddressData!.stateCode.toString(),address:permanentAddressData!.addressCard.toString());
        if (response.success!) {
           Get.off(() => SuccessOrFailedScreen(isSuccess: true,content: "${response.message}.",));
          
        } else {
            Get.off(() => SuccessOrFailedScreen(isSuccess: false,content: "${response.message}.",));
        }
      } catch (e, s) {
        Completer().completeError(e, s);
        
      }
    }  else {
      try {
        RequestPhysicalCardResponse response =
            await _walletBloc.requestPhysicalCard(
                User.userId, widget.kitNumber, widget.cardNumber, '1',
                address: addressControl.text,
                pinCode: pinNumberControl.text,
                city: cityControl.text,
                stateCode: stateCode.toString());

        if (response.success!) {
          toastMessage(response.message);

          
        } else {
          toastMessage(response.message);
        }
      } catch (e, s) {
        Completer().completeError(e, s);
        
      }
    }
  }

  Widget _permanentStateList(StateCodeResponse response) {
   
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: TextStyle(color: secondaryColor),
            alignment: AlignmentDirectional.centerStart,
            // disabledHint: Text(permanentDropdownValue?.stateTitle ?? ""),
            // hint: Text(
            //   " Select States",
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            // ),
            value: permanentDropdownValue,
            items: response.data!.map((item) {
              permanentDropdownValue = item;

              return DropdownMenuItem(
                  value: permanentDropdownValue!,
                  child: Text(permanentDropdownValue!.stateTitle!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 16)));
            }).toList(),
            onChanged: null,
          ),
        ),
      ),
    );
  }

  Widget _stateList(StateCodeResponse response) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
          border: Border.all(
              color: primaryColor, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: TextStyle(color: secondaryColor),
            alignment: AlignmentDirectional.centerStart,
            hint: Text(
              " Select States",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            value: dropDownValue,
            items: response.data!.map((item) {
              dropDownValue = item;

              return DropdownMenuItem(
                  value: dropDownValue!,
                  child: Text(dropDownValue!.stateTitle!,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                          fontSize: 16)));
            }).toList(),
            onChanged: (States? value) {
              dropDownValue = value;
              state = value!.stateTitle;
              stateCode = value.stateId;
              setState(() {});
              print("hhii ${stateCode}");
            },
          ),
        ),
      ),
    );
  }

  Widget textField(
      //FocusNode focus,
      {String? field,
      String? labelText,
      TextEditingController? control,
      TextInputType? keyboardInputType = TextInputType.text,
      Widget? suffixWid,
      validate,
      List<TextInputFormatter>? format,
      bool? enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field!,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          enabled: enabled,
          controller: control,
          keyboardType: keyboardInputType!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: format,
          validator: (value) => validate(value),
          cursorHeight: 24,
          //onEditingComplete: () => field == "City"?focus.unfocus(): focus.unfocus(),
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus!.unfocus(),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black54),
          decoration: InputDecoration(
            suffixIcon: suffixWid,
            hintText: labelText,
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: primaryColor)),
            border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: primaryColor)),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

 requestCardPayment(String kitNo,entityId) async {

    String key = await  getGatewayKey();
    if (key.isEmpty) {
      toastMessage('Unable to get payment key');

    } else {
       orderModelData = await getPhycialCardOrderId(kitNo,entityId);
        String orderId = orderModelData?.orderId??'';

      if (orderId.isEmpty) {
        toastMessage('Unable to get order');
      } else {
        try {
          _razorPay = Razorpay();
          _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                  (PaymentSuccessResponse paymentSuccessResponse) {
                toastMessage('Payment successful');
                Get.back();
               
                  Future.delayed(Duration(milliseconds: 100), () async {
            //          Map<String,dynamic> paymentNotes={
            //   "type": "PHYSICALCARD",
            //   "user_id": User.userId,
            //   "card_id": orderModelData!.cardId,
            //   'order_id': orderModelData?.orderId,
            //   "amount": orderModelData?.convertedAmount,
            //   'state_code': '',
            //   'address':'',
             
             
            //   "signature":paymentSuccessResponse.signature,
            //   "payment_id":paymentSuccessResponse.paymentId,
              
            // }; 
       await _requestPhysicalCard();
            
            
                    Get.offAll(() => WalletHomeScreen(isToLoadMoney: false,));
                    
                  
                });
              });
          _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,
                  (PaymentFailureResponse paymentFailureResponse) {
                _onPaymentErrorFn(paymentFailureResponse);
              });

          _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});

          var options = {
            'key': key,
              "amount": orderModelData?.convertedAmount,
           'order_id': orderModelData?.orderId,
            'currency': "INR",
            'name': 'Prezenty',
            'description': 'Payment',
            'prefill': {
              'name': '${User.userName}',
              'contact': '${User.userMobile}',
              'email': '${User.userEmail}'
            },
            'notes': {
              "type": "PHYSICALCARD",
              "user_id": User.userId,
              "card_id": orderModelData!.cardId,
              'order_id': orderModelData?.orderId, 
              "amount": orderModelData?.convertedAmount,
              'state_code': permanentAddress ? permanentAddressData?.stateCode.toString() :stateCode ,
              'address': permanentAddress ? permanentAddressData?.addressCard.toString() : addressControl.text,
            }
          };

          debugPrint('options:'+jsonEncode(options));

          _razorPay.open(options);
          return true;
        } catch (e, s) {
          Completer().completeError(e, s);
          toastMessage('Unable to start payment. Please try again');
          return false;
        }
      }
    }
  }
 Future<String> getGatewayKey() async {
    try {
      AppDialogs.loading();
      final response = await ApiProviderPrepaidCards()
          .getJsonInstance()
          .get(Apis.getRazorpayGateWayKey);
      GatewayKeyResponse _gatewayKeyResponse =
          GatewayKeyResponse.fromJson(jsonDecode(response.data));
      Get.back();
      return _gatewayKeyResponse.apiKey ?? '';
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return '';
  }

  Future<OrderModel?>  getPhycialCardOrderId(String kitNo,entityid)async {

    try {
      AppDialogs.loading();
      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
          '${Apis.getPhysicalOrderId}',
          data: {
            "entity_id":entityid,
            "kit_no":kitNo
      });
      OrderModel getPhysicalResponse =
          OrderModel.fromJson(jsonDecode(response.data));

      Get.back();
      return getPhysicalResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

int taxid= 0
;  Future<paymentupiResponse?> getupcard(String amount) async {
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upilink}',
        data: {
          "amount": 5,
          "type": "cardreq",
        },
      );

      paymentupiResponse getupiResponse =
      paymentupiResponse.fromJson(response.data);
      print("response->${getupiResponse}");
      taxid = getupiResponse.data!.txnTblId!;


      // Check if the API call was successful before launching the URL
      if (getupiResponse != null && getupiResponse.statusCode==200) {
        // Replace 'your_url_here' with the actual URL you want to launch
        String url = 'your_url_here';

        // Launch the URL
        await launch("${getupiResponse.data!.paymentLink}");


      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }
  // Future<void> checkPaymentStatus() async {
  //   try {
  //     final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
  //         '${Apis.upistatus}',
  //         data: {
  //           "txn_tbl_id": taxid,
  //
  //         },
  //     );
  //     print('API call for status check completed.');
  //   } catch (e) {
  //     // Handle errors
  //     print('Error checking payment status: $e');
  //   }
  // }
  Future<UpiSucess?> getupistatus() async {
    try {

      final response = await ApiProviderPrepaidCards().getJsonInstancecard().post(
        '${Apis.upistatus}',
        data: {
          "txn_tbl_id": taxid,

        },
      );

      UpiSucess getupiResponse =
      UpiSucess.fromJson(response.data);
      print("response->${getupiResponse}");



      // Check if the API call was successful before launching the URL
      if (getupiResponse != null && getupiResponse.statusCode==200) {
        // Replace 'your_url_here' with the actual URL you want to launch
        showStatusAlert("${getupiResponse.data!.message}");

      toastMessage("${getupiResponse.data!.message}");

      }else{
        showStatusAlert("${getupiResponse.data!.message}");
      }

      return getupiResponse;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
    return null;
  }

  void showStatusAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },);
  }

  _onPaymentErrorFn(PaymentFailureResponse response) {
    Get.back();
    String msg = '';
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      msg = 'Payment Has Been Cancelled';
    } else if (response.code == Razorpay.NETWORK_ERROR) {
      msg = 'Network Issues while payment request';
    } else {
      msg = 'Payment Error, Try after some time';
    }

    AppDialogs.message(msg);
  }
}
