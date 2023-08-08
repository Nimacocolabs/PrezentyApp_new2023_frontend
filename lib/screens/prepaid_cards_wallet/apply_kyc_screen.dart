import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/state_data_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/terms_and_conditions_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_kyc_verify_otp_screen.dart';
import 'package:event_app/screens/splash_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../util/app_helper.dart';

class ApplyKycScreen extends StatefulWidget {
  ApplyKycScreen(
      {Key? key,
      required this.razorPayId,
      required this.cardId,
      required this.firstName,
      required this.lastName,
      required this.panNumber})
      : super(key: key);
  final String? razorPayId;
  final String cardId;
  final String firstName;
  final String lastName;
  final String panNumber;

  @override
  State<ApplyKycScreen> createState() => _ApplyKycScreenState();
}

class _ApplyKycScreenState extends State<ApplyKycScreen> {
  WalletBloc _walletBloc = WalletBloc();

  final TextEditingController firstNameControl = TextEditingController();
  final TextEditingController lastNameControl = TextEditingController();
  final TextEditingController phoneNumberControl = TextEditingController();
  final TextEditingController emailIdControl = TextEditingController();
  final TextEditingController panNumberControl = TextEditingController();

  //final TextEditingController aadhaarControl = TextEditingController();
  final TextEditingController dobControl = TextEditingController();
  final TextEditingController addressControl = TextEditingController();
  final TextEditingController permanentAddressControl = TextEditingController();
  final TextEditingController pinNumberControl = TextEditingController();
  final TextEditingController permanentPinNumberControl =
      TextEditingController();
  final TextEditingController cityControl = TextEditingController();
  final TextEditingController referredByControl = TextEditingController();

  String? addressType;
  States? selectedState;
  String? birthDateInString;
  DateTime? birthDate;
  bool? isDateSelected;
  String gender = "select";
  int _genderValue = 0;
  RxBool isChecked = false.obs;
  TermsAndConditionsData? terms_Conditions;

  final _formKey = GlobalKey<FormState>();
  FormatAndValidate formatAndValidate = FormatAndValidate();
  List<States> stateList = [];

  Future _getStateList() async {
    AppDialogs.loading();
    StateCodeResponse? response = await _walletBloc.getStateList();
    stateList = response?.data ?? [];
    AppDialogs.closeDialog();
    if (stateList.isEmpty) {
      Get.back();
      toastMessage('Unable to get states. Please try again');
    } else {
      setState(() {});
    }
  }

  Future<TermsAndConditionsData?> getTermsAndConditions() async {
    TermsAndConditionsData? data = (await _walletBloc.termsAndConditions());
    setState(() {
      terms_Conditions = data;
    });
    return terms_Conditions;
  }
  // late FocusNode focus;

  @override
  void initState() {
    super.initState();

    firstNameControl.text = widget.firstName;
    lastNameControl.text = widget.lastName;
    panNumberControl.text = widget.panNumber;

    emailIdControl.text = User.userEmail;
    phoneNumberControl.text = User.userMobile;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getStateList();
      getTermsAndConditions();
    });
  }

  @override
  void dispose() {
    _walletBloc.dispose();
//focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => MainScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 30,
                ),
                kycDataWidget(
                  // focus,
                  field: "First Name",
                  labelText: "first Name",
                  control: firstNameControl,
                  validate: formatAndValidate.validateName,
                  format: formatAndValidate.formatName(),
                ),

                kycDataWidget(
                  //focus,
                  field: "Last Name",
                  labelText: "last Name",
                  control: lastNameControl,
                  validate: formatAndValidate.validateName,
                  format: formatAndValidate.formatName(),
                ),
                kycDataWidget(
                  //focus,
                  field: "Phone number",
                  labelText: "Phone Number",
                  control: phoneNumberControl,
                  keyboardInputType: TextInputType.phone,
                  validate: formatAndValidate.validatePhoneNo,
                  format: formatAndValidate.formatPhone(),
                  enabled: false,
                ),
                kycDataWidget(
                  //focus,
                  field: "Email ID",
                  labelText: "Email ID",
                  control: emailIdControl,
                  keyboardInputType: TextInputType.emailAddress,
                  validate: formatAndValidate.validateEmailID,
                  format: formatAndValidate.formatEmail(),
                  enabled: false,
                ),
                kycDataWidget(
                  //focus,
                  field: "Date of Birth",
                  labelText: "YYYY-MM-DD",
                  control: dobControl,
                  keyboardInputType: TextInputType.number,
                  validate: formatAndValidate.validateDob,
                  format: formatAndValidate.formatDateOfBirth(),
                  suffixWid: _calenderDatePick(),
                ),
                // kycDataWidget(
                //   //focus,
                //   field: "Aadhaar number",
                //   control: aadhaarControl,
                //   keyboardInputType: TextInputType.number,
                //   labelText: "Aadhaar Card Number",
                //   validate: formatAndValidate.validateAadhaar,
                //   format: formatAndValidate.formatAadhaar(),
                // ),
                kycDataWidget(
                  // focus,
                  field: "PAN number",
                  labelText: "PAN Number",
                  control: panNumberControl,
                  keyboardInputType: TextInputType.text,
                  validate: formatAndValidate.validatePANCard,
                  format: formatAndValidate.formatPANCard(),
                ),
                Text(
                  "Gender",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  width: screenWidth - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      alignment: AlignmentDirectional.centerEnd,
                      underline: Container(),
                      elevation: 0,
                      // isDense: true,
                      iconSize: 30,
                      //  icon: Icon(Icons.arrow_downward_rounded),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 16),
                      value: _genderValue,
                      items: [
                        DropdownMenuItem(
                          child: Text("select"),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text("Male"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Female"),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("Other"),
                          value: 3,
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _genderValue = value as int;
                          value == 1
                              ? gender = "Male"
                              : value == 2
                                  ? gender = "Female"
                                  : gender = "Other";
                        });
                        print(_genderValue.toString);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                kycDataWidget(
                    //focus,
                    field: "Permanent Address",
                    labelText: "Enter",
                    control: addressControl,
                    validate: formatAndValidate.validateAddress,
                    format: formatAndValidate.formatAddress()),

                Text(
                  "NOTE: Please prevent @,#,%,\$,\&,+,=,*,"
                  ",! and white spaces while entering your address.",
                  style: TextStyle(color: Colors.red),
                ),

                SizedBox(
                  height: 20,
                ),

                kycDataWidget(
                    //focus,
                    field: "Pin Code",
                    labelText: "Enter",
                    control: pinNumberControl,
                    keyboardInputType: TextInputType.number,
                    validate: formatAndValidate.validatePinCode,
                    format: formatAndValidate.formatPinCode()),
                kycDataWidget(
                    //focus,
                    field: "City",
                    labelText: "Enter",
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
                // StreamBuilder<ApiResponse<StateCodeResponse>>(
                //     stream: _walletBloc.getStateListStream,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         switch (snapshot.data!.status!) {
                //           case Status.LOADING:
                //             return CommonApiLoader();
                //           case Status.COMPLETED:
                //             StateCodeResponse response = snapshot.data!.data!;
                //             return (response);
                //           case Status.ERROR:
                //             return CommonApiErrorWidget(
                //                 "${snapshot.data!.message!}", _getStateList);
                //         }
                //       }
                //       return SizedBox();
                //     }),
                _stateList(),
                SizedBox(
                  height: 20,
                ),

                kycDataWidget(
                  // focus,
                  field: "Referred person name",
                  labelText: "Referred person name",
                  control: referredByControl,
                  keyboardInputType: TextInputType.text,
                  validate: (v) {},
                  format: [],
                ),

                terms_Conditions != null
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade300)),
                        width: double.infinity,
                        height: 200,
                        child: Scrollbar(
                          thumbVisibility: true,
                          interactive: true,
                          child: ListView(
                            padding: EdgeInsets.all(4),
                            children: [
                              HtmlWidget('${terms_Conditions!.termsCondition}'),
                            ],
                          ),
                        ),
                      )
                    : Container(),

                Row(
                  children: [
                    Obx(() => Checkbox(
                        value: isChecked.value,
                        onChanged: (v) {
                          isChecked.value = v ?? false;
                        })),
                    Text.rich(
                      TextSpan(children: [
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'I accept ',
                          ),
                        )),
                        WidgetSpan(
                            // child: InkWell(
                            //     onTap: () async {
                            // if (await canLaunch(
                            //     termsAndConditionsCardUrl)) {
                            //   await launch(termsAndConditionsCardUrl);
                            // } else {
                            //   toastMessage(
                            //       'Unable to open url $termsAndConditionsCardUrl');
                            // }
                            // },
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        )
                            // )
                            )
                      ]),
                    ),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),

                TextButton(
                  onPressed: () {
                    if (selectedState == null) {
                      toastMessage('Select state');
                      return;
                    }
                    if (_formKey.currentState!.validate() &&
                        _genderValue != 0 &&
                        selectedState != null) {
                      if (!isChecked.value) {
                        toastMessage(
                            'Please accept the terms & conditions to continue');
                        return;
                      }
                      print("xxxxxxxx");

                      _sendOtp(
                          fName: firstNameControl.text,
                          lName: lastNameControl.text,
                          pan: panNumberControl.text,
                          dob: dobControl.text,
                          gender: gender,
                          address: addressControl.text,
                          pinCode: pinNumberControl.text,
                          city: cityControl.text,
                          //aadhaarNumber: aadhaarControl.text,
                          state: (selectedState?.stateId ?? 0).toString());
                    } else if (_genderValue == 0) {
                      toastMessage("Please select your gender");
                    } else {
                      toastMessage("Please fill all field with valid details");
                    }
                  },
                  child: Text(
                    "Create Wallet",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: secondaryColor,
                    fixedSize: Size(screenWidth, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    side: BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: secondaryColor.withOpacity(.8)),
                    primary: primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stateList() {
    // if(dropDownValue==null){
    //   dropDownValue =  response.data?.elementAt(response.data!.length-1);
    //   state = dropDownValue?.stateTitle;
    //   stateCode = dropDownValue?.stateId;
    // }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor, width: 2)),
      child: DropdownButton<States>(
        value: selectedState,
        isExpanded: true,
        // menuMaxHeight: 300,
        underline: SizedBox(),
        onChanged: (States? data) {
          setState(() {
            selectedState = data!;
          });
        },
        items: stateList.map<DropdownMenuItem<States>>((value) {
          return DropdownMenuItem<States>(
            value: value,
            child: Text(
              value.stateTitle ?? 'Select state',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54),
            ),
          );
        }).toList(),
      ),
    );

    //   return Container(
    //   width: screenWidth,
    //   decoration: BoxDecoration(
    //       border: Border.all(
    //           color: primaryColor, width: 2, style: BorderStyle.solid),
    //       borderRadius: BorderRadius.circular(10)),
    //   child: Padding(
    //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    //     child: DropdownButtonHideUnderline(
    //       child: DropdownButton<States>(
    //         style: TextStyle(color: secondaryColor),
    //         alignment: AlignmentDirectional.centerStart,
    //         hint: Text(
    //           "Select State",
    //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //         ),
    //         value: dropDownValue,
    //         items: response.data!.map((item) {
    //           // dropDownValue = item;
    //           return DropdownMenuItem<States>(
    //             onTap: (){
    //               dropDownValue = item;
    //                 state = item.stateTitle;
    //                 stateCode = item.stateId;
    //                 setState(() {});
    //             },
    //               value: dropDownValue,
    //               child: Text(item.stateTitle!,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w700,
    //                       color: Colors.black54,
    //                       fontSize: 16)));
    //         }).toList(),
    //         onChanged: (value) {
    //           // dropDownValue = value;
    //           // state = value!.stateTitle;
    //           // stateCode = value.stateId;
    //           // setState(() {});
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget kycDataWidget(
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
          textCapitalization: TextCapitalization.characters,
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

  _calenderDatePick() {
    return GestureDetector(
        child: new Icon(Icons.calendar_today, color: primaryColor),
        onTap: () async {
          final datePick = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(1900),
              lastDate: new DateTime(2100));
          if (datePick != null && datePick != birthDate) {
            setState(() {
              birthDate = datePick;
              isDateSelected = true;

              // put it here
              birthDateInString =
                  "${birthDate!.year}-${birthDate!.month}-${birthDate!.day}"; // 08/14/2019
              dobControl.text = birthDateInString!;
            });
          }
        });
  }

  Future _sendOtp(
      {String? fName,
      String? lName,
      //String? email,
      String? pan,
      String? dob,
      String? gender,
      String? address,
      String? pinCode,
      String? city,
      String? state,
      String? aadhaarNumber}) async {
    Map<String, dynamic> body = {};
    body["account_id"] = User.userId;
    body["first_name"] = fName;
    body["last_name"] = lName;
    body["email"] = User.userEmail;
    body["phone_number"] = User.userMobile;
    body["date_of_birth"] = dob;
    body["gender"] = gender;
    body["address_type"] = "PERMANENT";
    body["address"] = address;
    body["pin_code"] = pinCode;
    body["city"] = city;
    body["state_code"] = state;
    body["pan_number"] = pan!.toUpperCase();
    // body["aadhaar_number"] = aadhaarNumber;
    body["rzr_pay_id"] = widget.razorPayId!;
    body["referred_by"] = referredByControl.text.trim();
    body["card_id"] = widget.cardId;

    try {
      AppDialogs.loading();
      RegisterWalletResponse response = await _walletBloc.registerWallet(body);
      Get.back();
      if (response.success!) {
        toastMessage(response.message);
        print(response.data);
        Get.to(() => ApplyKycVerifyOtpScreen(
              verifyToken: response.data!.kycReferenceId!.toString(),
            ));
      } else {
        toastMessage('${response.message!}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }
}

class FormatAndValidate {
  static final RegExp alphaRegExp = RegExp('[a-zA-Z]');
  static final RegExp _numericRegExp = RegExp('[0-9]');
  static final RegExp _alphanumericRegExp = new RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp _drivingLicenceRegExp = RegExp(
      '^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}');
  static final RegExp emailRegExp = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  static final RegExp _addressRegExp = RegExp(r'^[a-zA-Z0-9\.\-\s\,\/]+$');
  static final RegExp _dobRegExp =
      RegExp('^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])');

  formatName() {
    return [FilteringTextInputFormatter.allow(alphaRegExp)];
  }

  formatPhone() {
    return [
      LengthLimitingTextInputFormatter(10),
      FilteringTextInputFormatter.digitsOnly
    ];
  }

  formatEmail() {
    return [FilteringTextInputFormatter.allow(emailRegExp)];
  }

  formatDateOfBirth() {
    return [LengthLimitingTextInputFormatter(10)];
  }

  formatAadhaar() {
    return [
      LengthLimitingTextInputFormatter(12),
      FilteringTextInputFormatter.digitsOnly
    ];
  }

  formatPANCard() {
    return [
      LengthLimitingTextInputFormatter(10),
      FilteringTextInputFormatter.allow(_alphanumericRegExp)
    ];
  }

  formatPassport() {
    return [
      LengthLimitingTextInputFormatter(8),
      FilteringTextInputFormatter.allow(_alphanumericRegExp)
    ];
  }

  formatDrivingLicence() {
    return [
      LengthLimitingTextInputFormatter(16),
      // FilteringTextInputFormatter.allow(_drivingLicenceRegExp)
    ];
  }

  formatAddress() {
    FilteringTextInputFormatter.allow(_addressRegExp);
  }

  formatPinCode() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(6)
    ];
  }

  validatePinCode(value) {
    String? x =
        value!.isEmpty || value.length != 6 ? "Enter 6 digit pin code" : null;
    print("xxxx");
    print(x.toString());
    return x;
  }

  validateAddress(value) {
    String? abc = value!.isEmpty || !_addressRegExp.hasMatch(value)
        ? "Enter valid Address"
        : null;
    print("aaa");
    print(abc.toString());
    return abc;
  }

  validateName(value) {
    String? bbb = value!.isEmpty || !alphaRegExp.hasMatch(value)
        ? "Enter valid name, space not allowed"
        : null;
    print("bbb");
    print(bbb.toString());
    return bbb;
  }

  validateDob(value) {
    String? dob = value!.isEmpty ||
            value.length > 10 ||
            value.length < 8 ||
            _dobRegExp.hasMatch(value)
        ? "Enter Date in format YYYY-MM-DD"
        : null;
    print("1321");
    print(dob.toString());
    return dob;
  }

  validateAadhaar(value) {
    return value!.isEmpty ||
            value.length != 12 ||
            !_numericRegExp.hasMatch(value) ||
            alphaRegExp.hasMatch(value)
        ? "Enter valid 12 digit Adhaar number"
        : null;
  }

  validatePANCard(value) {
    String? pan = value!.isEmpty ||
            value.length != 10 ||
            !alphaRegExp.hasMatch(value.substring(0,
                2)) //First three characters i.e. "XYZ" in the above PAN are alphabetic series running from AAA to ZZZ
            ||
            !alphaRegExp.hasMatch(value.substring(
                3)) //Fourth character i.e. "P" stands for Individual status of applicant.
            ||
            !alphaRegExp.hasMatch(value.substring(
                4)) //Fifth character i.e. "K" in the above PAN represents first character of the PAN holder's last name/surname.
            ||
            !_numericRegExp.hasMatch(value.substring(5,
                8)) //Next four characters i.e. "8200" in the above PAN are sequential number running from 0001 to 9999.
            ||
            !alphaRegExp.hasMatch(value.substring(
                9)) //Last character i.e. "S" in the above PAN is an alphabetic check digit.
        ? "Enter 10 digit valid PAN Card number"
        : null;
    print("abdddd123");
    print(pan.toString());
    return pan;
  }

  validatePassport(value) {
    return value!.isEmpty ||
            value.length != 8 ||
            !(alphaRegExp.hasMatch(value[0])) ||
            !(_numericRegExp.hasMatch(value.substring(1, 8)))
        ? "Enter 8 digit valid Passport ID"
        : null;
  }

  validateDrivingLicence(value) {
    return value.isEmpty ||
            value.length != 16 ||
            !(_drivingLicenceRegExp.hasMatch(value))
        ? "Enter 16 digit valid Driving licence number"
        : null;
  }

  validateVotersID(value) {
    return value.isEmpty ? "Enter valid voter's ID" : null;
  }

  validateEmailID(String? value) {
    bool? email;
    if (value!.trim().isEmail == true) {
      return null;
    } else {
      return "Enter valid email address";
    }
    // : "Enter valid email address";
    // print("adadhja@nsadnsa");
    // print(email);
    // return email;
  }

  validatePhoneNo(value) {
    String? phno = value.isEmpty ? "Enter phone number" : null;
    print("9685852556");
    print(phno);
    return phno;
  }
}
