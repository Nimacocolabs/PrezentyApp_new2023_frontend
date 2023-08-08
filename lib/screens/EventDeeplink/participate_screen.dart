import 'dart:convert';
import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/models/event_details.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:event_app/util/string_validator.dart';
import 'package:get/get.dart';

class ParticipateScreen extends StatefulWidget {
  final int eventId;
  final EventDetailsResponse eventDetails;
  final bool isFromDynamicLink;

  const ParticipateScreen(
      {Key? key,
      required this.eventId,
      required this.eventDetails,
      required this.isFromDynamicLink})
      : super(key: key);

  @override
  _ParticipateScreenState createState() => _ParticipateScreenState();
}

class _ParticipateScreenState extends State<ParticipateScreen> {
  TextFieldControl _textFieldControlFirstName = TextFieldControl();
  TextFieldControl _textFieldControlLastName = TextFieldControl();
  TextFieldControl _textFieldControlEmail = TextFieldControl();
  TextFieldControl _textFieldControlMobile = TextFieldControl();
  TextFieldControl _textFieldControlAddress = TextFieldControl();

  int? isPhysicallyAttending;
  int? receiveFood = 1;
  bool eventHasFoodVoucher = false;

  // bool? isGiftNotApplicable ;

  EventBloc _bloc = EventBloc();

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            TitleWithSeeAllButton(title: "Join this event(Rsvp)"),
            _buildPhysicallyAttendOrNot(),
            //_buildNeedFoodOrNot(),
            _buildAddressInfo(),

            Padding(
              padding: EdgeInsets.all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: _validateSubmit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _init() {
    eventHasFoodVoucher = true;

    if (User.userName.isNotEmpty) {
      List names = [];
      String name = User.userName;
      if (name.contains('  ')) {
        names = name.split('  ');
        _textFieldControlFirstName.controller.text = names[0];
        _textFieldControlLastName.controller.text = names[1];
      } else if (name.contains(' ')) {
        names = name.split(' ');
        _textFieldControlFirstName.controller.text = names[0];
        _textFieldControlLastName.controller.text = names[1];
      } else {
        _textFieldControlFirstName.controller.text = name;
      }
    }

    _textFieldControlEmail.controller.text = User.userEmail;
    _textFieldControlMobile.controller.text = User.userMobile;
    _textFieldControlAddress.controller.text = User.userAddress;
  }

  _setPhysicallyAttend(int? value) {
    if (isPhysicallyAttending != value) {
      receiveFood = null;
    }
    if (value == 0) receiveFood = 1;
    setState(() {
      isPhysicallyAttending = value;
    });
  }

  _setReceiveFood(int? value) {
    setState(() {
      receiveFood = value;
    });
  }

  Widget _buildRadioButton(
      {required int value,
      required int? groupValue,
      required String text,
      required void Function(int?) onChange}) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black))
      ],
    );
  }

  Widget _buildPhysicallyAttendOrNot() {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
      margin: EdgeInsets.fromLTRB(10, 12, 10, 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabelWidget("Choice of presence?"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              _buildRadioButton(
                  value: 1,
                  groupValue: isPhysicallyAttending,
                  text: 'Physically',
                  onChange: _setPhysicallyAttend),
              SizedBox(
                width: 12,
              ),
              _buildRadioButton(
                  value: 0,
                  groupValue: isPhysicallyAttending,
                  text: 'Virtually',
                  onChange: _setPhysicallyAttend),
            ]),
          ),
        ],
      ),
    );
  }

  // Widget _buildNeedFoodOrNot(){
  //   if (isPhysicallyAttending == 0 && eventHasFoodVoucher) {
  //     return Container(
  //       alignment: FractionalOffset.center,
  //       padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
  //       margin: EdgeInsets.fromLTRB(10, 12, 10, 15),
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: primaryColor.withOpacity(0.2),
  //               spreadRadius: 3,
  //               blurRadius: 4,
  //               offset: Offset(0, 2), // changes position of shadow
  //             ),
  //           ]),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           _buildLabelWidget("Do you want to receive food?"),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(children: [
  //               _buildRadioButton(
  //                   value: 1,
  //                   groupValue: receiveFood,
  //                   text: 'Yes',
  //                   onChange: _setReceiveFood),
  //               SizedBox(
  //                 width: 12,
  //               ),
  //               _buildRadioButton(
  //                   value: 0,
  //                   groupValue: receiveFood,
  //                   text: 'No',
  //                   onChange: _setReceiveFood),
  //             ]),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     return SizedBox();
  //   }
  // }

  Widget _buildAddressInfo() {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
      margin: EdgeInsets.fromLTRB(10, 12, 10, 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabelWidget("Add your details"),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              children: [
                Expanded(
                  child: AppTextBox(
                    enabled: !User.userName.contains('  '),
                    textFieldControl: _textFieldControlFirstName,
                    hintText: 'First Name',
                    keyboardType: TextInputType.name,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: AppTextBox(
                    enabled: !User.userName.contains('  '),
                    textFieldControl: _textFieldControlLastName,
                    hintText: 'Last Name',
                    keyboardType: TextInputType.name,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: AppTextBox(
              hintText: 'Email',
              enabled: User.userEmail.isEmpty || !User.userEmail.isValidEmail(),
              textFieldControl: _textFieldControlEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: AppTextBox(
              hintText: 'Mobile',
              textFieldControl: _textFieldControlMobile,
              enabled: User.userMobile.isEmpty ||
                  !User.userMobile.isValidMobileNumber(),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: AppTextBox(
              hintText: 'Address',
              enabled: User.userAddress.isEmpty,
              textFieldControl: _textFieldControlAddress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelWidget(String txt) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      alignment: FractionalOffset.centerLeft,
      child: Text(
        "$txt",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _validateSubmit() {
    bool isValidated = true;

    if (isPhysicallyAttending == null) {
      toastMessage(
          'Please choose whether you physically participate in the event');
      isValidated = false;
    } else if (isPhysicallyAttending == 0 &&
        eventHasFoodVoucher &&
        receiveFood == null) {
      toastMessage('Please choose whether you need to receive food');
      isValidated = false;
    }

    if (!validateInput()) {
      isValidated = false;
    }

    if (isValidated) _participate();
  }

  bool validateInput() {
    String _address = _textFieldControlAddress.controller.text.trim();
    String _email = _textFieldControlEmail.controller.text.trim();
    String _phone = _textFieldControlMobile.controller.text.trim();
    String firstName = _textFieldControlFirstName.controller.text.trim();
    String lastName = _textFieldControlLastName.controller.text.trim();

    if (firstName.isEmpty) {
      toastMessage('Please provide your first name');
      _textFieldControlFirstName.focusNode.requestFocus();
    } else if (!firstName.isAlphabetOnly) {
      toastMessage('First name should contain only alphabets');
      _textFieldControlFirstName.focusNode.requestFocus();
    } else if (lastName.isEmpty) {
      toastMessage('Please provide your last name');
      _textFieldControlLastName.focusNode.requestFocus();
    } else if (!lastName.isAlphabetOnly) {
      toastMessage('Last name should contain only alphabets');
      _textFieldControlLastName.focusNode.requestFocus();
    } else if (!_email.isValidEmail()) {
      toastMessage('Please provide a valid email id');
      _textFieldControlEmail.focusNode.requestFocus();
    } else if (!_phone.isValidMobileNumber()) {
      toastMessage('Please provide a valid mobile number');
      _textFieldControlMobile.focusNode.requestFocus();
    } else if (_address.isEmpty) {
      toastMessage('Please provide your address');
      _textFieldControlAddress.focusNode.requestFocus();
    } else {
      print('input validate ok');
      return true;
    }
    return false;
  }

  _participate() async {
    Map<String, dynamic> bodyParams = {};
    bodyParams["event_id"] = widget.eventId;
    bodyParams["is_attending"] = isPhysicallyAttending;
    bodyParams["need_food"] = receiveFood ?? 0;
    bodyParams["name"] =
        '${_textFieldControlFirstName.controller.text.trim()}  ${_textFieldControlLastName.controller.text.trim()}';
    bodyParams["email"] = _textFieldControlEmail.controller.text.trim();
    bodyParams["phone"] = _textFieldControlMobile.controller.text.trim();
    bodyParams["address"] = _textFieldControlAddress.controller.text.trim();

    print(jsonEncode(bodyParams));

    await _bloc.participateEvent(bodyParams, widget.isFromDynamicLink);

    // _bloc.participateEvent(bodyParams).then((value) async {
    //  EventParticipateSuccess response = value;
    //   if (response.success == true) {
    //     if(User.apiToken.isEmpty){
    //      await SharedPrefs.setString(SharedPrefs.spGuestUserEmail, bodyParams['email']);
    //     }
    //
    //     ChatData.chatUserEmail = bodyParams["email"];
    //
    //     toastMessage( response.message ?? "Successfully processed your request");
    //     Get.back(result: true);
    //   } else {
    //     toastMessage( response.message ?? StringConstants.apiFailureMsg);
    //   }
    // }).catchError((err) {
    //   CommonWidgets().showNetworkErrorDialog(err?.toString());
    // });
  }
}
